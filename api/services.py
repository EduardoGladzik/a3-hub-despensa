import easyocr
import re
from rapidfuzz import process, fuzz
from datetime import date, timedelta
from .models import Invoice, StorageIngredient, Ingredient

reader = easyocr.Reader(['pt'], gpu=False)

def clean_string(text):
    """
    Limpa a string removendo caracteres especiais, números e convertendo para minúsculo.
    """
    text_lower = text.lower()
    text_no_special = re.sub(r'[^\w\s]', ' ', text_lower)
    text_no_numbers = re.sub(r'\d+', ' ', text_no_special)
    text_clean = re.sub(r'\s+', ' ', text_no_numbers).strip()
    return text_clean


def list_ingredients():
    """
    Retorna uma lista de nomes de ingredientes cadastrados no banco de dados.
    """
    all_ingredients = list(Ingredient.objects.all())
    ingredient_names = [ing.name for ing in all_ingredients]

    if not ingredient_names:
        print("Aviso: Nenhum ingrediente cadastrado no banco de dados para comparar.")
        return []
    
    return ingredient_names


def extract_quantity(text_line):
    """
    Extrai a quantidade de um item a partir de uma linha de texto.
    """
    # Remove números que possam ser códigos de barras ou outros identificadores longos
    text_without_barcodes = re.sub(r'\d{5,}', '', text_line)

    # Procura por um número seguido de "UN"
    match = re.search(r'(\d+)\s*(UN)?', text_line, re.IGNORECASE)
    if match:
        return float(match.group(1))

    # Busca por todos os números na linha, ignorando aqueles que parecem ser códigos de barras
    numbers = re.findall(r'\d+', text_without_barcodes)

    # Busca o primeiro número que seja maior que 0 e menor que 100
    for num_str in numbers:
        val = float(num_str)
        if 0 < val < 100:
            return val
    
    # Fallback: se nenhum número válido for encontrado, retorna 1.0 como quantidade padrão
    return 1.0


def match_ingredients(extracted_text, ingredient_names, threshold=75.0):
    """
    Retorna uma lista de dicionários contendo os ingredientes encontrados e suas quantidades
    """
    matched_items = []
    if not ingredient_names:
        return matched_items

    # Cria um dicionário para mapear os nomes dos ingredientes em minúsculo para os nomes originais do banco de dados
    catalog_mapping = {ing.lower(): ing for ing in ingredient_names}

    # Normaliza os nomes dos ingredientes para comparação usando RapidFuzz
    normalized_catalog = [ing.lower() for ing in ingredient_names]

    lines = extracted_text.split('\n')
    
    for line in lines:
        line_raw = line.strip()
        if not line_raw:
            continue

        # Remove caracteres não alfabéticos para evitar falsos positivos em palavras curtas
        letters_only = re.sub(r'[^a-zA-Z]+', '', line_raw)
        if len(letters_only) <= 4:
            continue

        # Aplica a limpeza na linha
        line_clean = clean_string(line_raw)
        if not line_clean:
            continue
        
        # Usa o RapidFuzz para encontrar a melhor correspondência no catálogo de ingredientes
        match = process.extractOne(
            line_clean, 
            normalized_catalog, 
            scorer=fuzz.partial_ratio,
        )

        if match:
            best_match_name = match[0]
            score = match[1]

            if score >= threshold:
                quantity = extract_quantity(line_clean)
                original_db_name = catalog_mapping[best_match_name]

                print(f"MATCH ENCONTRADO: OCR('{line_clean}') == BANCO('{original_db_name}') | Score: {score:.2f} | Qtd: {quantity}")

                matched_items.append({
                    "name": original_db_name,
                    "quantity": quantity
                })

            else:
                pass

    return matched_items


def update_storage(matched_items, invoice):
    """
    Recebe os itens filtrados e atualiza a despensa
    """
    for item in matched_items:
        # pega a instância do banco
        matched_ingredient = Ingredient.objects.get(name=item["name"])
        quantity = item["quantity"]

        # verifica se o item já existe na despensa de destino
        existing_item = StorageIngredient.objects.filter(
            storage=invoice.destined_storage,
            ingredient=matched_ingredient,
        ).first()

        # se existir, atualiza a quantidade, caso contrário, cria um novo registro
        if existing_item:
            existing_item.current_quantity += quantity
            existing_item.save()
            print(f"Atualizado '{matched_ingredient.name}' para {existing_item.current_quantity} unidades no estoque.")
        else:
            StorageIngredient.objects.create(
                storage=invoice.destined_storage,
                ingredient=matched_ingredient,
                current_quantity=quantity,
                expiration_date=date.today() + timedelta(days=30)
            )
            print(f"Adicionado '{matched_ingredient.name}' com {quantity} unidades ao estoque.")


def process_invoice_pipeline(extracted_text, invoice):
    """
    Função Orquestradora.
    Executa o pipeline completo de processamento da nota fiscal, desde a extração do texto até a atualização do estoque.
    """
    # pega os nomes dos ingredientes cadastrados
    ingredient_names = list_ingredients()

    # compara o texto extraído 
    matched_items = match_ingredients(extracted_text, ingredient_names)

    # atualiza o banco de dados com os resultados
    if matched_items:
        update_storage(matched_items, invoice)
    else:
        print("Nenhum ingrediente correspondente encontrado para atualizar o estoque.")


def process_invoice(invoice_id):
    """
    Função Worker.
    Extrai o texto da imagem e aciona a Orquestradora.
    """
    try:
        # busca a nota fiscal no banco de dados através do ID
        invoice = Invoice.objects.get(id=invoice_id)

        # lê a imagem (OCR)
        img_path = invoice.img_captured.path
        result = reader.readtext(img_path, detail=0)
        extracted_text = "\n".join(result)

        # atualiza a nota fiscal com o texto extraído e a legibilidade
        invoice.extracted_text = extracted_text
        if extracted_text.strip():
            invoice.legibility_score = True
        invoice.save()

        print(f"Texto extraído da nota fiscal (ID: {invoice_id})")

        # executa o pipeline de processamento da nota fiscal
        process_invoice_pipeline(extracted_text, invoice)

        print(f"Processamento da nota fiscal (ID: {invoice_id}) concluído com sucesso.")

    except Exception as e:
        print(f"Erro ao processar a nota fiscal: {e}")