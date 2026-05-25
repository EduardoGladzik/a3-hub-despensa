import easyocr
from .models import Invoice, StorageIngredient, Ingredient

reader = easyocr.Reader(['pt'], gpu=False)

def process_invoice(invoice_id):
    """
    Processa a nota fiscal usando OCR e (no futuro) atualiza o banco de dados com os resultados utilizando lógica difusa.
    """
    
    try:
        invoice = Invoice.objects.get(id=invoice_id)

        img_path = invoice.img_captured.path
        result = reader.readtext(img_path, detail=0)
        extracted_text = "\n".join(result)

        invoice.extracted_text = extracted_text
        if extracted_text.strip():
            invoice.legibility_score = True
        invoice.save()
    
        # lógica difusa no futuro

    except Exception as e:
        print(f"Erro ao processar a nota fiscal: {e}")