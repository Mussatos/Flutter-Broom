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

class DiaristModel {
  int profileId;
  String name;
  String sobrenome;
  String cellphone_number = '';
  String user_image = '';
  String basic_description = '';
  /*
  String state = '';
  String city = '';
  String neighborhood = '';
  */
  Address address;

  DiaristModel({
    required this.profileId,
    required this.name,
    required this.sobrenome,
    required this.cellphone_number,
    required this.user_image,
    required this.basic_description,
    /*
    required this.state,
    required this.city,
    required this.neighborhood,
    */
    required this.address,
  });

  factory DiaristModel.fromJson(Map<String, dynamic> json) {
    return DiaristModel(
      profileId: json['profile_id'],
      basic_description: json['description'],
      name: json['first_name'],
      sobrenome: json['last_name'],
      cellphone_number: json['cellphone_number'],
      user_image: json['user_image'],
      address: Address.fromJson(json['address']),
    );
  }
}

class ContractModel {
  int profileId;
  String name;
  String sobrenome;
  String cellphone_number = '';
  String user_image = '';
  String basic_description = '';
  /*
  String state = '';
  String city = '';
  String neighborhood = '';
  */
  Address address;
  bool want_service;

  ContractModel({
    required this.profileId,
    required this.name,
    required this.sobrenome,
    required this.cellphone_number,
    required this.user_image,
    required this.basic_description,
    /*
    required this.state,
    required this.city,
    required this.neighborhood,
    */
    required this.address,
    required this.want_service,
  });

  factory ContractModel.fromJson(Map<String, dynamic> json) {
    return ContractModel(
        profileId: json['profile_id'],
        basic_description: json['description'],
        name: json['first_name'],
        sobrenome: json['last_name'],
        cellphone_number: json['cellphone_number'],
        user_image: json['user_image'],
        address: Address.fromJson(json['address']),
        want_service: json['want_service']);
  }
}

class Address {
  String state = '';
  String street = '';
  String neighborhood = '';

  // Construtor
  Address({
    required this.state,
    required this.street,
    required this.neighborhood,
  });

  // Método fromJson para converter um Map (JSON) em um objeto Address
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      state: json['state'],
      street: json['street'],
      neighborhood: json['neighborhood'],
    );
  }
}
