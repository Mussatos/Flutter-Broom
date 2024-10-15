import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:broom_main_vscode/user.dart';
import 'package:broom_main_vscode/user_provider.dart';
import 'package:broom_main_vscode/view/user_list.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:broom_main_vscode/utils/user_autentication.dart';

UserAutentication autentication = UserAutentication();
//URL de Prod do backend: https://broom-api.onrender.com
const String host = 'broom-api.onrender.com';
Uri urlRegister = Uri.https(host, '/register');
Uri urlLogin = Uri.https(host, '/login');
Uri urlListContractors = Uri.https(host, '/list/contractors');
Uri urlListDiarists = Uri.https(host, '/list/diarists');
Uri urlViewDiarist = Uri.https(host, '');

Future<bool> register(Map<String, dynamic> user) async {
  try {
    var resp = await http.post(urlRegister,
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(user));

    final response = jsonDecode(resp.body) as Map<String, dynamic>;
    if (resp.statusCode == 201) {
      await autentication.setToken(response['access_token']);
      await autentication.setProfileId(response['user']['profile_id']);
      await autentication.setUserId(response['user']['id']);
      return true;
    } else {
      throw Exception('Falha ao cadastrar usuário');
    }
  } catch (err) {
    print(err);
    return false;
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
    final response = await http.get(Uri.https(host, '/file/$imageName'),
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
      ? Uri.https(host, '/diarist/${id}')
      : Uri.https(host, '/contractor/${id}');
}

Future<void> createAddress(Map<String, dynamic> payload) async {
  final token = await autentication.getToken();

  try {
    final http.Response response = await http.post(
      Uri.https(host, '/address'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Endereço criado com sucesso!');
      print('Resposta: ${response.body}');
    } else {
      print('Falha ao criar endereço. Código: ${response.statusCode}');
      print('Erro: ${response.body}');
    }
  } catch (e) {
    print('Ocorreu um erro: $e');
  }
}

Future<Address?> getAddressByUserId() async {
  final userId = await autentication.getUserId();
  final token = await autentication.getToken();

  try {
    final http.Response response = await http.get(
      Uri.https(host, '/address/$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> addressData = jsonDecode(response.body);
      return Address.fromJson(addressData);
    } else {
      print('Falha ao obter o endereço. Código: ${response.statusCode}');
      print('Erro: ${response.body}');
      return null;
    }
  } catch (e) {
    print('Ocorreu um erro: $e');
    return null;
  }
}

Future<Yourself?> getUserById() async {
  final userId = await autentication.getUserId();
  final token = await autentication.getToken();

  try {
    final http.Response response = await http.get(
      Uri.https(host, '/user/$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print(response);
    if (response.statusCode == 200) {
      final Map<String, dynamic> userData = jsonDecode(response.body);
      return Yourself.fromJson(userData);
    } else {
      print(
          'Falha ao obter os dados do usuário. Código: ${response.statusCode}');
      print('Erro: ${response.body}');
    }
  } catch (e) {
    print('Ocorreu um erro: $e');
  }
}

Future<List<Address>> fetchAddress() async {
  final id = await autentication.getUserId();
  final token = await autentication.getToken();

  final String url = '$host/address/$id';

  try {
    final response = await http.get(
      Uri.https(host, '/address/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Address.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar dados');
    }
  } catch (err) {
    print(err);
    return [];
  }
}

Future<void> deleteAddress(int? idDoEndereco) async {
  final token = await autentication.getToken();

  try {
    final response = await http.delete(
      Uri.https(host, '/address/$idDoEndereco'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print("Endereço deletado com sucesso!");
    } else {
      print("Erro ao deletar o endereço: ${response.statusCode}");
      print("Mensagem do servidor: ${response.body}");
    }
  } catch (e) {
    print("Ocorreu um erro: $e");
  }
}

Future<void> updateAddress(
    int? addressId, Map<String, dynamic> addressData) async {
  final token = await autentication.getToken();
  final String url = '$host/address/$addressId';

  try {
    final response = await http.put(
      Uri.https(host, '/address/$addressId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(addressData),
    );

    if (response.statusCode == 200) {
      print("Endereço atualizado com sucesso!");
    } else {
      print("Erro ao atualizar o endereço: ${response.statusCode}");
      print("Mensagem do servidor: ${response.body}");
    }
  } catch (e) {
    print("Ocorreu um erro: $e");
  }
}

Future<void> updateUser(Map<String, dynamic> usersData) async {
  final token = await autentication.getToken();
  final userId = await autentication.getUserId();
  final String url = '$host/user/$userId';

  try {
    final response = await http.put(
      Uri.https(host, '/user/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(usersData),
    );

    if (response.statusCode == 200) {
      print("Perfil atualizado com sucesso!");
    } else {
      print("Erro ao atualizar o perfil: ${response.statusCode}");
      print("Mensagem do servidor: ${response.body}");
    }
  } catch (e) {
    print("Ocorreu um erro: $e");
  }
}

class ApiService {
  Future<String?> sendContract({
    required List<String?> tiposDeServico,
    required String? tipoLimpeza,
    required bool? possuiPets,
    required bool? possuiMaterialLimpeza,
    required int? quantidadeRoupaLavar,
    required int? quantidadeRoupaPassar,
    required int? quantidadeQuarto,
    required int? quantidadeBanheiro,
    required int? quantidadeSala,
    required String mensagem,
    required int id,
  }) async {
    final token = await autentication.getToken();

    Map<String, dynamic> body = {
      "tiposDeServico": tiposDeServico,
      "tipoLimpeza": tipoLimpeza,
      "possuiPets": possuiPets,
      "possuiMaterialLimpeza": possuiMaterialLimpeza,
      "qntRoupaLavar": quantidadeRoupaLavar,
      "qntRoupaPassar": quantidadeRoupaPassar,
      "comodos": [
        {
          "tipo": "quarto",
          "quantidade": quantidadeQuarto,
        },
        {
          "tipo": "banheiro",
          "quantidade": quantidadeBanheiro,
        },
        {
          "tipo": "sala",
          "quantidade": quantidadeSala,
        },
      ],
      "mensagem": mensagem,
    };

    try {
      final response = await http.post(
        Uri.https(host, '/contract/sendContract/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        print('Contrato enviado com sucesso!');
        var link = jsonDecode(response.body);
        return link['link'];
      } else {
        throw Exception('Falha ao enviar contrato');
      }
    } catch (e) {
      return '';
    }
  }
}

Future sendImage(PlatformFile file) async {
  final token = await autentication.getToken();
  final userId = await autentication.getUserId();
  var request =
      http.MultipartRequest('POST', Uri.https(host, '/user/upload/$userId'));
  request.headers['Authorization'] = 'Bearer $token';
  request.files.add(await http.MultipartFile.fromBytes(
    'file',
    file.bytes!,
    filename: file.name,
  ));

  final res = await request.send();
  return res.stream.bytesToString();
}

Future<Map<String, dynamic>> fetchCEP(String cep) async {
  try {
    var response = await http.get(Uri.https('viacep.com.br', '/ws/$cep/json/'));

    if (response.statusCode == 200) {
      Map<String, dynamic> CEP = json.decode(response.body);
      return CEP;
    } else {
      throw Exception();
    }
  } catch (e) {
    return {
      "cep": "",
      "logradouro": "",
      "complemento": "",
      "unidade": "",
      "bairro": "",
      "localidade": "",
    };
  }
}
