import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:broom_main_vscode/user.dart';
import 'package:broom_main_vscode/user_provider.dart';
import 'package:broom_main_vscode/view/user_list.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

// o valor 10.2.2.2:3000 é a forma de nós acessarmos o locahost do
// nosso pc via emulador
final String host = dotenv.env['API_URL']!;
Uri url = Uri.http(host, '/register');
Uri urlLogin = Uri.http(host, '/login');
Uri urlListContractors = Uri.http(host, '/list/contractors');
Uri urlListDiarists = Uri.http(host, '/list/diarists');
Uri urlImg =
    Uri.http(host, '/file/db56558ca8eeb4267759dd3e9b616f1e');

Future<void> register(Map<String, dynamic> user) async {
  // verificação muito foda hehehe
  try {
    var resp = await http.post(url,
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(user));

    final response = jsonDecode(resp.body) as Map<String, dynamic>;
    if (resp.statusCode == 201) {
      return response['data'];
    } else {
      throw Exception(response['message']);
    }
  } catch (err) {
    print(err);
  }
}

Future<void> login(String email, String password) async {
  // verificação muito foda hehehe
  try {
    var resp = await http.post(urlLogin,
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(
            <String, String>{'email': email, 'auth_password': password}));

    final response = jsonDecode(resp.body) as Map<String, dynamic>;
    if (resp.statusCode == 201) {
      return response['data'];
    } else {
      throw Exception(response['message']);
    }
  } catch (err) {
    print(err);
  }
}

Future<List<ListUsers>> fetchUsuarios(String token) async {
  final response = await http.get(
    urlListContractors,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token', // Passa o token no cabeçalho
    },
  );

  if (response.statusCode == 200) {
    // Parse da resposta para uma lista de objetos Usuario
    List<dynamic> data = jsonDecode(response.body);

    return data.map((json) => ListUsers.fromJson(json)).toList();
  } else {
    throw Exception('Falha ao carregar dados');
  }
}

Future<Uint8List> fetchUserImage(String imageName, String token) async {
  final response = await http.get(Uri.http('10.0.2.2:3000', '/file/$imageName'),
      headers: {'Authorization': 'Bearer $token'});
  if (response.statusCode == 200) {
    return response.bodyBytes;
  } else {
    throw Exception('Falha ao carregar imagem');
  }
}
