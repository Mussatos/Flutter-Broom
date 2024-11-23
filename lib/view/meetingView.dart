import 'package:flutter/material.dart';

class Meetingview extends StatefulWidget {
  const Meetingview({super.key});

  @override
  State<Meetingview> createState() => _MeetingviewState();
}

class _MeetingviewState extends State<Meetingview> {
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
        body: Container(
        ),
      ),
    );
  }
}
