import 'package:flutter/material.dart';
import 'user.dart';
import 'package:broom_main_vscode/ui-components/user_image.dart';
import 'package:broom_main_vscode/view/user_list.dart';

class UserView extends StatelessWidget {
  final ListUsers usuario;
  final String token =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InJhZmFAZ21haWwuY29tIiwiaWQiOjQsImlhdCI6MTcyNjI1ODU2NCwiZXhwIjoxNzI2MjcyOTY0LCJpc3MiOiJsb2dpbiIsInN1YiI6IjQifQ.cAAnF2Hh8RwU_la3IIrYR4mSYOrx0F-k5LQRLPjIE-s";

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
    final address = usuario.address[0];
    final formatAddress = 'Endereço: Bairro ${address['neighborhood']}, ${address['city']}, ${address['state']}';

    return Scaffold(
      appBar: AppBar(
        title: Text('Informações do Usuário'),
        backgroundColor: Color(0xFF2ECC8F),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
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
                child: UserImage(user: usuario),
              ),
              SizedBox(height: 10),
              Text(
                '${usuario.firstName} ${usuario.lastName} \nServiço: ${usuario.wantService} \n$formatAddress',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                'Descrição: Lorem Ipsum é simplesmente uma simulação de texto da indústria tipográfica e de impressos, e vem sendo utilizado desde o século XVI, quando um impressor desconhecido pegou uma bandeja de tipos e os embaralhou para fazer um livro de modelos de tipos.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                textAlign: TextAlign.justify,
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      icon: Icon(Icons.edit, color: Colors.green, size: 40),
                      onPressed: () {} //_openWhatsApp,
                      ),
                  IconButton(
                      icon: Icon(Icons.email, color: Colors.blue, size: 40),
                      onPressed: () {} //_sendEmail,
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
