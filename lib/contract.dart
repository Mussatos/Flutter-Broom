import 'package:broom_main_vscode/api/user.api.dart';
import 'package:broom_main_vscode/calendaryPage.dart';
import 'package:broom_main_vscode/ui-components/modal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Contract extends StatefulWidget {
  int idDoUser;

  Contract({super.key, required this.idDoUser});

  @override
  _ContractState createState() => _ContractState();
}

class _ContractState extends State<Contract> {
  final ScrollController _scrollController = ScrollController();
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
  bool hasClickedToPay = false;
  bool isLoading = false;
  int? agendamentoId;
  Map<String, bool> invalidRooms = {
    'bedroom': false,
    'kitchen': false,
    'toilet': false,
    'room': false
  };
  Map<String, dynamic>? contractInformation;

  List<Map<String, String>> serviceType = [
    {'text': 'Limpeza*', 'value': 'limpeza'},
    {'text': 'Lavar roupa', 'value': 'lavar_roupa'},
    {'text': 'Passar roupa', 'value': 'passar_roupa'},
    {'text': 'Lavar louça', 'value': 'lavar_roupa'},
    {'text': 'Organizar ambiente', 'value': 'organizar_ambiente'}
  ];

  List<bool> serviceTypeSelected = [false, false, false, false, false];

  List<String> cleanType = ['Leve', 'Média', 'Pesada'];
  String cleanTypeSelected = 'Leve';

  String cleanBasketTypeSelected = 'cesto_pequeno'; //Lavar roupa
  List<Map<String, String>> cleanBasketType = [
    {'value': 'cesto_pequeno', 'text': 'Cesto pequeno'},
    {'value': 'cesto_medio', 'text': 'Cesto médio'},
    {'value': 'cesto_grande', 'text': 'Cesto grande'}
  ]; //Lavar roupa

  String ironingBasketTypeSelected = 'cesto_pequeno'; //Passar roupa
  List<Map<String, String>> ironingBasketType = [
    {'value': 'cesto_pequeno', 'text': 'Cesto pequeno'},
    {'value': 'cesto_medio', 'text': 'Cesto médio'},
    {'value': 'cesto_grande', 'text': 'Cesto grande'}
  ]; //Passar roupa

  bool _isBasketCleanQuantityValid = true;
  bool _isBasketIroningQuantityValid = true;

  @override
  void dispose() {
    _scrollController.dispose();
    bedroomController.dispose();
    kitchenController.dispose();
    toiletController.dispose();
    roomController.dispose();
    basketCleanQuantityController.dispose();
    basketIroningQuantityController.dispose();
    obsController.dispose();
    autentication.setWhatsappLink('');
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
    autentication.setWhatsappLink('');
    autentication.setAgendamentoId(-1);
    autentication.setCheckout('');
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
      Map<String, int> price_data = {
        'amount': contractInformation?['value'] * 100
      };
      final data = await payment(price_data);

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

  void scrollToInvalidField() {
    if (invalidRooms.containsValue(true)) {
      if (invalidRooms['bedroom']!) {
        _scrollController.animateTo(
          20.0,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        return;
      }
      if (invalidRooms['kitchen']!) {
        _scrollController.animateTo(
          20.0,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        return;
      }
      if (invalidRooms['room']!) {
        _scrollController.animateTo(
          20.0,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        return;
      }
      if (invalidRooms['toilet']!) {
        _scrollController.animateTo(
          20.0,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        return;
      }
    }
    if (!_isBasketCleanQuantityValid) {
      _scrollController.animateTo(
        300.0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      return;
    }

    if (!_isBasketIroningQuantityValid) {
      _scrollController.animateTo(
        300.0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      return;
    }
    if (!serviceTypeSelected[0]) {
      _scrollController.animateTo(
        80.0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      return;
    }
  }

  Future<void> initCheckout() async {
    Map<String, dynamic> priceData = {
      'currency': 'brl',
      'product_data': {
        'name': 'Contratação de serviço de limpeza doméstica',
      },
      'unit_amount': contractInformation?['value'] * 100,
    };
    int quantity = 1;

    final data = await paymentCheckout(priceData, quantity);

    if (data.isNotEmpty) {
      try {
        setState(() {
          isLoading = true;
        });
        await launchUrlString(data);
      } catch (e) {
        print(e.toString());
      } finally {
        setState(() {
          hasClickedToPay = true;
          isLoading = false;
        });
      }
    }
  }

  Future<void> sendContract() async {
    List<Map<String, String>> selectedServices = [];
    for (int i = 0; i < serviceType.length; i++) {
      if (serviceTypeSelected[i]) {
        selectedServices.add({'serviceType': serviceType[i]['value']!});
      }
    }

    if (!serviceTypeSelected[0]) {
      scrollToInvalidField();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por Favor, selecione ao menos um tipo de limpeza.'),
        ),
      );
      return;
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
      scrollToInvalidField();
      return;
    }

    if (invalidRooms.containsValue(true)) {
      scrollToInvalidField();
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

    if (!hasAgended()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Você deve realizar um agendamento para prosseguir.'),
        ),
      );
      return;
    }

    contractInformation = await apiService.sendContract(
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
      quantidadeCozinha: int.tryParse(kitchenController.text) ?? 0,
      mensagem: obsController.text,
      diaristaId: widget.idDoUser,
    );

    if (contractInformation != null && contractInformation!['link'] != '') {
      await autentication.setWhatsappLink(contractInformation!['link']);
      return;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Falha ao enviar contrato!!\nUsuário não cadastrou telefone para contato.'),
        ),
      );
      return;
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

  Future<void> launchWhatsApp(String url) async {
    if (url.isNotEmpty) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> sendContractToWhatsapp(context) async {
    String link = contractInformation!['link'];
    await launchWhatsApp(link);
    await autentication.setWhatsappLink('');
    GoRouter.of(context).push('/List');
  }

  Future<void> showFinishedContractModal(context) async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Modal(
            title: 'Agendamento de serviço finalizado!!',
            message:
                'Você será redirecionado para a tela de listagem de diarista',
            click: () async => await sendContractToWhatsapp(context),
            showOneButton: true,
            mainButtonTitle: 'Enviar contrato e voltar',
          );
        });
  }

  Future<void> handlePaymentByEnviroment() async {
    if (kIsWeb) {
      await initCheckout();
    } else {
      await initPaymentSheet();
    }
  }

  bool hasAgended() {
    return agendamentoId != null && agendamentoId != -1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2ECC8F),
      appBar: AppBar(
        title: Text(
          'Contrato',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () async {
            handleDeleteAgendamento();
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 24,
            color: Colors.black,
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Color(0xFF2ECC8F),
                  ),
                  Text('Redirecionando para pagamento',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2ECC8F)))
                ],
              ),
            )
          : SingleChildScrollView(
              controller: _scrollController,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(35.0),
                color: Color(0xFF2ECC8F),
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
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
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
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
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
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
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
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                errorText: invalidRooms['room']!
                                    ? 'Valor inválido'
                                    : null),
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
                              activeColor: Colors.black,
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
                              activeColor: Colors.black,
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: CheckboxListTile(
                                title: Text(
                                  serviceType[index]['text']!,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                value: serviceTypeSelected[index],
                                activeColor: Colors.black,
                                onChanged: (bool? value) {
                                  setState(() {
                                    serviceTypeSelected[index] = value!;
                                  });
                                },
                              ),
                            ),
                            if (serviceType[index]['text'] == 'Limpeza*' &&
                                serviceTypeSelected[index])
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(4),
                                    color: const Color(0xFF2ECC8F),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
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
                                      dropdownColor: const Color(0xFF2ECC8F),
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
                            if (serviceType[index]['text'] == 'Lavar roupa' &&
                                serviceTypeSelected[index])
                              Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(4),
                                      color: const Color(0xFF2ECC8F),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
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
                                        dropdownColor: const Color(0xFF2ECC8F),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            cleanBasketTypeSelected = newValue!;
                                          });
                                        },
                                        items: cleanBasketType
                                            .map((dynamic value) {
                                          return DropdownMenuItem<String>(
                                            value: value['value'],
                                            child: Text(value['text']),
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
                                      labelText:
                                          'Quantidade de cestos para lavar',
                                      border: OutlineInputBorder(),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                      errorText: !_isBasketCleanQuantityValid
                                          ? 'Valor inválido'
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                            if (serviceType[index]['text'] == 'Passar roupa' &&
                                serviceTypeSelected[index])
                              Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(4),
                                      color: const Color(0xFF2ECC8F),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
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
                                        dropdownColor: const Color(0xFF2ECC8F),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            ironingBasketTypeSelected =
                                                newValue!;
                                          });
                                        },
                                        items: ironingBasketType
                                            .map((dynamic value) {
                                          return DropdownMenuItem<String>(
                                            value: value['value'],
                                            child: Text(value['text']),
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
                                      labelText:
                                          'Quantidade de cestos para passar',
                                      errorText: !_isBasketIroningQuantityValid
                                          ? 'Valor inválido'
                                          : null,
                                      border: OutlineInputBorder(),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        );
                      }),
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () async {
                              agendamentoId =
                                  await autentication.getAgendamentoId();
                              print(agendamentoId);
                              if (agendamentoId == -1) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Calendarypage(
                                            idDoUser: widget.idDoUser)));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Você já marcou um agendamento com a diarista')),
                                );
                              }
                            },
                            icon: Icon(
                              Icons.calendar_today_rounded,
                              color: Colors.black,
                            )),
                        Text('Agendamento'),
                      ],
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: obsController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Observação',
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: 350,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });

                          try {
                            agendamentoId =
                                await autentication.getAgendamentoId();

                            await sendContract();
                            if (hasAgended()) {
                              await handlePaymentByEnviroment();
                            }
                            if (hasClickedToPay) {
                              showFinishedContractModal(context);
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(!serviceTypeSelected[0]
                                      ? 'Seleciona pelo menos um tipo de limpeza no campo Limpeza*'
                                      : 'Erro ao enviar contrato: Um ou mais campos inválidos')),
                            );
                          } finally {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                        child: Text('Pagar e enviar contrato'),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.black),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
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
