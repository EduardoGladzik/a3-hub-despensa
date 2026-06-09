import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

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
    if (_image == null) return;

    // url do backend
    var uri = Uri.parse('http://10.0.2.2:8000/api/invoices/');
    var request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('img_captured', _image!.path));

    // valores fixos backend
    request.fields['user'] = '1';
    request.fields['destined_storage'] = '1';

    var response = await request.send();
    if (response.statusCode == 201) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Upload realizado com sucesso!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Escanear Nota")),
      body: Row(
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