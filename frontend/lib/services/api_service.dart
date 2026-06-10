import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://192.168.101.21:8000/api';

  Future<bool> uploadInvoice(File imageFile) async {
    var uri = Uri.parse('$baseUrl/invoices/');

    try {
      // cria um request
      var request = http.MultipartRequest('POST', uri);
      
      // campos obrigatórios injetados manualmente
      request.fields['user'] = '3';
      request.fields['destined_storage'] = '2';
      
      // recebe imagem
      var multipartFile = await http.MultipartFile.fromPath('img_captured', imageFile.path);
      request.files.add(multipartFile);

      // envia o request
      var response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        // JSON de resposta
        //var responseData = await response.stream.byteToString();
        //var data = json.decode(responseData);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}