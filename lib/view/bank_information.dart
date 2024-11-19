import 'package:broom_main_vscode/api/user.api.dart';
import 'package:broom_main_vscode/models/bank_info.model.dart';
import 'package:broom_main_vscode/ui-components/icon_button.dart';
import 'package:broom_main_vscode/ui-components/modal.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BankInformation extends StatefulWidget {
  const BankInformation({super.key});

  @override
  State<BankInformation> createState() => _BankInformationState();
}

class _BankInformationState extends State<BankInformation> {
  Future<BankInfo?>? bankInformation;
  bool isLoading = false;
  BankInfo? diaristInfo;

  void goToEditInformations() {
    GoRouter.of(context).push('/bank/information/edit', extra: diaristInfo);
  }

  Future<void> handleCreateDiaristInformation() async {
    setState(() {
      isLoading = true;
    });

    try {
      bool hasCreatedSuccessfuly = await createDiaistBankInformationRelation();

      if (hasCreatedSuccessfuly) {
        setState(() {
          getDiaristInformation();
          goToEditInformations();
        });
        return;
      }

      throw Exception();
    } catch (err) {
      if (mounted) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return Modal(
                title: 'Erro ao cadastrar',
                message:
                    'Houve um erro ao inicializar o cadastros de suas informações, tente novamente mais tarde',
                showOneButton: true,
              );
            });
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void getDiaristInformation() {
    bankInformation = fetcheDiaistBankInformation();
  }

  @override
  void initState() {
    getDiaristInformation();
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
          future: bankInformation,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            diaristInfo = snapshot.data;
            return isLoading
                ? const CircularProgressIndicator()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (diaristInfo == null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () => handleCreateDiaristInformation(),
                              child: Container(
                                width: 200,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Color(0xFF2ECC8F),
                                        style: BorderStyle.solid,
                                        width: 3)),
                                child: const Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Adicionar informações',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Icon(
                                        Icons.add,
                                        color: Color(0xFF2ECC8F),
                                        size: 30,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      else
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color(0xFF2ECC8F),
                                      style: BorderStyle.solid,
                                      width: 3)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          'TItular:',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(' ${diaristInfo!.accountName}',
                                            style: TextStyle(
                                                color: Colors.grey[800],
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14)),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        const Text('Banco:',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600)),
                                        Text(' ${diaristInfo!.bankName}',
                                            style: TextStyle(
                                                color: Colors.grey[800],
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14)),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    if (diaristInfo!.pixKey != null)
                                      Row(
                                        children: [
                                          const Text('Chave Pix:',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600)),
                                          Text(' ${diaristInfo!.pixKey}',
                                              style: TextStyle(
                                                  color: Colors.grey[800],
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14)),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    if (diaristInfo!.agency != null)
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              const Text('Agência: ',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600)),
                                              Text(' ${diaristInfo!.agency}',
                                                  style: TextStyle(
                                                      color: Colors.grey[800],
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 14)),
                                            ],
                                          ),
                                          const SizedBox(
                                        height: 10,
                                      ),
                                          Row(
                                            children: [
                                              const Text('Número da conta:',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600)),
                                              Text(
                                                  ' ${diaristInfo!.accountNumber}',
                                                  style: TextStyle(
                                                      color: Colors.grey[800],
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 14)),
                                            ],
                                          )
                                        ],
                                      ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    ButtonIcon(
                                        btnText: 'Editar',
                                        btnIcon: Icons.edit_square,
                                        width: 200,
                                        function: () =>
                                            {goToEditInformations()})
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                    ],
                  );
          },
        ));
  }
}
