import 'package:flutter/material.dart';

class LoadingView extends StatefulWidget {
  const LoadingView({super.key});

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> {
  @override
  void initState() {
    super.initState();
    _waitForProcessing();
  }

  Future<void> _waitForProcessing() async {
    // simulação do tempo de processamento
    await Future.delayed(const Duration(seconds: 4));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nota processada com sucesso!')),
      );
      // Futuramente roteamento para despensa
      //Teste temporário
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 32),
            Text(
              "Analisando a nota fiscal...",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 12),
            Text(
              "Extraindo os produtos para sua despensa.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16
              ),
            ),
          ],
        ),
      ),
    );
  }
}