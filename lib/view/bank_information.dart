import 'package:broom_main_vscode/api/user.api.dart';
import 'package:flutter/material.dart';

class BankInformation extends StatefulWidget {
  const BankInformation({super.key});

  @override
  State<BankInformation> createState() => _BankInformationState();
}

class _BankInformationState extends State<BankInformation> {

  Future<Map<String, dynamic>>? bankInformation;
  
  @override
  void initState() {
    bankInformation = fetcheDiaistBankInformation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Minhas informações bancárias',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF2ECC8F),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 24,
            color: Colors.black,
          ),
        ),
      ),
      body: FutureBuilder(
        future: Future,
        initialData: InitialData,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return ;
        },
      ),,
      ),
    );
  }
}
