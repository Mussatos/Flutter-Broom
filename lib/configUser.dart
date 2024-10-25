import 'package:broom_main_vscode/main.dart';
import 'package:flutter/material.dart';

class ConfigUser extends StatefulWidget {
  const ConfigUser({super.key});

  @override
  State<ConfigUser> createState() => _ConfigUserState();
}

class _ConfigUserState extends State<ConfigUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurations'),
        elevation: 0,
        backgroundColor: Color(0xFF2ECC8F),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: GestureDetector(
                child: Text(
                  "Sair da conta",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.red),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomePage(
                                loggedOut: true,
                              )));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
