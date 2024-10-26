import 'package:broom_main_vscode/api/user.api.dart';
import 'package:broom_main_vscode/contract.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'user.dart';
import 'package:broom_main_vscode/ui-components/user_image.dart';

class UserView extends StatelessWidget {
  final ListUsers usuario;

  UserView({required this.usuario});

  @override
  Widget build(BuildContext context) {
  int profileId = usuario.profileId;

    final address = (usuario.address != null && usuario.address.isNotEmpty)
        ? usuario.address[0]
        : null;

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
            color: Colors.black,
          ),
        ),
      ),
      body: FutureBuilder(
        future: fetchUsuario(usuario.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar usuários'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Nenhum usuário encontrado'));
          } else {
            return SingleChildScrollView(
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
                      '${snapshot.data?.name} ${snapshot.data?.lastName}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Serviço: ${snapshot.data!.wantService ? "Está à procura." : "Não está necessitando."}',
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
                      '${snapshot.data?.description}',
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
                    /*
                        SE PROFILE ID DOS USUARIOS QUE ESTAO NA LISTA!!!!! nao o que esta logado
                        SE O USUARIO Q ESTA NA LISTA FOR CONTRATANTE VAI APARECER APENAS O BOTAO DE CONTATO
                        SE O USUARIO Q ESTA NA LISTA FOR DIARISTA APARECE O BOTAO DE CRIAR CONTRATO
                    */
                    if (profileId == 1)
                      ElevatedButton.icon(
                        onPressed: () async {
                          final phoneNumber = snapshot.data?.cellphoneNumber;
                          if (phoneNumber != null) {
                            final whatsappUrl = 'https://wa.me/$phoneNumber';
                            if (await canLaunch(whatsappUrl)) {
                              await launch(whatsappUrl);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Não foi possível abrir o WhatsApp.'),
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Número de telefone não cadastrado.'),
                              ),
                            );
                          }
                        },
                        icon: Icon(Icons.message, color: Colors.white),
                        label: Text(
                          'Contatar pelo WhatsApp',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF2ECC8F),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      )
                    else
                      ElevatedButton.icon(
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Contract(
                                idDoUser: usuario.id,
                              ),
                            ),
                          );
                        },
                        icon: Icon(Icons.message, color: Colors.white),
                        label: Text(
                          'Criar contrato',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF2ECC8F),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
            );
          }
        },
      ),
    );
  }
}
