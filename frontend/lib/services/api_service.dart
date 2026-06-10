import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'http://192.168.101.21:8000/api';

  Future<bool> uploadInvoice(File imageFile) async {
    var uri = Uri.parse('$baseUrl/invoices/');

    try {
      // cria um request
      var request = http.MultipartRequest('POST', uri);
      
      // campos obrigatórios injetados manualmente para o MVP
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

  Future<List<dynamic>> getStorageItems() async {
    // hardcoded apenas para o MVP
    var uri = Uri.parse('$baseUrl/storages/2/ingredients/');

    try {
      print('DEBUG: REQUISITANDO ITENS DA DESPENSA');
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        print('DEBUG: ITENS RECEBIDOS COM SUCESSO');
        // converte json em Lista para que o dart entenda
        return json.decode(utf8.decode(response.bodyBytes));
      } else {
        print('DEBUG: ERRO AO CARREGAR A DESPENSA: CÓDIGO: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('DEBUG: ERRO DE COMUNIÇÃO NO GET: $e');
      return [];
    }
  }
}