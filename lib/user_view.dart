import 'package:flutter/material.dart';
import 'user.dart';
import 'package:broom_main_vscode/ui-components/user_image.dart';

class UserView extends StatelessWidget {
  final ListUsers usuario;
  final String token =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImxpYW5taXJhbmRhMjZAZ21haWwuY29tIiwiaWQiOjEsImlhdCI6MTcyNjA5NjY2NSwiZXhwIjoxNzI2MTExMDY1LCJpc3MiOiJsb2dpbiIsInN1YiI6IjEifQ.79PLGjF55TpD0RIRtthvfmrrBuyCNa4NAOzoUZh2x64";

  UserView({required this.usuario});

/*
  _openWhatsApp() async {
    var whatsappUrl = "whatsapp://send?phone=${usuario.cellphone_number}";
    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      print("Não foi possível abrir o WhatsApp");
    }
  }

  _sendEmail() async {
    var emailUrl = "mailto:${usuario.email}";
    if (await canLaunch(emailUrl)) {
      await launch(emailUrl);
    } else {
      print("Não foi possível abrir o aplicativo de email");
    }
  }
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Informações do Usuário'),
        backgroundColor: Color(0xFF2ECC8F),
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
              /*
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.whatsapp, color: Colors.green, size: 40),
                    onPressed: _openWhatsApp,
                  ),
                  IconButton(
                    icon: Icon(Icons.email, color: Colors.blue, size: 40),
                    onPressed: _sendEmail,
                  ),
                ],
              ),
              */
            ],
          ),
        ),
      ),
    );
  }
}
