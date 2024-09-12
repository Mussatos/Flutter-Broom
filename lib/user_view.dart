import 'package:flutter/material.dart';
import 'user.dart';
import 'package:broom_main_vscode/ui-components/user_image.dart';

class UserView extends StatelessWidget {
  final ListUsers usuario;
  final String token =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImxpYW5taXJhbmRhMjZAZ21haWwuY29tIiwiaWQiOjEsImlhdCI6MTcyNjA5NjY2NSwiZXhwIjoxNzI2MTExMDY1LCJpc3MiOiJsb2dpbiIsInN1YiI6IjEifQ.79PLGjF55TpD0RIRtthvfmrrBuyCNa4NAOzoUZh2x64";

  UserView({required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Informações do Usuário'),
        backgroundColor: Colors.green,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                child: UserImage(user: usuario, token: token),
              ),
              SizedBox(height: 10),
              Text(
                '${usuario.firstName} ${usuario.lastName} \nServiço: ${usuario.wantService} \nEndereço: ${usuario.address}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
