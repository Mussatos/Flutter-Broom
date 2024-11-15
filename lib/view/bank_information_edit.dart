import 'package:flutter/material.dart';

class BankInformationEdit extends StatefulWidget {
  const BankInformationEdit({super.key});

  @override
  State<BankInformationEdit> createState() => _BankInformationEditState();
}

class _BankInformationEditState extends State<BankInformationEdit> {
  TextEditingController accountNameController = TextEditingController(text: '');
  TextEditingController bankNameController = TextEditingController(text: '');
  TextEditingController accountNumberController =
      TextEditingController(text: '');
  TextEditingController agencyController = TextEditingController(text: '');
  TextEditingController pixKeyController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edição de informações',
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
              TextFormField(
                controller: bankNameController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Nome do banco',
                  errorText: true ? 'Valor inválido' : null,
                  border: OutlineInputBorder(),
                ),
              ),
              TextFormField(
                controller: accountNameController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Nome da conta',
                  errorText: true ? 'Valor inválido' : null,
                  border: OutlineInputBorder(),
                ),
              ),
              TextFormField(
                controller: pixKeyController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Chave pix',
                  errorText: true ? 'Valor inválido' : null,
                  border: OutlineInputBorder(),
                ),
              ),
              TextFormField(
                controller: agencyController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Agência da conta',
                  errorText: true ? 'Valor inválido' : null,
                  border: OutlineInputBorder(),
                ),
              ),
              TextFormField(
                controller: accountNumberController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Número da conta',
                  errorText: true ? 'Valor inválido' : null,
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
