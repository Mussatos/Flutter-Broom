import 'package:broom_main_vscode/api/user.api.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
  final TextEditingController clothController = TextEditingController();
  final TextEditingController clothCleanController = TextEditingController();
  final TextEditingController dishesController = TextEditingController();
  final TextEditingController obsController = TextEditingController();
  bool? petsController = false;
  bool? materialController = false;

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

  ApiService apiService = ApiService();

  Future<void> sendContract() async {
    List<String> selectedServices = [];
    for (int i = 0; i < serviceType.length; i++) {
      if (serviceTypeSelected[i]) {
        selectedServices.add(serviceType[i]);
      }
    }

    String? whatsappUrl = await apiService.sendContract(
      tiposDeServico: selectedServices,
      tipoLimpeza: cleanTypeSelected,
      possuiPets: petsController ?? false,
      possuiMaterialLimpeza: materialController ?? false,
      quantidadeRoupaLavar: int.tryParse(clothController.text) ?? 0,
      quantidadeRoupaPassar: int.tryParse(clothCleanController.text) ?? 0,
      quantidadeLouca: int.tryParse(dishesController.text) ?? 0,
      quantidadeQuarto: int.tryParse(bedroomController.text) ?? 0,
      quantidadeBanheiro: int.tryParse(toiletController.text) ?? 0,
      quantidadeSala: int.tryParse(roomController.text) ?? 0,
      mensagem: obsController.text,
      id: widget.idDoUser,
    );

    launchWhatsApp(whatsappUrl!);
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
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(35.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: bedroomController,
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
                    decoration: InputDecoration(
                      labelText: 'Sala',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Checkbox(
                  value: petsController,
                  onChanged: (bool? value) {
                    setState(() {
                      petsController = value;
                    });
                  },
                ),
                Text('Possui Pets'),
                SizedBox(width: 20),
                Checkbox(
                  value: materialController,
                  onChanged: (bool? value) {
                    setState(() {
                      materialController = value;
                    });
                  },
                ),
                Text('Possui Material de Limpeza'),
              ],
            ),
            SizedBox(height: 20),
            Column(
              children: List.generate(serviceType.length, (index) {
                return Column(
                  children: [
                    CheckboxListTile(
                      title: Text(serviceType[index]),
                      value: serviceTypeSelected[index],
                      onChanged: (bool? value) {
                        setState(() {
                          serviceTypeSelected[index] = value!;
                        });
                      },
                    ),
                    if (serviceType[index] == 'Limpeza' &&
                        serviceTypeSelected[index])
                      DropdownButton<String>(
                        value: cleanTypeSelected,
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
                        underline: Container(
                          height: 2,
                          color: Colors.greenAccent,
                        ),
                      ),
                    if (serviceType[index] == 'Lavar roupa' &&
                        serviceTypeSelected[index])
                      TextFormField(
                        controller: clothController,
                        decoration: InputDecoration(
                          labelText: 'Quantidade de Roupa',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    if (serviceType[index] == 'Passar roupa' &&
                        serviceTypeSelected[index])
                      TextFormField(
                        controller: clothCleanController,
                        decoration: InputDecoration(
                          labelText: 'Quantidade para Passar Roupa',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    if (serviceType[index] == 'Lavar louça' &&
                        serviceTypeSelected[index])
                      TextFormField(
                        controller: dishesController,
                        decoration: InputDecoration(
                          labelText: 'Quantidade de Louça',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
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
    );
  }
}
