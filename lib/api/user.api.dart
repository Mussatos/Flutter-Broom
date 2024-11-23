import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:broom_main_vscode/models/bank_info.model.dart';
import 'package:broom_main_vscode/user.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:broom_main_vscode/utils/user_autentication.dart';

UserAutentication autentication = UserAutentication();
//URL de Prod do backend: https://broom-api.onrender.com/
const String host = 'localhost:3000';
// localhost:3000
Uri urlRegister = Uri.http(host, '/register');
Uri urlLogin = Uri.http(host, '/login');
Uri urlViewDiarist = Uri.http(host, '');
Uri urlForgetPassword = Uri.http(host, '/forget');
Uri urlResetPassword = Uri.http(host, '/reset');
Uri urlPaymentIntent = Uri.http(host, '/payment');
Uri urlPaymentCheckout = Uri.http(host, '/payment/checkout');
Uri urlAddress = Uri.http(host, '/address');

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
      await autentication.setUserEmail(response['user']['email']);
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
      await autentication.setUserEmail(response['data']['email']);

      return isLogged;
    } else {
      throw Exception();
    }
  } catch (err) {
    return isLogged;
  }
}

Future<bool> forgetPassword(String email) async {
  try {
    var resp = await http.post(urlForgetPassword,
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(<String, String>{'email': email}));

    if (resp.statusCode == 201) {
      return true;
    } else {
      throw Exception();
    }
  } catch (err) {
    return false;
  }
}

Future<bool> resetPassword(String token, String password) async {
  try {
    final response = await http.post(
      urlResetPassword,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'token': token,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception();
    }
  } catch (e) {
    return false;
  }
}

Future<List<ListUsers>> fetchUsuarios() async {
  final token = await autentication.getToken();
  final userProfileId = await autentication.getProfileId();
  final userId = await autentication.getUserId();
  try {
    final response = await http.get(
      getListUrl(userProfileId, userId),
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

Uri getListUrl(int? userProfileId, int? userId) {
  return userProfileId == 1
      ? Uri.http(host, '/list/diarists', {'id': userId.toString()})
      : Uri.http(host, '/list/contractors', {'id': userId.toString()});
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

Future<void> createAddress(Map<String, dynamic> payload) async {
  final token = await autentication.getToken();

  try {
    final http.Response response = await http.post(
      urlAddress,
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
  final url = Uri.http(host, '/address/$userId');

  try {
    final http.Response response = await http.get(
      url,
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
  final url = Uri.http(host, '/user/$userId');

  try {
    final http.Response response = await http.get(
      url,
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
  final url = Uri.http(host, '/address/$id');

  try {
    final response = await http.get(
      url,
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
  final url = Uri.http(host, '/address/$idDoEndereco');

  try {
    final response = await http.delete(
      url,
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
  final url = Uri.http(host, '/address/$addressId');

  try {
    final response = await http.put(
      url,
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
  final url = Uri.http(host, '/user/$userId');

  try {
    final response = await http.put(
      url,
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
  Future<Map<String, dynamic>?> sendContract({
    required List<Map<String, String>> tiposDeServico,
    required String? tipoLimpeza,
    required bool? possuiPets,
    required bool? possuiMaterialLimpeza,
    required String? tipoCestoLavar,
    required String? tipoCestoPassar,
    required int? qntCestoLavar,
    required int? qntCestoPassar,
    required int? quantidadeQuarto,
    required int? quantidadeBanheiro,
    required int? quantidadeSala,
    required int? quantidadeCozinha,
    required String mensagem,
    required int diaristaId,
  }) async {
    final token = await autentication.getToken();
    final contractorId = await autentication.getUserId();
    final agendamentoId = await autentication.getAgendamentoId();
    final url = Uri.http(host, '/contract');

    Map<String, dynamic> body = {
      "services": tiposDeServico,
      "cleaningType": tipoLimpeza,
      "havePets": possuiPets,
      "includesCleaningMaterial": possuiMaterialLimpeza,
      "washingBasketType": tipoCestoLavar,
      "ironingBasketType": tipoCestoPassar,
      "washingBasketQnt": qntCestoLavar,
      "ironingBasketQnt": qntCestoPassar,
      "rooms": [
        {
          "roomType": "quarto",
          "roomQnt": quantidadeQuarto,
        },
        {
          "roomType": "banheiro",
          "roomQnt": quantidadeBanheiro,
        },
        {
          "roomType": "sala",
          "roomQnt": quantidadeSala,
        },
        {
          "roomType": "cozinha",
          "roomQnt": quantidadeCozinha,
        },
      ],
      "message": mensagem,
      "diaristId": diaristaId,
      "contractorId": contractorId,
      "agendamentoId": agendamentoId
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        print('Contrato enviado com sucesso!');
        var link = jsonDecode(response.body);
        return {
          'link': link['whatsappLink']['link'],
          'value': link['contract']['contractPrice']
        };
      } else {
        throw Exception('Falha ao enviar contrato');
      }
    } catch (e) {
      return {'link': '', 'value': 51};
    }
  }
}

Future sendImage(PlatformFile file) async {
  final token = await autentication.getToken();
  final userId = await autentication.getUserId();
  var request =
      http.MultipartRequest('POST', Uri.http(host, '/user/upload/$userId'));
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
    var response = await http.get(Uri.http('viacep.com.br', '/ws/$cep/json/'));

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

Future<Map<String, dynamic>> payment(Map<String, int> price_data) async {
  String? contratctorEmail = await autentication.getUserEmail();
  int? contractorId = await autentication.getUserId();

  try {
    final token = await autentication.getToken();
    var response = await http.post(urlPaymentIntent,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'contractor_email': contratctorEmail,
          'contractor_id': contractorId,
          'price_data': price_data
        }));

    if (response.statusCode == 201) {
      Map<String, dynamic> data = json.decode(response.body);

      return data;
    } else {
      throw Exception();
    }
  } catch (e) {
    return {"paymentIntent": "", "ephemeralKey": "", "customer": ""};
  }
}

Future<String> paymentCheckout(
    Map<String, dynamic> priceData, int quantity) async {
  try {
    String? contratctorEmail = await autentication.getUserEmail();
    int? contractorId = await autentication.getUserId();
    final token = await autentication.getToken();
    var response = await http.post(urlPaymentCheckout,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'price_data': priceData,
          'quantity': quantity,
          'contractor_id': contractorId,
          'contractor_email': contratctorEmail,
          'contract_id': 1
        }));

    if (response.statusCode == 201) {
      var resp = jsonDecode(response.body);
      return resp['checkoutUrl'];
    } else {
      throw Exception();
    }
  } catch (e) {
    print(e);
    return "";
  }
}

Future<List<ListUsers>> getUserFavorite() async {
  final userId = await autentication.getUserId();
  final token = await autentication.getToken();
  Uri urlFavorite = Uri.http(host, '/favorites/$userId');
  try {
    final response = await http.get(
      urlFavorite,
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

Future<bool> setUserFavorite(int? favoritedId) async {
  final userId = await autentication.getUserId();
  final token = await autentication.getToken();
  Uri urlFavorite = Uri.http(host, '/favorites/$userId');
  try {
    final response = await http.post(
      urlFavorite,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'favorited_id': favoritedId,
      }),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception();
    }
  } catch (e) {
    return false;
  }
}

Future<bool> deleteUserFavorite(int? favoritedId) async {
  final userId = await autentication.getUserId();
  final token = await autentication.getToken();
  Uri urlFavorite = Uri.http(host, '/favorites/$userId');
  try {
    final response = await http.delete(
      urlFavorite,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'favorited_id': favoritedId,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception();
    }
  } catch (e) {
    return false;
  }
}

Future<void> sendCustomContractorProfile({
  required String? serviceType,
  required String? favoriteDaytime,
  required double valueWillingToPay,
}) async {
  final url = Uri.http(host, '/contractor/profile/custom');
  final token = await autentication.getToken();
  int? userId = await autentication.getUserId();

  final body = jsonEncode({
    'service_type': serviceType,
    'favorite_daytime': favoriteDaytime,
    'value_willing_to_pay': valueWillingToPay,
    'contractor_id': userId,
  });

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Custom contractor profile sent successfully');
    } else {
      print(
          'Failed to send custom contractor profile. Status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (e) {
    print('Error occurred while sending custom contractor profile: $e');
  }
}

Future<ContractorCustomInformation> fetchCustomContractorProfile(
    int userId) async {
  final url = Uri.http(host, '/contractor/profile/custom/$userId');
  final token = await autentication.getToken();

  final response = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  });

  if (response.statusCode == 200 && response.body.isNotEmpty) {
    try {
      return ContractorCustomInformation.fromJson(jsonDecode(response.body));
    } catch (e) {
      print('Erro ao decodificar JSON: $e');
      return ContractorCustomInformation(
          serviceType: null, favoriteDaytime: null, valueWillingToPay: null);
    }
  } else {
    print('Failed to fetch custom contractor profile');
    return ContractorCustomInformation(
        serviceType: null, favoriteDaytime: null, valueWillingToPay: null);
  }
}

Future<void> sendCustomDiaristProfileSpecialties({
  required String? specialties,
}) async {
  final url = Uri.http(host, '/specialities/diarist/');
  final token = await autentication.getToken();
  int? userId = await autentication.getUserId();

  final body = jsonEncode({
    'speciality': specialties,
    'diarist_id': userId,
  });

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Custom contractor profile sent successfully');
    } else {
      print(
          'Failed to send custom contractor profile. Status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (e) {
    print('Error occurred while sending custom contractor profile: $e');
  }
}

Future<void> sendCustomDiaristProfileState({
  required String? stateAtendiment,
}) async {
  final url = Uri.http(host, '/diarist/activity/state');
  final token = await autentication.getToken();
  int? userId = await autentication.getUserId();

  final body = jsonEncode({
    'state': stateAtendiment,
    'diarist_id': userId,
  });

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Custom contractor profile sent successfully');
    } else {
      print(
          'Failed to send custom contractor profile. Status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (e) {
    print('Error occurred while sending custom contractor profile: $e');
  }
}

Future<void> sendCustomDiaristProfileZone({
  required String? regionAtendiment,
}) async {
  final url = Uri.http(host, '/diarist/activity/zone');
  final token = await autentication.getToken();
  int? userId = await autentication.getUserId();

  final body = jsonEncode({
    'zone_id': regionAtendiment,
    'diarist_id': userId,
  });

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Custom contractor profile sent successfully');
    } else {
      print(
          'Failed to send custom contractor profile. Status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (e) {
    print('Error occurred while sending custom contractor profile: $e');
  }
}

Future<List<dynamic>> fetchCustomDiaristProfileSpecialties() async {
  final url = Uri.http(host, '/specialities');
  final token = await autentication.getToken();

  final response = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  });

  if (response.statusCode == 200) {
    final decode = await jsonDecode(response.body);
    return decode;
  } else {
    print('Failed to fetch custom contractor profile');
    return [{}];
  }
}

Future<List<dynamic>> fetchCustomDiaristProfileStates() async {
  final url = Uri.http(host, '/activity/states');
  final token = await autentication.getToken();

  final response = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  });

  if (response.statusCode == 200) {
    final decode = await jsonDecode(response.body);
    return decode;
  } else {
    print('Failed to fetch custom contractor profile');
    return [{}];
  }
}

Future<List<dynamic>> fetchCustomDiaristProfileZone() async {
  final url = Uri.http(host, '/activity/zones');
  final token = await autentication.getToken();

  final response = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  });

  if (response.statusCode == 200) {
    final decode = await jsonDecode(response.body);
    return decode;
  } else {
    print('Failed to fetch custom contractor profile');
    return [{}];
  }
}

Future<List<dynamic>> fetchDataDiaristSpecialties(int? userId) async {
  final url = Uri.http(host, '/specialities/$userId');
  final token = await autentication.getToken();

  final response = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  });

  if (response.statusCode == 200) {
    final decode = await jsonDecode(response.body);
    return decode;
  } else {
    print('Failed to fetch custom contractor profile');
    return [{}];
  }
}

Future<List<dynamic>> fetchDataDiaristZones(int? userId) async {
  final url = Uri.http(host, '/diarist/activity/$userId');
  final token = await autentication.getToken();

  final response = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  });

  if (response.statusCode == 200) {
    final decode = await jsonDecode(response.body);
    return decode;
  } else {
    print('Failed to fetch custom contractor profile');
    return [{}];
  }
}

Future<void> deleteDataDiaristSpecialties(String? speciality) async {
  final token = await autentication.getToken();
  final userId = await autentication.getUserId();
  try {
    final response = await http.delete(
      Uri.http(host, '/specialities',
          {'id': userId.toString(), 'speciality': speciality}),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
    } else {
      throw Exception('Falha ao carregar dados');
    }
  } catch (err) {
    print(err);
  }
}

Future<void> deleteDataDiaristZone(String? zone) async {
  final token = await autentication.getToken();
  final userId = await autentication.getUserId();
  try {
    final response = await http.delete(
      Uri.http(host, '/diarist/activity/zone',
          {'id': userId.toString(), 'zone_id': zone}),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
    } else {
      throw Exception('Falha ao carregar dados');
    }
  } catch (err) {
    print(err);
  }
}

Future<bool> createDiaistBankInformationRelation() async {
  final token = await autentication.getToken();
  final userId = await autentication.getUserId();
  try {
    final response = await http.post(
        Uri.http(host, '/bank-information/diarist'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(
            {'diarist_id': userId, 'bank_name': '', 'account_name': ''}));

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Falha ao carregar dados');
    }
  } catch (err) {
    print(err);
    return false;
  }
}

Future<void> updateDiaistBankInformation(Map<String, dynamic> body) async {
  final token = await autentication.getToken();
  final userId = await autentication.getUserId();
  try {
    final response =
        await http.patch(Uri.http(host, '/bank-information/diarist/$userId'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(body));

    if (response.statusCode == 200) {
    } else {
      throw Exception('Falha ao carregar dados');
    }
  } catch (err) {
    print(err);
  }
}

Future<BankInfo?> fetcheDiaistBankInformation() async {
  final token = await autentication.getToken();
  final userId = await autentication.getUserId();
  try {
    final response = await http.get(
      Uri.http(host, '/bank-information/diarist/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final bankInfo = jsonDecode(response.body);
      return BankInfo.fromJson(bankInfo['data']);
    } else {
      throw Exception('Falha ao carregar dados');
    }
  } catch (err) {
    return null;
  }
}

Future<void> postAgendamento({
  required int diaristaId,
  required DateTime dataAgendamento,
  required String tipoDiaria,
}) async {
  final url = Uri.http(host, 'agendamento');
  final token = await autentication.getToken();
  int? userId = await autentication.getUserId();

  final body = jsonEncode({
    'contratanteId': userId,
    'diaristaId': diaristaId,
    'data': dataAgendamento.toIso8601String(),
    'tipoDiaria': tipoDiaria,
  });

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Agendamento enviado com sucesso');
      final agendamento = jsonDecode(response.body);
      await autentication.setAgendamentoId(agendamento['id']);
    } else {
      print('Falha ao enviar o agendamento. Status: ${response.statusCode}');
      print('Resposta: ${response.body}');
    }
  } catch (e) {
    print('Erro ao enviar o agendamento: $e');
  }
}

Future<List<dynamic>> fetchDailyRateType() async {
  final url = Uri.http(host, '/agendamento/dailyratetype');
  final token = await autentication.getToken();

  final response = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  });

  if (response.statusCode == 200) {
    final decode = await jsonDecode(response.body);
    return decode;
  } else {
    print('Failed to fetch custom contractor profile');
    return [{}];
  }
}

Future<List<ListDailys>> fetchMeetings() async {
  final token = await autentication.getToken();
  final userProfileId = await autentication.getProfileId();
  final userId = await autentication.getUserId();
  try {
    final response = await http.get(
      getListMeetings(userProfileId, userId),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => ListDailys.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar dados');
    }
  } catch (err) {
    print(err);
    return [];
  }
}

Uri getListMeetings(int? userProfileId, int? userId) {
  return userProfileId == 1
      ? Uri.http(host, '/confirm-payment/contractor/services/$userId')
      : Uri.http(host, '/confirm-payment/diarist/services/$userId');
}
