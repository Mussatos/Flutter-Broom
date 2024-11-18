import 'package:broom_main_vscode/api/user.api.dart';
import 'package:broom_main_vscode/models/bank_info.model.dart';
import 'package:broom_main_vscode/ui-components/text_button.dart';
import 'package:broom_main_vscode/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BankInformationEdit extends StatefulWidget {
  final BankInfo diaristInfo;
  const BankInformationEdit({super.key, required this.diaristInfo});

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

  Map<String, bool> errors = {
    'account_name': false,
    'bank_name': false,
    'account_number': false,
    'agency': false,
    'pix_key': false
  };

  @override
  void initState() {
    accountNameController.addListener(accountNameValidation);
    bankNameController.addListener(bankNameValidation);
    accountNumberController.addListener(accountNumberValidation);
    agencyController.addListener(agencyValidation);
    accountNameController.text = widget.diaristInfo.accountName ?? '';
    bankNameController.text = widget.diaristInfo.bankName ?? '';
    accountNumberController.text =
        widget.diaristInfo.accountNumber?? '';
    agencyController.text = widget.diaristInfo.agency?? '';
    pixKeyController.text = widget.diaristInfo.pixKey ?? '';
    super.initState();
  }

  @override
  void dispose() {
    accountNameController.dispose();
    bankNameController.dispose();
    accountNumberController.dispose();
    agencyController.dispose();
    pixKeyController.dispose();
    super.dispose();
  }

  Future<void> saveInfos(context) async {
    validations();
    if (errors.containsValue(true)) return;

    Map<String, dynamic> body = {
      'account_name': accountNameController.text,
      'bank_name': bankNameController.text,
    };

    if (pixKeyController.text.isNotEmpty) {
      body.addAll({'pix_key': pixKeyController.text});
    }

    if (agencyController.text.isNotEmpty) {
      body.addAll({
        'account_number': accountNumberController.text,
        'agency': agencyController.text,
      });
    }
    await updateDiaistBankInformation(body);

    GoRouter.of(context).push('/bank/information');
  }

  void validations() {
    bankNameValidation();
    accountNameValidation();
    accountNumberValidation();
    agencyValidation();
  }

  void bankNameValidation() {
    setState(() {
      errors['bank_name'] = bankNameController.text.isEmpty ||
          !validName(bankNameController.text);
    });
  }

  void accountNameValidation() {
    setState(() {
      errors['account_name'] = accountNameController.text.isEmpty ||
          !validName(accountNameController.text);
    });
  }

  void agencyValidation() {
    setState(() {
      errors['agency'] = isNotNumber(agencyController.text);
    });
  }

  void accountNumberValidation() {
    setState(() {
      errors['account_number'] = agencyController.text.isNotEmpty &&
              accountNumberController.text.isEmpty ||
          isNotNumber(accountNumberController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edição de informações',
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
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(12.0),
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextFormField(
                controller: bankNameController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Nome do banco',
                  errorText: errors['bank_name']! ? 'Valor inválido' : null,
                  border: const OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              TextFormField(
                controller: accountNameController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Nome da conta',
                  errorText: errors['account_name']! ? 'Valor inválido' : null,
                  border: const OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              TextFormField(
                controller: pixKeyController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Chave pix',
                  errorText: errors['pix_key']! ? 'Valor inválido' : null,
                  border: const OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              TextFormField(
                controller: agencyController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Agência da conta',
                  errorText: errors['agency']! ? 'Valor inválido' : null,
                  border: const OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              TextFormField(
                controller: accountNumberController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Número da conta',
                  errorText:
                      errors['account_number']! ? 'Valor inválido' : null,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              ButtonText(
                  btnText: 'Salvar',
                  width: 150,
                  function: () => {saveInfos(context)})
            ],
          ),
        ),
      ),
    );
  }
}
