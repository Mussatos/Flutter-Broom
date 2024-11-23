import 'package:flutter/material.dart';

class Meetingview extends StatefulWidget {
  const Meetingview({super.key});

  @override
  State<Meetingview> createState() => _MeetingviewState();
}

class _MeetingviewState extends State<Meetingview> {
  void _handleFinalize() {
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

  void _handleRefund() {
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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
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
                      style: TextStyle(fontSize: 18, color: Colors.white),
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
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
