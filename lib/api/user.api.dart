import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:broom_main_vscode/user.dart';
import 'package:broom_main_vscode/user_provider.dart';
import 'package:broom_main_vscode/view/user_list.dart';
import 'package:http/http.dart' as http;

// o valor 10.2.2.2:3000 é a forma de nós acessarmos o locahost do
// nosso pc via emulador
Uri url = Uri.http('10.0.2.2:3001', '/register');
Uri urlLogin = Uri.http('10.0.2.2:3001', '/login');
Uri urlListContractors = Uri.http('10.0.2.2:3001', '/list/contractors');
Uri urlListDiarists = Uri.http('10.0.2.2:3001', '/list/diarists');
Uri urlImg =
    Uri.http('10.0.2.2:3001', '/file/db56558ca8eeb4267759dd3e9b616f1e');

Future<void> register(Map<String, dynamic> user) async {
  // verificação muito foda hehehe
  try {
    var resp = await http.post(url,
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(user));
    print('${resp.statusCode}');
    print('${resp.body}');

    final response = jsonDecode(resp.body) as Map<String, dynamic>;
    if (resp.statusCode == 201) {
      print('${response['data']}');
      //User user = User.fromJson(response['data']);
      //print('${user.}');
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
    print('${resp.statusCode}');
    print('${resp.body}');

    final response = jsonDecode(resp.body) as Map<String, dynamic>;
    if (resp.statusCode == 201) {
      print('${response['data']}');
      //User user = User.fromJson(response['data']);
      //print('${user.birthday}');
    } else {
      throw Exception(response['message']);
    }
  } catch (err) {
    print(err);
  }
}

Future<List<ContractModel>> fetchUsuarios(String token) async {
  final response = await http.get(
    urlListContractors,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token', // Passa o token no cabeçalho
    },
  );
  print('${response.statusCode}');
  print('${response.body}');
  if (response.statusCode == 200) {
    // Parse da resposta para uma lista de objetos Usuario
    List<dynamic> data = jsonDecode(response.body);
    print(data);
    List<ContractModel> batata =
        data.map((json) => ContractModel.fromJson(json)).toList();
    print('sexo');
    print(batata);
    return data.map((json) => ContractModel.fromJson(json)).toList();
  } else {
    throw Exception('Falha ao carregar dados');
  }
}
