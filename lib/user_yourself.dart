import 'package:broom_main_vscode/address_form.dart';
import 'package:broom_main_vscode/address_list.dart';
import 'package:broom_main_vscode/api/user.api.dart';
import 'package:broom_main_vscode/edit_user.dart';
import 'package:broom_main_vscode/main.dart';
import 'package:broom_main_vscode/ui-components/user_image.dart';
import 'package:broom_main_vscode/user.dart';
import 'package:broom_main_vscode/view/user_list.dart';
import 'package:flutter/material.dart';

class UserYourself extends StatefulWidget {
  UserYourself();

  @override
  State<UserYourself> createState() => _UserYourselfState();
}

class _UserYourselfState extends State<UserYourself> {
  @override
  Widget build(BuildContext context) {
    String getListUserFormatedAddress(Map<String, dynamic> address) {
      Address userAddress = Address.fromJson(address);
      if (userAddress.state == '' ||
          userAddress.neighborhood == '' ||
          userAddress.city == '') return '';

      return '${userAddress.neighborhood} - ${userAddress.city!}, ${userAddress.state!}';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Profile',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Color(0xFF2ECC8F),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => UserList()));
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 24,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: getUserById(),
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
                                  wantService: false)),
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
                        SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () async {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddressList()));
                              },
                              icon:
                                  Icon(Icons.location_on, color: Colors.white),
                              label: Text(
                                'Address',
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
                                                  lastName:
                                                      snapshot.data?.lastName,
                                                  email: snapshot.data?.email,
                                                  cellphoneNumber: snapshot
                                                      .data?.cellphoneNumber,
                                                  description: snapshot
                                                      .data?.description,
                                                  wantService: snapshot
                                                      .data?.wantService,
                                                  userActualImage:
                                                      snapshot.data?.userImage),
                                            )));
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
      ),
    );
  }
}
