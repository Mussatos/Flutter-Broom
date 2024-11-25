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
  bool isFavorite;

  ListUsers({
    required this.id,
    required this.address,
    required this.firstName,
    required this.lastName,
    required this.profileId,
    required this.userImage,
    required this.wantService,
    required this.isFavorite,
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
        isFavorite: json['is_favorite']);
  }
}

// class ListUsersDiarist {
//   int id;
//   int profileId;
//   String firstName;
//   String lastName;
//   String userImage;
//   bool? wantService;
//   List<dynamic> address;
//   bool isFavorite;

//   ListUsers({
//     required this.id,
//     required this.address,
//     required this.firstName,
//     required this.lastName,
//     required this.profileId,
//     required this.userImage,
//     required this.wantService,
//     required this.isFavorite,
//   });

//   factory ListUsers.fromJson(Map<String, dynamic> json) {
//     return ListUsers(
//       id: json['id'],
//       profileId: json['profile_id'],
//       firstName: json['first_name'],
//       lastName: json['last_name'],
//       userImage: json['user_image'],
//       address: json['address'],
//       wantService: json['want_service'],
//       isFavorite: json['is_favorite']
//     );
//   }
// }

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
  String? userActualImage;
  String? serviceType;
  String? favoriteDaytime;
  num? valueWillingToPay;
  List<String?>? regionAtendiment;
  List<String>? specialties;
  String? stateAtendiment;

  EditUser(
      {required this.name,
      required this.lastName,
      required this.cellphoneNumber,
      required this.description,
      required this.wantService,
      required this.email,
      this.specialties,
      this.regionAtendiment,
      this.stateAtendiment,
      this.userActualImage,
      this.serviceType,
      this.favoriteDaytime,
      this.valueWillingToPay});

  factory EditUser.fromJson(Map<String, dynamic> json) {
    return EditUser(
      description: json['description'],
      name: json['first_name'],
      lastName: json['last_name'],
      cellphoneNumber: json['cellphone_number'],
      wantService: json['want_service'] ?? false,
      email: json['email'] ?? '',
      serviceType: json['Contractor_Custom_Information']['service_type'] ?? '',
      favoriteDaytime:
          json['Contractor_Custom_Information']['favorite_daytime'] ?? '',
      valueWillingToPay:
          json['Contractor_Custom_Information']['value_willing_to_pay'] ?? '',
    );
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

class ContractorCustomInformation {
  String? serviceType;
  String? favoriteDaytime;
  double? valueWillingToPay;

  ContractorCustomInformation(
      {required this.serviceType,
      required this.favoriteDaytime,
      required this.valueWillingToPay});

  factory ContractorCustomInformation.fromJson(Map<String, dynamic> json) {
    return ContractorCustomInformation(
      serviceType: json['service_type'] ?? '',
      favoriteDaytime: json['favorite_daytime'] ?? '',
      valueWillingToPay: json['value_willing_to_pay'] ?? 0.0,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'service_type': serviceType,
      'favorite_daytime': favoriteDaytime,
      'value_willing_to_pay': valueWillingToPay
    };
  }
}

class DiaristCustomInformationSpeciality {
  List<String>? specialties;

  DiaristCustomInformationSpeciality({
    required this.specialties,
  });

  factory DiaristCustomInformationSpeciality.fromJson(
      Map<String, dynamic> json) {
    return DiaristCustomInformationSpeciality(
      specialties: json['speciality'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'speciality': specialties,
    };
  }
}

class DiaristCustomInformationActivity {
  List<String>? regionAtendiment;
  List<String>? stateAtendiment;

  DiaristCustomInformationActivity(
      {required this.regionAtendiment, required this.stateAtendiment});

  factory DiaristCustomInformationActivity.fromJson(Map<String, dynamic> json) {
    return DiaristCustomInformationActivity(
      regionAtendiment: json['zone_id'] ?? '',
      stateAtendiment: json['state'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {'zone_id': regionAtendiment, 'state': stateAtendiment};
  }
}

class ListDailys {
  final int? id;
  final int? paymentInfoId;
  final int? contractId;
  final bool? refund;
  final bool? finished;
  final DateTime? finishedAt;
  final int? agendamentoId;
  final String? contractorFirstName;
  final String? contractorLastName;
  final DateTime? agendamentoDate;
  final String? diaristFirstName;
  final String? diaristLastName;
  final String? diariaType;
  final DateTime? startTime;
  final DateTime? endTime;
  final int? contractIdDetail;
  final bool? includesCleaningMaterial;
  final bool? havePets;
  final String? cleaningType;
  final String? message;
  final String? contractStatus;
  final double? contractPrice;
  final String? paymentStatus;
  final String? stripe_id;

  ListDailys({
    required this.id,
    required this.paymentInfoId,
    required this.contractId,
    required this.refund,
    required this.finished,
    required this.stripe_id,
    this.finishedAt,
    required this.agendamentoId,
    required this.contractorFirstName,
    required this.contractorLastName,
    required this.agendamentoDate,
    required this.diaristFirstName,
    required this.diaristLastName,
    required this.diariaType,
    required this.startTime,
    required this.endTime,
    required this.contractIdDetail,
    required this.includesCleaningMaterial,
    required this.havePets,
    required this.cleaningType,
    required this.message,
    required this.contractStatus,
    required this.contractPrice,
    required this.paymentStatus,
  });

  factory ListDailys.fromJson(Map<String, dynamic> json) {
    final agendamento = json['agendamento'];
    final contratante = agendamento['contratante'];
    final diarista = agendamento['diarista'];
    final contract = agendamento['contract'] ?? {};
    final payment = json['Contractor_Payment'];

    return ListDailys(
      id: json['id'] ?? 0,
      paymentInfoId: json['payment_info_id'] ?? 0,
      contractId: json['contract_id'] ?? 0,
      refund: json['refund'] ?? false,
      finished: json['finished'] ?? false,
      finishedAt: json['finished_at'] != null
          ? DateTime.parse(json['finished_at'])
          : null,
      agendamentoId: agendamento['id'] ?? 0,
      contractorFirstName: contratante['first_name'] ?? '',
      contractorLastName: contratante['last_name'] ?? '',
      agendamentoDate: DateTime.parse(agendamento['data']),
      diaristFirstName: diarista['first_name'] ?? '',
      diaristLastName: diarista['last_name'] ?? '',
      diariaType: agendamento['tipoDiaria'] ?? '',
      startTime: DateTime.parse(agendamento['horarioInicio']),
      endTime: DateTime.parse(agendamento['horarioFim']),
      contractIdDetail: contract['id'] ?? 0,
      includesCleaningMaterial: contract['includesCleaningMaterial'] ?? false,
      havePets: contract['havePets'] ?? false,
      cleaningType: contract['cleaningType'] ?? '',
      message: contract['message'] ?? '',
      contractStatus: contract['contractStatus'] ?? '',
      contractPrice: (contract['contractPrice'] ?? 0).toDouble(),
      paymentStatus: payment['status'],
      stripe_id: payment['stripe_id'] ?? ''
    );
  }
}

class RoomsDto {
  final String roomType; 
  final int roomQnt;

  RoomsDto({
    required this.roomType,
    required this.roomQnt,
  });

  factory RoomsDto.fromJson(Map<String, dynamic> json) {
    return RoomsDto(
      roomType: json['roomType'] ?? '',
      roomQnt: json['roomQnt'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomType': roomType,
      'roomQnt': roomQnt,
    };
  }
}

class ServiceDto {
  final String serviceType; 

  ServiceDto({
    required this.serviceType,
  });

  factory ServiceDto.fromJson(Map<String, dynamic> json) {
    return ServiceDto(
      serviceType: json['serviceType'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serviceType': serviceType,
    };
  }
}

class PaymentDetails {
  final int? id;
  final int? paymentInfoId;
  final int? contractId;
  final bool? refund;
  final bool? finished;
  final DateTime? finishedAt;
  final int? agendamentoId;
  final String? contractorFirstName;
  final String? contractorLastName;
  final DateTime? agendamentoDate;
  final String? tipoDiaria;
  final DateTime? startTime;
  final DateTime? endTime;
  final String? diaristFirstName;
  final String? diaristLastName;
  final String? cleaningType;
  final String? message;
  final String? contractStatus;
  final double? contractPrice;
  final String? paymentStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final ContractorPayment? contractorPayment;

  final bool? includesCleaningMaterial;
  final bool? havePets;
  final List<RoomsDto>? rooms;
  final List<ServiceDto>? services;
  final String? washingBasketType;
  final String? ironingBasketType;
  final int? ironingBasketQnt;
  final int? washingBasketQnt;

  PaymentDetails({
    required this.id,
    required this.paymentInfoId,
    required this.contractId,
    required this.refund,
    required this.finished,
    required this.tipoDiaria,
    required this.startTime,
    required this.endTime,
    this.finishedAt,
    required this.agendamentoId,
    required this.contractorFirstName,
    required this.contractorLastName,
    required this.agendamentoDate,
    required this.diaristFirstName,
    required this.diaristLastName,
    required this.cleaningType,
    required this.message,
    required this.contractStatus,
    required this.contractPrice,
    required this.paymentStatus,
    this.createdAt,
    this.updatedAt,
    this.contractorPayment,

    this.includesCleaningMaterial,
    this.havePets,
    this.rooms,
    this.services,
    this.washingBasketType,
    this.ironingBasketType,
    this.ironingBasketQnt,
    this.washingBasketQnt,
  });

  factory PaymentDetails.fromJson(Map<String, dynamic> json) {
    final agendamento = json['agendamento'];
    final contratante = agendamento['contratante'];
    final diarista = agendamento['diarista'];
    final contract = agendamento['contract'] ?? {};
    final payment = json['Contractor_Payment'];

    print('agendamento? $agendamento');
    print('Contract: $contract');
    print('Rooms: ${contract['rooms']}'); 
    print('Services: ${contract['services']}'); 

    return PaymentDetails(
      id: json['id'] ?? 0,
      paymentInfoId: json['payment_info_id'] ?? 0,
      contractId: json['contract_id'] ?? 0,
      refund: json['refund'] ?? false,
      finished: json['finished'] ?? false,
      finishedAt: json['finished_at'] != null
          ? DateTime.parse(json['finished_at'])
          : null,
      agendamentoId: agendamento['id'] ?? 0,
      contractorFirstName: contratante['first_name'] ?? '',
      contractorLastName: contratante['last_name'] ?? '',
      agendamentoDate: DateTime.parse(agendamento['data']),
      tipoDiaria: agendamento['tipoDiaria'] ?? '',
      startTime: DateTime.parse(agendamento['horarioInicio']),
      endTime: DateTime.parse(agendamento['horarioFim']),
      diaristFirstName: diarista['first_name'] ?? '',
      diaristLastName: diarista['last_name'] ?? '',
      cleaningType: contract['cleaningType'] ?? '',
      message: contract['message'] ?? '',
      contractStatus: contract['contractStatus'] ?? '',
      contractPrice: (contract['contractPrice'] ?? 0).toDouble(),
      paymentStatus: payment['status'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      contractorPayment: payment != null
          ? ContractorPayment.fromJson(payment)
          : null,

      includesCleaningMaterial: contract['includesCleaningMaterial'] ?? false,
      havePets: contract['havePets'] ?? false,

     rooms: (contract['rooms'] as List<dynamic>?)
          ?.map((room) => RoomsDto.fromJson(room as Map<String, dynamic>))
          .toList(),
      services: (contract['services'] as List<dynamic>?)
          ?.map((service) => ServiceDto.fromJson(service as Map<String, dynamic>))
          .toList(),

      washingBasketType: contract['washingBasketType'],
      ironingBasketType: contract['ironingBasketType'],
      ironingBasketQnt: contract['ironingBasketQnt'],
      washingBasketQnt: contract['washingBasketQnt'],
    );
  }
}

class ContractorPayment {
  final int contractorId;
  final String status;
  final String stripeId;
  final String stripeCs;
  final List<PaymentAuditorship> paymentAuditorship;

  ContractorPayment({
    required this.contractorId,
    required this.status,
    required this.stripeId,
    required this.stripeCs,
    required this.paymentAuditorship,
  });

  factory ContractorPayment.fromJson(Map<String, dynamic> json) {
    return ContractorPayment(
      contractorId: json['contractor_id'],
      status: json['status'],
      stripeId: json['stripe_id'],
      stripeCs: json['stripe_cs'],
      paymentAuditorship: (json['Payment_Auditorship'] as List)
          .map((e) => PaymentAuditorship.fromJson(e))
          .toList(),
    );
  }
}

class PaymentAuditorship {
  final int id;
  final int paymentInfoId;
  final String paymentStatus;
  final String paymentStatusBefore;
  final DateTime auditorshipDate;
  final String auditorshioResponsable;
  final String observation;

  PaymentAuditorship({
    required this.id,
    required this.paymentInfoId,
    required this.paymentStatus,
    required this.paymentStatusBefore,
    required this.auditorshipDate,
    required this.auditorshioResponsable,
    required this.observation,
  });

  factory PaymentAuditorship.fromJson(Map<String, dynamic> json) {
    return PaymentAuditorship(
      id: json['id'],
      paymentInfoId: json['payment_info_id'],
      paymentStatus: json['payment_status']?? '',
      paymentStatusBefore: json['payment_status_before'] ?? '',
      auditorshipDate: DateTime.parse(json['auditorship_date']),
      auditorshioResponsable: json['auditorshio_responsable'],
      observation: json['observation'],
    );
  }
}



