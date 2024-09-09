class User {
  int profileId;
  String name;
  String sobrenome;
  String email;
  String password;
  String cellphone_number = '';
  String user_image = '';
  String cpf;
  String basic_description = '';
  DateTime data;

  User({
    required this.profileId,
    required this.name,
    required this.sobrenome,
    required this.email,
    required this.password,
    required this.cellphone_number,
    required this.cpf,
    required this.user_image,
    required this.data,
    required this.basic_description,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        profileId: json['profile_id'],
        email: json['email'],
        password: json['password'],
        basic_description: json['description'],
        cpf: json['cpf'],
        name: json['first_name'],
        sobrenome: json['last_name'],
        data: json['age'],
        cellphone_number: json['cellphone_number'],
        user_image: json['user_image']);
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': name,
      'last_name': sobrenome,
      'password': password,
      'user_image': user_image,
      'description': basic_description,
      'age': data.toIso8601String(),
      'cpf': cpf,
      'email': email,
      'profile_id': profileId,
      'cellphone_number': cellphone_number,
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

  UserModel({
    required this.name,
    required this.lastName,
    required this.cellphoneNumber,
    required this.userImage,
    required this.description,
    required this.address,
    required this.wantService,
    required this.gender,
    required this.email
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        description: json['description'],
        name: json['first_name'],
        lastName: json['last_name'],
        cellphoneNumber: json['cellphone_number'],
        userImage: json['user_image'],
        address: json['address'],
        wantService: json['want_service'] ?? '',
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

  // Construtor
  Address(
      {required this.state,
      required this.city,
      required this.neighborhood,
      required this.addressType,
      required this.street});

  // Método fromJson para converter um Map (JSON) em um objeto Address
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      state: json['state'],
      street: json['street'],
      addressType: json['address_type'],
      city: json['city'] ,
      neighborhood: json['neighborhood'],
    );
  }
}
