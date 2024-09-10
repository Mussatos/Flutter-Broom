import 'dart:typed_data';

import 'package:broom_main_vscode/api/user.api.dart';
import 'package:broom_main_vscode/user.dart';
import 'package:broom_main_vscode/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:broom_main_vscode/ui-components/user_image.dart';

class UserList extends StatelessWidget {
  const UserList({super.key});

  @override
  Widget build(BuildContext context) {
    final String token =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InZpbmljaXVzc2FudGFuYS5hemFtYnVqNEBnbWFpbC5jb20iLCJpZCI6MSwiaWF0IjoxNzI1OTk4Njc2LCJleHAiOjE3MjYwMTMwNzYsImlzcyI6ImxvZ2luIiwic3ViIjoiMSJ9.GHZboY3Tzq8xQ46q2SzA7UnYdUFowIh5YwRqN-LaXwU';

    UserProvider userProvider = UserProvider.of(context) as UserProvider;
    List<User> users = userProvider.users;
    int usersLength = users.length;

    List<Address> address = [];
    void addAddressForUser(ListUsers user) {
      if (user.address.length > 0)
        address.add(Address.fromJson(user.address[0]));
      else
        address.add(Address(
            state: '',
            city: '',
            neighborhood: '',
            addressType: '',
            street: ''));
    }

    String getListUserFormatedAddress(Address userAddress) {
      if (userAddress.state == '' ||
          userAddress.neighborhood == '' ||
          userAddress.city == '') return '';

      return '${userAddress.neighborhood} - ${userAddress.city!}, ${userAddress.state!}';
    }

    String getListUserFullName(ListUsers user) {
      return '${user.firstName} ${user.lastName}';
    }

    return Scaffold(
      backgroundColor: Color(0xFF2ECC8F),
      appBar: AppBar(
        title: Text('User List'),
        elevation: 0,
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
      body: FutureBuilder<List<ListUsers>>(
        future: fetchUsuarios(token),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print(snapshot.data);
            print(snapshot.hasError);
            return Center(child: Text('Erro ao carregar usuários'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum usuário encontrado'));
          } else {
            List<ListUsers> usuarios = snapshot.data!;
            return ListView.builder(
              itemCount: usuarios.length,
              itemBuilder: (context, index) {
                ListUsers usuario = usuarios[index];
                addAddressForUser(usuario);

                return ListTile(
                  titleTextStyle: const TextStyle(
                      color: Colors.black87,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                  subtitleTextStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      decorationColor: Colors.white,
                      decoration: TextDecoration.overline),
                  leading: UserImage(user: usuario, token: token),
                  title: Text(getListUserFullName(usuario)),
                  subtitle: Text(getListUserFormatedAddress(address[index])),
                  onTap: () {
                    print(index);
                    print(usuario.id);
                    print(usuario.wantService);
                  },
                );
              },
            );
          }
        },
      ),
    );
    /*
      ListView.builder(
        itemCount: usersLength,
        itemBuilder: (BuildContext contextBuilder, indexBuilder) => Container(
          child: ListTile(
              title: Text(users[indexBuilder].name),
              subtitle: Text(users[indexBuilder].sobrenome),
              leading: Image.asset("assets/Logo_so_o_balde.png"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      onPressed: () {
                        //print(users[indexBuilder].profileId);
                        Navigator.popAndPushNamed(context, "/view");
                      },
                      icon: Icon(Icons.visibility, color: Colors.blue)),
                ],
              )),
          decoration:
              BoxDecoration(border: Border(bottom: BorderSide(width: 0.4))),
        ),
      ),*/
  }
}
