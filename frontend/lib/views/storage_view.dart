import 'package:flutter/material.dart';
import '../services/api_service.dart';

class StorageView extends StatefulWidget {
  const StorageView({super.key});

  @override
  State<StorageView> createState() => _StorageViewState();
}

class _StorageViewState extends State<StorageView> {
  final ApiService _apiService = ApiService();
  late Future<List<dynamic>> _storageItems;

  @override
  void initState() {
    super.initState();
    _storageItems = _apiService.getStorageItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha Despensa'),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _storageItems,
        builder: (context, snapshot) {
          // estado de carregamento
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Estado de erro
          else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar a despensa: ${snapshot.error}'));
          }

          // Estado de sucesso, mas vazio
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'A sua depensa está vazia',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              )
            );
          }

          // estado de sucesso com dados
          List<dynamic> items = snapshot.data!;
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              var item = items[index];

              String name = item['ingredient']['name'] ?? 'Produto desconhecido';
              String quantity = item['current_quantity']?.toString() ?? '1';
              String unit = item['ingredient']['measure_unit']  ?? 'UN';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                elevation: 2,
                child: ListTile(
                  leading: const Icon(Icons.fastfood, color: Colors.orange),
                  title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Quantidade: $quantity $unit'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Funcionalidade a caminho...')),
                      );
                    }
                  )
                )
              );
            }
          );
        }
      )
    );
  }
}