import 'package:broom_main_vscode/api/user.api.dart';
import 'package:broom_main_vscode/utils/user_autentication.dart';
import 'package:flutter/material.dart';
import 'user.dart'; // Para usar a classe Address

class AddressForm extends StatefulWidget {
  @override
  _AddressFormState createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  final _formKey = GlobalKey<FormState>();
  UserAutentication autentication = UserAutentication();

  final TextEditingController streetController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController neighController = TextEditingController();
  final TextEditingController addressCodeController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController complementController = TextEditingController();
  List<String> addressType = [
    'Residencia',
    'Condominio',
    'Apartamento',
    'Comercio',
    'Studio'
  ];
  String addressTypeSelected = 'Residencia';

  @override
  void dispose() {
    streetController.dispose();
    numberController.dispose();
    stateController.dispose();
    neighController.dispose();
    addressCodeController.dispose();
    complementController.dispose();
    super.dispose();
  }

  void saveAddress() async {
    int? userId = await autentication.getUserId();
    if (_formKey.currentState!.validate()) {
      Address newAddress = Address(
        city: cityController.text,
        state: stateController.text,
        street: streetController.text,
        addressType: addressTypeSelected,
        neighborhood: neighController.text,
        addressCode: addressCodeController.text,
        complement: complementController.text,
        number: numberController.text,
        userId: userId,
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Registrar Endereço',
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
      body: Container(
        color: Color(0xFF2ECC8F),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(35.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                width: 350,
                child: TextFormField(
                  controller: addressCodeController,
                  decoration: InputDecoration(
                    labelText: 'CEP',
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.transparent,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe o CEP';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 350,
                child: TextFormField(
                  controller: stateController,
                  decoration: InputDecoration(
                    labelText: 'Estado',
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.transparent,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe o seu estado';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 350,
                child: TextFormField(
                  controller: cityController,
                  decoration: InputDecoration(
                    labelText: 'Cidade',
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.transparent,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe a sua cidade';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 350,
                child: TextFormField(
                  controller: streetController,
                  decoration: InputDecoration(
                    labelText: 'Rua',
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.transparent,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe a sua rua';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 350,
                child: TextFormField(
                  controller: neighController,
                  decoration: InputDecoration(
                    labelText: 'Bairro',
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.transparent,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe o bairro';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 350,
                child: TextFormField(
                  controller: numberController,
                  decoration: InputDecoration(
                    labelText: 'Número',
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.transparent,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe o número';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: 350,
                child: TextFormField(
                  controller: complementController,
                  decoration: InputDecoration(
                    labelText: 'Complemento',
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.transparent,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe o complemento';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: 350,
                child: Text(
                  'Escolha o tipo do endereço',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(
                width: 350,
                child: DropdownButton<String>(
                    value: addressTypeSelected,
                    underline: Container(
                      height: 1,
                      color: Colors.white,
                    ),
                    dropdownColor: Colors.black,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    isExpanded: true,
                    iconSize: 35,
                    iconEnabledColor: Colors.white,
                    items: addressType
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                          value: value, child: Text(value));
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        addressTypeSelected = value!;
                      });
                    }),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: 350,
                height: 50,
                child: TextButton(
                  onPressed: saveAddress,
                  child: Text('Salvar Endereço'),
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
