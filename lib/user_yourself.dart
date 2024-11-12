import 'package:broom_main_vscode/address_form.dart';
import 'package:broom_main_vscode/address_list.dart';
import 'package:broom_main_vscode/api/user.api.dart';
import 'package:broom_main_vscode/edit_user.dart';
import 'package:broom_main_vscode/main.dart';
import 'package:broom_main_vscode/ui-components/user_image.dart';
import 'package:broom_main_vscode/user.dart';
import 'package:broom_main_vscode/view/user_list.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserYourself extends StatefulWidget {
  UserYourself();

  @override
  State<UserYourself> createState() => _UserYourselfState();
}

class _UserYourselfState extends State<UserYourself> {
  int? profileId;
  ContractorCustomInformation? customData;
  List<dynamic>? customDataSpecialties = [];
  List<dynamic>? customDataActivity = [];

  @override
  Widget build(BuildContext context) {
    String getListUserFormatedAddress(Map<String, dynamic> address) {
      Address userAddress = Address.fromJson(address);
      if (userAddress.state == '' ||
          userAddress.neighborhood == '' ||
          userAddress.city == '') return '';

      return '${userAddress.neighborhood} - ${userAddress.city!}, ${userAddress.state!}';
    }

    Future<Yourself?> fetchUserById() async {
      profileId = await autentication.getProfileId();
      final userData = await getUserById();

      if (userData != null && profileId == 1) {
        customData = await fetchCustomContractorProfile(userData.id);
      } else if (userData != null && profileId == 2) {
        customDataSpecialties = await fetchDataDiaristSpecialties(userData.id);
        customDataActivity = await fetchDataDiaristZones(userData.id);
      }

      return userData;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Seu Perfil',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Color(0xFF2ECC8F),
        leading: IconButton(
          onPressed: () {
            GoRouter.of(context).push("/List");
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 24,
            color: Colors.black,
          ),
        ),
      ),
      body: FutureBuilder(
        future: fetchUserById(),
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
                        child: UserImage(
                            user: ListUsers(
                                address: [],
                                firstName: '',
                                id: -1,
                                lastName: '',
                                profileId: -1,
                                userImage: snapshot.data!.userImage,
                                wantService: false,
                                isFavorite: false)),
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
                        snapshot.data!.address.length > 0
                            ? getListUserFormatedAddress(
                                snapshot.data?.address[0])
                            : '',
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
                      SizedBox(
                        height: 10,
                      ),
                      if (profileId == 1) ...[
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.build,
                                color: Color(0xFF2ECC8F), size: 20),
                            SizedBox(width: 10),
                            Text(
                              'Tipo de serviço que estou procurando:',
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
                            color: Colors.grey.shade700,
                          ),
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.access_time,
                                color: Color(0xFF2ECC8F), size: 20),
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
                            color: Colors.grey.shade700,
                          ),
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.attach_money,
                                color: Color(0xFF2ECC8F), size: 20),
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
                            color: Colors.grey.shade700,
                          ),
                        ),
                        SizedBox(height: 15),
                      ] else if (profileId == 2) ...[
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.pin_drop,
                                color: Color(0xFF2ECC8F), size: 20),
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
                        Text(
                          '${customDataActivity!.map((actv) => actv['state'] ?? actv['zone_id'].toString().replaceAll('_', ' ')).join(', ') ?? 'Não especificado'}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cleaning_services,
                                color: Color(0xFF2ECC8F), size: 20),
                            SizedBox(width: 10),
                            Text(
                              'Especialidades:',
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
                          '${customDataSpecialties!.map((spec) => spec['speciality'].toString().replaceAll('_', ' ')).join(', ') ?? 'Não especificado'}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                      SizedBox(height: 150),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () async {
                              GoRouter.of(context).push('/address/list');
                            },
                            icon: Icon(Icons.location_on, color: Colors.white),
                            label: Text(
                              'Endereços',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF2ECC8F),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditUserForm(
                                      usersEdit: EditUser(
                                        name: snapshot.data?.name,
                                        lastName: snapshot.data?.lastName,
                                        email: snapshot.data?.email,
                                        cellphoneNumber:
                                            snapshot.data?.cellphoneNumber,
                                        description: snapshot.data?.description,
                                        wantService: snapshot.data?.wantService,
                                        userActualImage:
                                            snapshot.data?.userImage,
                                        favoriteDaytime:
                                            customData?.favoriteDaytime,
                                        serviceType: customData?.serviceType,
                                        valueWillingToPay:
                                            customData?.valueWillingToPay,
                                        specialties: customDataSpecialties
                                            ?.map(
                                              (e) => e['speciality'].toString(),
                                            )
                                            .toList(),
                                        regionAtendiment: customDataActivity
                                            ?.map(
                                              (e) => e['zone_id'].toString(),
                                            )
                                            .toList(),
                                      ),
                                    ),
                                  ));
                            },
                            icon: Icon(Icons.edit, color: Colors.white),
                            label: Text(
                              'Editar',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF2ECC8F),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ]),
              ),
            );
          }
        },
      ),
    );
  }
}

class RegionTag extends StatelessWidget {
  final String text;

  const RegionTag({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: Color(0xFF2ECC8F),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
