import 'package:broom_main_vscode/api/user.api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Contract extends StatefulWidget {
  int idDoUser;

  Contract({super.key, required this.idDoUser});

  @override
  _ContractState createState() => _ContractState();
}

class _ContractState extends State<Contract> {
  final TextEditingController bedroomController = TextEditingController();
  final TextEditingController kitchenController = TextEditingController();
  final TextEditingController toiletController = TextEditingController();
  final TextEditingController roomController = TextEditingController();
  final TextEditingController obsController = TextEditingController();
  final TextEditingController basketCleanQuantityController =
      TextEditingController();
  final TextEditingController basketIroningQuantityController =
      TextEditingController();
  bool? petsController = false;
  bool? materialController = false;
  bool _ready = false;
  Map<String, bool> invalidRooms = {
    'bedroom': false,
    'kitchen': false,
    'toilet': false,
    'room': false
  };

  List<String> serviceType = [
    'Limpeza',
    'Lavar roupa',
    'Passar roupa',
    'Lavar louça',
    'Organizar ambiente'
  ];

  List<bool> serviceTypeSelected = [false, false, false, false, false];

  List<String> cleanType = ['Leve', 'Média', 'Pesada'];
  String cleanTypeSelected = 'Leve';

  String cleanBasketTypeSelected = 'Cesto pequeno'; //Lavar roupa
  List<String> cleanBasketType = [
    'Cesto pequeno',
    'Cesto médio',
    'Cesto grande'
  ]; //Lavar roupa

  String ironingBasketTypeSelected = 'Cesto pequeno'; //Passar roupa
  List<String> ironingBasketType = [
    'Cesto pequeno',
    'Cesto médio',
    'Cesto grande'
  ]; //Passar roupa

  bool _isBasketCleanQuantityValid = true;
  bool _isBasketIroningQuantityValid = true;

  @override
  void dispose() {
    bedroomController.dispose();
    kitchenController.dispose();
    toiletController.dispose();
    roomController.dispose();
    basketCleanQuantityController.dispose();
    basketIroningQuantityController.dispose();
    obsController.dispose();
    super.dispose();
  }

  ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    basketCleanQuantityController.addListener(_validateBasketQuantities);
    basketIroningQuantityController.addListener(_validateBasketQuantities);
    bedroomController.addListener(roomsValidation);
    roomController.addListener(roomsValidation);
    kitchenController.addListener(roomsValidation);
    toiletController.addListener(roomsValidation);
  }

  void _validateBasketQuantities() {
    bool isLavarRoupaSelected = serviceTypeSelected[1];
    bool isPassarRoupaSelected = serviceTypeSelected[2];

    setState(() {
      _isBasketCleanQuantityValid = isLavarRoupaSelected
          ? (basketCleanQuantityController.text.isNotEmpty &&
              int.tryParse(basketCleanQuantityController.text) != null)
          : true;

      _isBasketIroningQuantityValid = isPassarRoupaSelected
          ? (basketIroningQuantityController.text.isNotEmpty &&
              int.tryParse(basketIroningQuantityController.text) != null)
          : true;
    });
  }

  Future<void> initPaymentSheet() async {
    try {
      final data = await payment();

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          customFlow: false,
          merchantDisplayName: 'Broom Payment',
          paymentIntentClientSecret: data['paymentIntent'],
          customerEphemeralKeySecret: data['ephemeralKey'],
          customerId: data['customer'],
          billingDetails: BillingDetails(
              address: Address(
                  city: null,
                  country: "BR",
                  line1: null,
                  line2: null,
                  postalCode: null,
                  state: null)),
          style: ThemeMode.dark,
        ),
      );
      setState(() {
        _ready = true;
      });
      await confirmPayment();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      rethrow;
    }
  }

  Future<void> confirmPayment() async {
    try {
      await Stripe.instance.presentPaymentSheet();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pagamento realizado com sucesso'),
        ),
      );
    } on Exception catch (e) {
      if (e is StripeException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro de pagamento: ${e.error.localizedMessage}'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro desconhecido: ${e}'),
          ),
        );
      }
    }
  }

  Future<void> initCheckout() async {
    Map<String, dynamic> priceData = {
      'currency': 'brl',
      'product_data': {
        'name': 'Contratação de serviço de limpeza doméstica',
      },
      'unit_amount': 20000,
    };
    int quantity = 1;

    final data = await paymentCheckout(priceData, quantity);

    if (data.isNotEmpty) await launchUrlString(data);
  }

  Future<void> sendContract() async {
    List<String> selectedServices = [];
    for (int i = 0; i < serviceType.length; i++) {
      if (serviceTypeSelected[i]) {
        selectedServices.add(serviceType[i]);
      }
    }

    String? basketCleanQuantity = basketCleanQuantityController.text;
    String? basketIroningQuantity = basketIroningQuantityController.text;

    setState(() {
      _isBasketCleanQuantityValid = serviceTypeSelected[1]
          ? (basketCleanQuantity.isNotEmpty &&
              int.tryParse(basketCleanQuantity) != null)
          : true;

      _isBasketIroningQuantityValid = serviceTypeSelected[2]
          ? (basketIroningQuantity.isNotEmpty &&
              int.tryParse(basketIroningQuantity) != null)
          : true;
    });

    if (!_isBasketCleanQuantityValid || !_isBasketIroningQuantityValid) {
      return;
    }

    if (hasInsertedAtLeastOneRoomNumber()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Por Favor, inserir ao menos um cômodo com quantidade válida para prosseguir com o contrato.'),
        ),
      );
      return;
    }

    if (invalidRooms.containsValue(true)) return;
    
    String? whatsappUrl = await apiService.sendContract(
      tiposDeServico: selectedServices,
      tipoLimpeza: cleanTypeSelected,
      possuiPets: petsController ?? false,
      possuiMaterialLimpeza: materialController ?? false,
      tipoCestoLavar: cleanBasketTypeSelected,
      tipoCestoPassar: ironingBasketTypeSelected,
      qntCestoLavar: (serviceTypeSelected[1]
          ? int.tryParse(basketCleanQuantityController.text) ?? 0
          : 0),
      qntCestoPassar: (serviceTypeSelected[2]
          ? int.tryParse(basketIroningQuantityController.text) ?? 0
          : 0),
      quantidadeQuarto: int.tryParse(bedroomController.text) ?? 0,
      quantidadeBanheiro: int.tryParse(toiletController.text) ?? 0,
      quantidadeSala: int.tryParse(roomController.text) ?? 0,
      mensagem: obsController.text,
      id: widget.idDoUser,
    );

    if (whatsappUrl!.isNotEmpty) {
      launchWhatsApp(whatsappUrl!);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Falha ao enviar contrato!!\nUsuário não cadastrou telefone para contato.'),
        ),
      );
    }
  }

  void roomsValidation() {
    final notNumber = RegExp(r'[^0-9]');

    setState(() {
      invalidRooms['kitchen'] = notNumber.hasMatch(kitchenController.text);
      invalidRooms['bedroom'] = notNumber.hasMatch(bedroomController.text);
      invalidRooms['room'] = notNumber.hasMatch(roomController.text);
      invalidRooms['toilet'] = notNumber.hasMatch(toiletController.text);
    });
  }

  bool hasInsertedAtLeastOneRoomNumber() {
    return kitchenController.text.isEmpty &&
        bedroomController.text.isEmpty &&
        roomController.text.isEmpty &&
        toiletController.text.isEmpty;
  }

  void launchWhatsApp(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contrato',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Color(0xFF2ECC8F),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 24,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(35.0),
          color: Colors.white,
          child: Column(
            children: [
              Text(
                "Quantos cômodos?",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: bedroomController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: 'Quarto',
                          border: OutlineInputBorder(),
                          errorText: invalidRooms['bedroom']!
                              ? 'Valor inválido'
                              : null),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: kitchenController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: 'Cozinha',
                          border: OutlineInputBorder(),
                          errorText: invalidRooms['kitchen']!
                              ? 'Valor inválido'
                              : null),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: toiletController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: 'Banheiro',
                          border: OutlineInputBorder(),
                          errorText: invalidRooms['toilet']!
                              ? 'Valor inválido'
                              : null),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: roomController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: 'Sala',
                          border: OutlineInputBorder(),
                          errorText:
                              invalidRooms['room']! ? 'Valor inválido' : null),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: petsController,
                        activeColor: Colors.greenAccent,
                        onChanged: (bool? value) {
                          setState(() {
                            petsController = value!;
                          });
                        },
                      ),
                      Text('Possui pets'),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: materialController,
                        activeColor: Colors.greenAccent,
                        onChanged: (bool? value) {
                          setState(() {
                            materialController = value!;
                          });
                        },
                      ),
                      Text('Possui material de limpeza'),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(serviceType.length, (index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: CheckboxListTile(
                          title: Text(
                            serviceType[index],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          value: serviceTypeSelected[index],
                          activeColor: Colors.greenAccent,
                          onChanged: (bool? value) {
                            setState(() {
                              serviceTypeSelected[index] = value!;
                            });
                          },
                        ),
                      ),
                      if (serviceType[index] == 'Limpeza' &&
                          serviceTypeSelected[index])
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.white,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: cleanTypeSelected,
                                isExpanded: true,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black,
                                ),
                                dropdownColor: Colors.white,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    cleanTypeSelected = newValue!;
                                  });
                                },
                                items: cleanType.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      if (serviceType[index] == 'Lavar roupa' &&
                          serviceTypeSelected[index])
                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.white,
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: cleanBasketTypeSelected,
                                  isExpanded: true,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.black,
                                  ),
                                  dropdownColor: Colors.white,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      cleanBasketTypeSelected = newValue!;
                                    });
                                  },
                                  items: cleanBasketType.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              controller: basketCleanQuantityController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Quantidade de cestos para lavar',
                                border: OutlineInputBorder(),
                                errorText: !_isBasketCleanQuantityValid
                                    ? 'Valor inválido'
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      if (serviceType[index] == 'Passar roupa' &&
                          serviceTypeSelected[index])
                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.white,
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: ironingBasketTypeSelected,
                                  isExpanded: true,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.black,
                                  ),
                                  dropdownColor: Colors.white,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      ironingBasketTypeSelected = newValue!;
                                    });
                                  },
                                  items: ironingBasketType.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              controller: basketIroningQuantityController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Quantidade de cestos para passar',
                                errorText: !_isBasketIroningQuantityValid
                                    ? 'Valor inválido'
                                    : null,
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                        ),
                    ],
                  );
                }),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: obsController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Observação',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 350,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    if (kIsWeb)
                      initCheckout();
                    else
                      await initPaymentSheet();
                  },
                  child: Text(
                    'Pagamento',
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xFF2ECC8F)),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 350,
                height: 50,
                child: ElevatedButton(
                  onPressed: sendContract,
                  child: Text('Enviar contrato'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
