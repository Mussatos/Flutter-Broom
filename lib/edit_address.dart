import 'package:broom_main_vscode/address_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:go_router/go_router.dart';
import 'user.dart';
import 'api/user.api.dart';

class EditAddressForm extends StatefulWidget {
  final Address address;

  EditAddressForm({required this.address});

  @override
  _EditAddressFormState createState() => _EditAddressFormState();
}

class _EditAddressFormState extends State<EditAddressForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController streetController;
  late TextEditingController numberController;
  late TextEditingController neighController;
  late TextEditingController addressCodeController;
  late TextEditingController stateController;
  late TextEditingController cityController;
  late TextEditingController complementController;
  late int? id;
  late String? addressTypeSelected;

  List<String> addressType = [
    'Residencia',
    'Condominio',
    'Apartamento',
    'Comercio',
    'Studio'
  ];

  @override
  void initState() {
    super.initState();

    id = widget.address.id;
    streetController = TextEditingController(text: widget.address.street);
    numberController =
        TextEditingController(text: widget.address.number.toString());
    neighController = TextEditingController(text: widget.address.neighborhood);
    addressCodeController = MaskedTextController(
        mask: '00000-000', text: widget.address.addressCode);
    stateController = TextEditingController(text: widget.address.state);
    cityController = TextEditingController(text: widget.address.city);
    complementController =
        TextEditingController(text: widget.address.complement);
    addressTypeSelected = widget.address.addressType;
  }

  @override
  void dispose() {
    streetController.dispose();
    numberController.dispose();
    stateController.dispose();
    cityController.dispose();
    neighController.dispose();
    addressCodeController.dispose();
    complementController.dispose();
    super.dispose();
  }

  void saveAddress() {
    if (_formKey.currentState!.validate()) {
      Address updatedAddress = Address(
        city: cityController.text,
        state: stateController.text,
        street: streetController.text,
        addressType: addressTypeSelected,
        neighborhood: neighController.text,
        addressCode: addressCodeController.text.replaceAll(RegExp(r'-'), ''),
        complement: complementController.text,
        number: int.parse(numberController.text),
        userId: widget.address.userId,
        id: null,
      );

      updateAddress(id, updatedAddress.toJson());

      GoRouter.of(context).push('/address/list');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Editar Endereço',
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
          color: Color(0xFF2ECC8F),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(35.0),
          height: MediaQuery.of(context).size.height,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  //width: 350,
                  width: screenWidth * 0.9,
                  child: TextFormField(
                    controller: addressCodeController,
                    // enabled: false,
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
                SizedBox(height: screenHeight * 0.020),
                SizedBox(
                  //width: 350,
                  width: screenWidth * 0.9,
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
                SizedBox(height: screenHeight * 0.020),
                SizedBox(
                  // width: 350,
                  width: screenWidth * 0.9,
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
                SizedBox(height: screenHeight * 0.020),
                SizedBox(
                  // width: 350,
                  width: screenWidth * 0.9,
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
                SizedBox(height: screenHeight * 0.020),
                SizedBox(
                  // width: 350,
                  width: screenWidth * 0.9,
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
                SizedBox(height: screenHeight * 0.020),
                SizedBox(
                  // width: 350,
                  width: screenWidth * 0.9,
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
                SizedBox(height: screenHeight * 0.020),
                SizedBox(
                  // width: 350,
                  width: screenWidth * 0.9,
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
                  ),
                ),
                SizedBox(height: screenHeight * 0.020),
                SizedBox(
                  // width: 350,
                  width: screenWidth * 0.9,
                  child: Text(
                    'Escolha o tipo do endereço',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                SizedBox(
                    // width: 350,
                    width: screenWidth * 0.9,
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
                        })),
                SizedBox(height: screenHeight * 0.050),
                SizedBox(
                  // width: 350,
                  width: screenWidth * 0.9,
                  height: 50,

                  child: TextButton(
                    onPressed: saveAddress,
                    child: Text('Salvar Alterações'),
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
      ),
    );
  }
}
