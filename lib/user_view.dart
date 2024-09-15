import 'package:flutter/material.dart';
import 'user.dart';
import 'package:broom_main_vscode/ui-components/user_image.dart';

class UserView extends StatelessWidget {
  final ListUsers usuario;
  final String token =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InJhZmFAZ21haWwuY29tIiwiaWQiOjQsImlhdCI6MTcyNjI1ODU2NCwiZXhwIjoxNzI2MjcyOTY0LCJpc3MiOiJsb2dpbiIsInN1YiI6IjQifQ.cAAnF2Hh8RwU_la3IIrYR4mSYOrx0F-k5LQRLPjIE-s";

  UserView({required this.usuario});

  @override
  Widget build(BuildContext context) {
     final address = (usuario.address != null && usuario.address.isNotEmpty)
      ? usuario.address[0]
      : null;

  // Formata o endereço, se existir
  final formatAddress = address != null
      ? 'Endereço: Bairro ${address['neighborhood']}, ${address['city']}, ${address['state']}'
      : 'Endereço não cadastrado';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Informações do Usuário',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Color(0xFF2ECC8F),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 24,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey.shade200,
                child: UserImage(user: usuario),
              ),
              SizedBox(height: 20),
              Text(
                '${usuario.firstName} ${usuario.lastName}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Serviço: ${usuario.wantService}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                formatAddress,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              Divider(thickness: 1, color: Colors.grey.shade300),
              SizedBox(height: 20),
              Text(
                'Descrição:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Lorem Ipsum é simplesmente uma simulação de texto da indústria tipográfica e de impressos, e vem sendo utilizado desde o século XVI, quando um impressor desconhecido pegou uma bandeja de tipos e os embaralhou para fazer um livro de modelos de tipos.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {}, //_openWhatsApp,
                    icon: Icon(Icons.message, color: Colors.white),
                    label: Text('WhatsApp'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2ECC8F),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {}, //_sendEmail,
                    icon: Icon(Icons.email, color: Colors.white),
                    label: Text('Email'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2ECC8F),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
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
