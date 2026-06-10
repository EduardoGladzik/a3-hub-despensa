import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'loading_view.dart';

class ScannerView extends StatefulWidget {
  const ScannerView({super.key});

  @override
  State<ScannerView> createState() => _ScannerViewState();
}

class _ScannerViewState extends State<ScannerView> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImageCamera() async {
    // Captura imagem via camera
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

    Future<void> _pickImageGallery() async {
    // Captura imagem via galeria
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }


  Future<void> _uploadInvoice() async {
    // se _image estiver vazio o método é interrompido
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tire uma foto ou selecione um imagem na galeria antes de enviar.')),
      );
      return;
    } 
    
    // Roteia o usuário para a tela de carregamento
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoadingView(imageFile: _image!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Escanear Nota")),
      body: Column(
        children: [
          Expanded(child: _image == null ? const Icon(Icons.camera_alt, size: 100) : Image.file(_image!)),
          ElevatedButton(onPressed: _pickImageCamera, child: const Text("Escanear Imagem")),
          ElevatedButton(onPressed: _pickImageGallery, child: const Text("Escolher da Galeria")),
          ElevatedButton(onPressed: _uploadInvoice, child: const Text("Enviar nota")),
        ],
      ),
    );
  }
}