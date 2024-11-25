import 'package:broom_main_vscode/api/user.api.dart';
import 'package:broom_main_vscode/ui-components/icon_button.dart';
import 'package:broom_main_vscode/ui-components/modal.dart';
import 'package:broom_main_vscode/user.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Meetingview extends StatefulWidget {
  int agendamentoId;

  Meetingview({super.key, required this.agendamentoId});

  @override
  State<Meetingview> createState() => _MeetingviewState();
}

class _MeetingviewState extends State<Meetingview> {
  PaymentDetails? dailyList;

  Future<void> _handleFinalize(context) async {
    final isFinished = await finishContract(widget.agendamentoId);

    if (isFinished) {
      showDialog(
          context: context,
          builder: (context) => Modal(
                title: "Agendamento Finalizado",
                message: "O agendamento foi finalizado com sucesso.",
                mainButtonTitle: "Fechar",
                showOneButton: true,
                click: () {
                  Navigator.pop(context);
                  setState(() {});
                },
              ));
    } else {
      showDialog(
          context: context,
          builder: (context) => Modal(
                title: "Erro ao finalizar agendamento",
                message:
                    "O agendamento só pode ser finalizado a partir da data prevista para o serviço.",
                mainButtonTitle: "Fechar",
                showOneButton: true,
                click: () {
                  Navigator.pop(context);
                },
              ));
    }
  }

  Future<void> _handleRefund(context) async {
    await requestRefund(widget.agendamentoId);
    showDialog(
        context: context,
        builder: (context) => Modal(
              title: "Solicitação de Reembolso",
              message: "A solicitação de reembolso foi enviada.",
              mainButtonTitle: "Fechar",
              showOneButton: true,
              click: () {
                GoRouter.of(context).push('/meeting-page');
              },
            ));
  }

  bool isPendingPayment(int profileId) {
    return dailyList!.contractorPayment!.status == 'processando' &&
        profileId == 1;
  }

  Future<void> retrieveCheckout() async {
    final String sessionUrl =
        await requestCheckout(dailyList!.contractorPayment!.stripeCs);
    if (sessionUrl.isNotEmpty) {
      await launchUrlString(sessionUrl);
    }
  }

  String getDailyType(String type) {
    return type.replaceAll('_', ' ');
  }

  String getFullName(String firstName, String lastName) {
    return '$firstName $lastName';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Informações sobre o agendamento',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          backgroundColor: const Color(0xFF2ECC8F),
          leading: IconButton(
            onPressed: () {
              GoRouter.of(context).push('/meeting-page');
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 24,
              color: Colors.black,
            ),
          ),
        ),
        body: FutureBuilder(
            future: Future.wait({
              fetchUnicContract(widget.agendamentoId),
              autentication.getProfileId(),
            }),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(
                    child: Text('Erro ao carregar agendamentos'));
              } else if (!snapshot.hasData) {
                return const Center(
                    child: Text('Nenhum agendamentos encontrado'));
              } else {
                if (snapshot.data?[0] != null) {
                  dailyList = snapshot.data![0] as PaymentDetails;
                }
                return isPendingPayment(snapshot.data![1] as int)
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Você ainda não pagou este agendamento',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                            softWrap: true,
                            textWidthBasis: TextWidthBasis.parent,
                            overflow: TextOverflow.clip,
                          ),
                          const Text(
                            'Caso não pague em até 24 horas o agendamento será cancelado automaticamente.',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ButtonIcon(
                              btnText: 'Pagar',
                              btnIcon: Icons.payment,
                              width: 150,
                              function: () => retrieveCheckout())
                        ],
                      )
                    : Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (snapshot.data?[1] != null &&
                                      snapshot.data![1] == 1) ...[
                                    const Text(
                                      'Ações',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () async {
                                            dailyList!.finished! ||
                                                    dailyList!.refund!
                                                ? null
                                                : _handleFinalize(context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                dailyList!.finished! ||
                                                        dailyList!.refund!
                                                    ? Colors.grey
                                                    : Colors.green,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 24,
                                              vertical: 12,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Text(
                                            "Finalizar",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            dailyList!.finished! ||
                                                    dailyList!.refund!
                                                ? null
                                                : await _handleRefund(context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                dailyList!.finished! ||
                                                        dailyList!.refund!
                                                    ? Colors.grey
                                                    : Colors.red,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 24,
                                              vertical: 12,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Text(
                                            "Reembolso",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                  Row(
                                    children: [
                                      Text(''),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(''),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Tipo de diaria: ',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Text(getDailyType(dailyList!.tipoDiaria!),
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text('Data da diaria: ',
                                          style: TextStyle(fontSize: 16)),
                                      Text(
                                        DateFormat('dd/MM/yyyy').format(
                                            dailyList!.agendamentoDate!),
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text('Diarista: ',
                                          style: TextStyle(fontSize: 16)),
                                      Text(
                                        getFullName(
                                            dailyList!.diaristFirstName!,
                                            dailyList!.diaristLastName!),
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text('Contratante: ',
                                          style: TextStyle(fontSize: 16)),
                                      Text(
                                        getFullName(
                                            dailyList!.contractorFirstName!,
                                            dailyList!.contractorLastName!),
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ]),
                          ],
                        ),
                      );
              }
            }),
      ),
    );
  }
}
