class User {
  int profileId;
  String name;
  String sobrenome;
  String email;
  String password;
  String cellphone_number = '';
  String user_image = '';
  String cpf;
  String description = '';
  DateTime data;
  String gender;
  bool? wantService;

  User(
      {required this.profileId,
      required this.name,
      required this.sobrenome,
      required this.email,
      required this.password,
      required this.cellphone_number,
      required this.cpf,
      required this.user_image,
      required this.data,
      required this.description,
      required this.gender,
      required this.wantService});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        profileId: json['profile_id'],
        email: json['email'],
        password: json['password'],
        description: json['description'],
        cpf: json['cpf'],
        name: json['first_name'],
        sobrenome: json['last_name'],
        data: json['age'],
        cellphone_number: json['cellphone_number'],
        user_image: json['user_image'],
        gender: json['gender'],
        wantService: json['want_service']);
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': name,
      'last_name': sobrenome,
      'password': password,
      'user_image': user_image,
      'age': data.toIso8601String(),
      'description': description,
      'cpf': cpf,
      'email': email,
      'profile_id': profileId,
      'cellphone_number': cellphone_number,
      'gender': gender,
      'want_service': wantService
    };
  }
}

class UserModel {
  String name;
  String lastName;
  String cellphoneNumber = '';
  String userImage = '';
  String description = '';
  List<dynamic> address;
  String email = '';
  bool wantService;
  String gender = '';

  UserModel(
      {required this.name,
      required this.lastName,
      required this.cellphoneNumber,
      required this.userImage,
      required this.description,
      required this.address,
      required this.wantService,
      required this.gender,
      required this.email});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        description: json['description'],
        name: json['first_name'],
        lastName: json['last_name'],
        cellphoneNumber: json['cellphone_number'],
        userImage: json['user_image'],
        address: json['address'],
        wantService: json['want_service'] ?? false,
        gender: json['gender'],
        email: json['email'] ?? '');
  }
}

class ListUsers {
  int id;
  int profileId;
  String firstName;
  String lastName;
  String userImage;
  bool? wantService;
  List<dynamic> address;

  ListUsers({
    required this.id,
    required this.address,
    required this.firstName,
    required this.lastName,
    required this.profileId,
    required this.userImage,
    required this.wantService,
  });

  factory ListUsers.fromJson(Map<String, dynamic> json) {
    return ListUsers(
      id: json['id'],
      profileId: json['profile_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      userImage: json['user_image'],
      address: json['address'],
      wantService: json['want_service'],
    );
  }
}

class Address {
  String? state = '';
  String? city = '';
  String? neighborhood = '';
  String? street = '';
  String? addressType;
  int? number;
  String? addressCode;
  String? complement;
  int? userId;
  int? id;

  Address({
    required this.state,
    required this.city,
    required this.neighborhood,
    required this.addressType,
    required this.street,
    required this.number,
    required this.addressCode,
    required this.complement,
    required this.userId,
    required this.id,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      state: json['state'],
      street: json['street'],
      addressType: json['address_type'],
      city: json['city'],
      neighborhood: json['neighborhood'],
      number: json['number'],
      addressCode: json['address_code'],
      complement: json['complement'],
      userId: json['user_id'],
      id: json['id'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'state': state,
      'street': street,
      'address_type': addressType,
      'city': city,
      'neighborhood': neighborhood,
      'number': number,
      'address_code': addressCode,
      'complement': complement,
      'user_id': userId,
    };
  }
}

class Yourself {
  String name;
  int id;
  String lastName;
  String cellphoneNumber = '';
  String userImage = '';
  String description = '';
  String email = '';
  bool wantService;
  String cpf = '';
  List<dynamic> address;
  int? userId;

  Yourself(
      {required this.name,
      required this.id,
      required this.lastName,
      required this.cellphoneNumber,
      required this.userImage,
      required this.description,
      required this.address,
      required this.wantService,
      required this.cpf,
      required this.email});

  factory Yourself.fromJson(Map<String, dynamic> json) {
    return Yourself(
        id: json['id'],
        description: json['description'],
        name: json['first_name'],
        lastName: json['last_name'],
        cellphoneNumber: json['cellphone_number'],
        userImage: json['user_image'],
        address: json['address'],
        wantService: json['want_service'] ?? false,
        cpf: json['cpf'],
        email: json['email'] ?? '');
  }
}

Map<String, dynamic> toJson({
  required List<String> tipoDeServico,
  required String tipoLimpeza,
  required bool possuiPets,
  required bool possuiMaterialLimpeza,
  required int quantidadeRoupaLavar,
  required int quantidadeRoupaPassar,
  required int quantidadeLouca,
  required int quantidadeQuarto,
  required int quantidadeBanheiro,
  required int quantidadeSala,
  required int quantidadeCozinha,
  required String observacao,
}) {
  return {
    'tiposDeServico': tipoDeServico,
    'tipoLimpeza': tipoLimpeza,
    'possuiPets': possuiPets,
    'possuiMaterialLimpeza': possuiMaterialLimpeza,
    'qntRoupaLavar': quantidadeRoupaLavar,
    'qntRoupaPassar': quantidadeRoupaPassar,
    'qntLouca': quantidadeLouca,
    'comodos': [
      {
        'tipo': 'quarto',
        'quantidade': quantidadeQuarto,
      },
      {
        'tipo': 'banheiro',
        'quantidade': quantidadeBanheiro,
      },
      {
        'tipo': 'sala',
        'quantidade': quantidadeSala,
      },
      {
        'tipo': 'cozinha',
        'quantidade': quantidadeCozinha,
      },
    ],
    'mensagem': observacao,
  };
}

class EditUser {
  String? name;
  String? lastName;
  String? cellphoneNumber = '';
  String? description = '';
  String? email = '';
  bool? wantService;

  EditUser(
      {required this.name,
      required this.lastName,
      required this.cellphoneNumber,
      required this.description,
      required this.wantService,
      required this.email});

  factory EditUser.fromJson(Map<String, dynamic> json) {
    return EditUser(
        description: json['description'],
        name: json['first_name'],
        lastName: json['last_name'],
        cellphoneNumber: json['cellphone_number'],
        wantService: json['want_service'] ?? false,
        email: json['email'] ?? '');
  }
  Map<String, dynamic> toJson() {
    return {
      'first_name': name,
      'description': description,
      'last_name': lastName,
      'cellphone_number': cellphoneNumber,
      'want_service': wantService,
      'email': email,
    };
  }
}
