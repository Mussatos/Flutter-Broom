import 'package:broom_main_vscode/api/user.api.dart';
import 'package:broom_main_vscode/user.dart';
import 'package:flutter/material.dart';

class Meetingview extends StatefulWidget {
  int agendamentoId;

  Meetingview({super.key, required this.agendamentoId});

  @override
  State<Meetingview> createState() => _MeetingviewState();
}

class _MeetingviewState extends State<Meetingview> {
  Future<PaymentDetails?>? dailyList;

  void _handleFinalize() async {
    await finishContract(widget.agendamentoId);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Agendamento Finalizado"),
        content: const Text("O agendamento foi finalizado com sucesso."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Fechar"),
          ),
        ],
      ),
    );
  }

  void _handleRefund() async {
    await requestRefund(widget.agendamentoId);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Solicitação de Reembolso"),
        content: const Text("A solicitação de reembolso foi enviada."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Fechar"),
          ),
        ],
      ),
    );
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
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            if (snapshot.data![1] == 1) ...[
                              ElevatedButton(
                                onPressed: _handleFinalize,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  "Finalizar",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: _handleRefund,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  "Reembolso",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ),
                            ],
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
