import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  Future<bool> uploadInvoice(File imageFile) async {
    var uri = Uri.parse('$baseUrl/invoices/');

    try {
      // cria um request
      var request = http.MultipartRequest('POST', uri);
      // recebe imagem
      var multipartFile = await http.MultipartFile.fromPath('img_captured', imageFile.path);
      request.files.add(multipartFile);

      print('Enviando imagem...');

      // envia o request
      var response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Nota processada pelo OCR');
        // JSON de resposta
        //var responseData = await response.stream.byteToString();
        //var data = json.decode(responseData);
        return true;
      } else {
        print('Erro. Código: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Erro de comunicação com o backend: $e');
      return false;
    }
  }
}