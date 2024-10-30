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
  bool? petsController = false;
  bool? materialController = false;
  bool _ready = false;

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

  ApiService apiService = ApiService();

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

    if (kitchenController.text.isEmpty &&
        bedroomController.text.isEmpty &&
        roomController.text.isEmpty &&
        toiletController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Por Favor, inserir ao menos um comodo com quantidade válida para prosseguir com o contrato.'),
        ),
      );
      return;
    }

    String? whatsappUrl = await apiService.sendContract(
      tiposDeServico: selectedServices,
      tipoLimpeza: cleanTypeSelected,
      possuiPets: petsController ?? false,
      possuiMaterialLimpeza: materialController ?? false,
      tipoCestoLavar: cleanBasketTypeSelected,
      tipoCestoPassar: ironingBasketTypeSelected,
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
                      ),
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
                      ),
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
                      ),
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
                      ),
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
                                borderRadius: BorderRadius.circular(4)),
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
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(4)),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                        ),
                      if (serviceType[index] == 'Passar roupa' &&
                          serviceTypeSelected[index])
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(4)),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
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
