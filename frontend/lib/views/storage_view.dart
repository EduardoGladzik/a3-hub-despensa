import 'package:flutter/material.dart';

class StorageView extends StatefulWidget {
  const StorageView({super.key});

  @override
  State<StorageView> createState() => _StorageViewState();
}

class _StorageViewState extends State<StorageView> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _pantryItems = [];

  @override
  void initState() {
    super.initState();
    _fetchPantryItems();
  }

  Future<void> _fetchPantryItems() async {
    // Requisição ao django
    // final response = await http.get(Uri.parse(''));
    // if (response.statusCode == 200) { converter JSON e atualizar o estado}

    // simulação do tempo de resposta
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        // Dados simulados
        _pantryItems = [
          {'name': 'Arroz Tio João', 'quantity': 5.0, 'unit': 'KG'},
          {'name': 'Feijão Carioca', 'quantity': 2.0, 'unit': 'KG'},
          {'name': 'Óleo de Soja', 'quantity': 1.0, 'unit': 'UN'},
          {'name': 'Macarrão Espaguete', 'quantity': 3.0, 'unit': 'UN'},
          {'name': 'Molho de Tomate', 'quantity': 2.0, 'unit': 'UN'},
        ];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha Despensa'),
        backgroundColor: Colors.orangeAccent,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[100],
      body: _isLoading
        ? const Center(child: CircularProgressIndicator(color: Colors.orangeAccent))
        : _pantryItems.isEmpty 
        ? const Center(
          child: Text(
            'Sua despensa está vazia.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        )
      : ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: _pantryItems.length,
          itemBuilder: (context, index) {
            final item = _pantryItems[index];
            return Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 12.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                leading: CircleAvatar(
                  backgroundColor: Colors.orange[100],
                  child: const Icon(Icons.kitchen, color: Colors.orange),
                ),
                title: Text(
                  item['name'],
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                ),
                trailing: Text(
                  '${item['quantity']} ${item['unit']}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.green,
                  ),
                ),
              ),
            );
          },
        ),
    );
  }
}