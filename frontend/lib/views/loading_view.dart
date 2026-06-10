import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/views/storage_view.dart';
import '../services/api_service.dart';

class LoadingView extends StatefulWidget {
  // exige a imagem da nota
  final File imageFile;
  const LoadingView({super.key, required this.imageFile});

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> {
  String _statusMessage = 'Enviando imagem...';
  
  @override
  void initState() {
    super.initState();
    _processInvoice();
  }

  Future<void> _processInvoice() async {
    ApiService apiService = ApiService();
    bool success = await apiService.uploadInvoice(widget.imageFile);

    if (success) {
      setState(() {
        _statusMessage = 'Sucesso no processamento da nota.';
      });
      // routing para StorageView
    } else {
      setState(() {
        _statusMessage = 'Erro no processamento. Tente novamente.';
      });
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) Navigator.pop(context);
    }
    
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const StorageView()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: Colors.white),
            const SizedBox(height: 32),
            Text(
              _statusMessage,
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
      ),
    );
  }
}