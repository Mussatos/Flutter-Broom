import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:broom_main_vscode/user.dart';
import 'package:broom_main_vscode/user_provider.dart';
import 'package:broom_main_vscode/view/user_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:broom_main_vscode/utils/user_autentication.dart';

UserAutentication autentication = UserAutentication();
final String host = dotenv.env['API_URL']!;
Uri urlRegister = Uri.http(host, '/register');
Uri urlLogin = Uri.http(host, '/login');
Uri urlListContractors = Uri.http(host, '/list/contractors');
Uri urlListDiarists = Uri.http(host, '/list/diarists');
//URL de Prod do backend: https://broom-api.onrender.com/
Uri urlViewDiarist = Uri.http(host, '');

Future<void> register(Map<String, dynamic> user) async {
  try {
    var resp = await http.post(urlRegister,
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(user));

    final response = jsonDecode(resp.body) as Map<String, dynamic>;
    if (resp.statusCode == 201) {
      print(response);
    } else {
      throw Exception('Falha ao cadastrar usuário');
    }
  } catch (err) {
    print(err);
  }
}

Future<bool> login(String email, String password) async {
  bool isLogged = false;
  try {
    var resp = await http.post(urlLogin,
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(
            <String, String>{'email': email, 'auth_password': password}));

    final response = jsonDecode(resp.body) as Map<String, dynamic>;
    if (resp.statusCode == 201) {
      isLogged = true;
      await autentication.setToken(response['access_token']);
      await autentication.setProfileId(response['data']['profile_id']);
      await autentication.setUserId(response['data']['id']);

      return isLogged;
    } else {
      throw Exception();
    }
  } catch (err) {
    return isLogged;
  }
}

Future<List<ListUsers>> fetchUsuarios() async {
  final token = await autentication.getToken();
  final userProfileId = await autentication.getProfileId();
  try {
    final response = await http.get(
      getListUrl(userProfileId),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => ListUsers.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar dados');
    }
  } catch (err) {
    print(err);
    return [];
  }
}

Uri getListUrl(int? userProfileId) {
  return userProfileId == 1 ? urlListDiarists : urlListContractors;
}

Future<Uint8List?> fetchUserImage(String imageName) async {
  final token = await autentication.getToken();

  try {
    final response = await http.get(Uri.http(host, '/file/$imageName'),
        headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Falha ao carregar imagem');
    }
  } catch (err) {
    print(err);
    return null;
  }
}

Future<UserModel> fetchUsuario(int? id) async {
  final token = await autentication.getToken();
  final userProfileId = await autentication.getProfileId();
  try {
    final response = await http.get(
      getViewUrl(userProfileId, id),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      return UserModel.fromJson(data);
    } else {
      throw Exception('Falha ao carregar dados');
    }
  } catch (err) {
    print(err);
    return UserModel(
        name: 'aa',
        lastName: 'aa',
        cellphoneNumber: '67',
        userImage: 'sfas',
        description: '',
        address: [],
        wantService: false,
        gender: 'a',
        email: 'a@a');
  }
}

Uri getViewUrl(int? userProfileId, int? id) {
  return userProfileId == 1
      ? Uri.http(host, '/diarist/${id}')
      : Uri.http(host, '/contractor/${id}');
}
