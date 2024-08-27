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
        basic_description: json['basic_description'],
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
      'basic_description': basic_description,
      'age': data.toIso8601String(),
      'cpf': cpf,
      'email': email,
      'profile_id': profileId,
      'cellphone_number': cellphone_number,
    };
  }
}
