import 'package:flutter/material.dart';
import 'scanner_view.dart';
import 'storage_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Bem vindo(a)!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
              ),
            ),
            _buildActionCard(
              context,
              icon: Icons.camera_alt,
              title: 'Escanear Nota Fiscal',
              subtitle: 'Use a câmera para escanear uma nota fiscal e extrair os dados automaticamente.',
              color: Colors.blueAccent,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ScannerView()));
              },
            ),
            SizedBox(height: 16.0),
            _buildActionCard(
              context,
              icon: Icons.kitchen,
              title: 'Minhas despensas',
              subtitle: 'Gerencie suas despensas.',
              color: Colors.orangeAccent,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const StorageView()));
              },
            ),
          ],
        ),
      ),
    );
  } 
}

Widget _buildActionCard(BuildContext context, {
  required IconData icon,
  required String title,
  required String subtitle,
  required Color color,
  required VoidCallback onTap,
}) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: color.withValues(alpha: 0.15),
              child: Icon(icon, size: 32, color: color),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4.0),
                  Text(subtitle, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 20),
          ],
        ),
      ),
    ),
  );
}