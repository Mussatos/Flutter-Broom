import 'package:broom_main_vscode/view/meetingView.dart';
import 'package:flutter/material.dart';

class Usermeeting extends StatefulWidget {
  const Usermeeting({Key? key}) : super(key: key);

  @override
  State<Usermeeting> createState() => _UsermeetingState();
}

class _UsermeetingState extends State<Usermeeting> {
  final List<Map<String, String>> schedules = const [
    {"date": "23/11/2024", "status": "Pago"},
    {"date": "24/11/2024", "status": "Processando"},
    {"date": "25/11/2024", "status": "Cancelado"},
  ];

  Color _getStatusColor(String status) {
    switch (status) {
      case "Pago":
        return Colors.green;
      case "Processando":
        return Colors.orange;
      case "Cancelado":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Meus Agendamentos',
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
          body: ListView.builder(
            itemCount: schedules.length,
            itemBuilder: (context, index) {
              final schedule = schedules[index];
              final date = schedule["date"] ?? "Data não definida";
              final status = schedule["status"] ?? "Status desconhecido";

              return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.purple,
                    child: Text(
                      (index + 1).toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    "Data: $date",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Status: $status",
                    style: TextStyle(color: _getStatusColor(status)),
                  ),
                  trailing: Icon(
                    Icons.event_note,
                    color: Colors.purple,
                  ),
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Meetingview())));
            },
          ),
        ));
  }
}
