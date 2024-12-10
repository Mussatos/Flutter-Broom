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
      backgroundColor: Color(0xFF2ECC8F),
      appBar: AppBar(
        title: Text(
          'Informações do Usuário',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
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
        future: Future.wait([
          fetchUsuario(usuario.id),
          fetchCustomContractorProfile(usuario.id),
          fetchDataDiaristSpecialties(usuario.id),
          fetchDataDiaristZones(usuario.id)
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Color(0xFF2ECC8F)));
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar usuários'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Nenhum usuário encontrado'));
          } else {
            var userData = snapshot.data?[0] as UserModel?;
            var customData = snapshot.data?[1] as ContractorCustomInformation?;
            List<dynamic>? customDataSpeciality =
                snapshot.data?[2] as List<dynamic>;
            List<dynamic>? customDataZones = snapshot.data?[3] as List<dynamic>;

            if (userData == null) {
              return const Center(child: Text('Erro ao carregar dados'));
            }
            bool isAvailable = userData.wantService;

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
                      '${userData.name} ${userData.lastName}', // Usando dados diretamente do UserModel
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    if (profileId == 1) ...[
                      Text(
                        'Serviço: ${userData.wantService ? "Está à procura." : "Não está necessitando."}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade900,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                    ] else if (profileId == 2) ...[
                      Text(
                        'Disponível: ${userData.wantService ? "Sim." : "Não."}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade900,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                    ],
                    Text(
                      formatAddress,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 30),
                    Divider(thickness: 1, color: Colors.grey.shade300),
                    SizedBox(height: 20),
                    Text(
                      'Descrição:',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '${userData.description}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade900,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    if (profileId == 1) ...[
                      SizedBox(height: 20),
                     const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.build, color: Colors.black, size: 20),
                          SizedBox(width: 10),
                          Text(
                            'Procurando serviço:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        customData?.serviceType != null &&
                                customData?.serviceType != ""
                            ? '${customData?.serviceType}'
                            : 'Não especificado',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade900,
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.access_time,
                              color: Colors.black, size: 20),
                          SizedBox(width: 10),
                          Text(
                            'Horário de preferência:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        customData?.favoriteDaytime != null &&
                                customData?.favoriteDaytime != ""
                            ? '${customData?.favoriteDaytime}'
                            : 'Não especificado',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade900,
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.attach_money,
                              color: Colors.black, size: 20),
                          SizedBox(width: 10),
                          Text(
                            'Valor que estou disposto a pagar:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        customData?.valueWillingToPay != null &&
                                customData?.valueWillingToPay != 0
                            ? 'R\$${customData?.valueWillingToPay}'
                            : 'Não especificado',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade900,
                        ),
                      ),
                      SizedBox(height: 15),
                    ] else if (profileId == 2) ...[
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.pin_drop,
                              color: Colors.black, size: 20),
                          SizedBox(width: 10),
                          Text(
                            'Atendo nas seguintes regiões:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            customDataZones != null &&
                                    customDataZones.isNotEmpty
                                ? customDataZones
                                    .map((actv) => (actv['state'] ??
                                            actv['zone_id'].toString())
                                        .replaceAll('_', ' '))
                                    .join(', ')
                                : 'Não especificado',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade900,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cleaning_services,
                              color: Colors.black, size: 20),
                          SizedBox(width: 10),
                          Text(
                            'Especialidades:',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        customDataSpeciality != null &&
                                customDataSpeciality.isNotEmpty
                            ? customDataSpeciality
                                .map((spec) => spec['speciality']
                                    .toString()
                                    .replaceAll('_', ' '))
                                .join(', ')
                            : 'Não especificado',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade900,
                        ),
                      ),
                    ],
                    SizedBox(height: 15),
                    SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        /*
                        SE PROFILE ID DOS USUARIOS QUE ESTAO NA LISTA!!!!! nao o que esta logado
                        SE O USUARIO Q ESTA NA LISTA FOR CONTRATANTE VAI APARECER APENAS O BOTAO DE CONTATO
                        SE O USUARIO Q ESTA NA LISTA FOR DIARISTA APARECE O BOTAO DE CRIAR CONTRATO
                    */
                        if (profileId == 1) ...[
                          ElevatedButton.icon(
                            onPressed: isAvailable
                                ? () async {
                                    final phoneNumber =
                                        userData.cellphoneNumber;
                                    if (phoneNumber != null &&
                                        phoneNumber.isNotEmpty) {
                                      final whatsappUrl =
                                          'https://wa.me/$phoneNumber';
                                      if (await canLaunch(whatsappUrl)) {
                                        await launch(whatsappUrl);
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Não foi possível abrir o WhatsApp.'),
                                          ),
                                        );
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Número de telefone não cadastrado.'),
                                        ),
                                      );
                                    }
                                  }
                                : () {},
                            icon: Icon(Icons.message, color: Colors.white),
                            label: Text(
                              'Contatar pelo WhatsApp',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          )
                        ] else if (profileId == 2) ...[
                          ElevatedButton.icon(
                            onPressed: isAvailable
                                ? () async {
                                    final phoneNumber =
                                        userData.cellphoneNumber;
                                    if (phoneNumber.isNotEmpty) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Contract(
                                            idDoUser: usuario.id,
                                          ),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Número de telefone não cadastrado.'),
                                        ),
                                      );
                                    }
                                  }
                                : () {},
                            icon:
                                const Icon(Icons.message, color: Colors.white),
                            label: const Text(
                              'Criar contrato',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ],
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
