import 'dart:typed_data';

import 'package:broom_main_vscode/api/user.api.dart';
import 'package:broom_main_vscode/main.dart';
import 'package:broom_main_vscode/ui-components/favorite_button.dart';
import 'package:broom_main_vscode/user.dart';
import 'package:broom_main_vscode/user_provider.dart';
import 'package:broom_main_vscode/user_yourself.dart';
import 'package:flutter/material.dart';
import 'package:broom_main_vscode/ui-components/user_image.dart';
import 'package:broom_main_vscode/user_view.dart';
import 'package:go_router/go_router.dart';

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = UserProvider.of(context) as UserProvider;
    List<User> users = userProvider.users;
    int usersLength = users.length;

    List<Address> address = [];

    void addAddressForUser(ListUsers user) {
      if (user.address.isNotEmpty) {
        address.add(Address.fromJson(user.address[0]));
      } else {
        address.add(Address(
          state: '',
          city: '',
          neighborhood: '',
          addressType: '',
          street: '',
          addressCode: '',
          complement: '',
          number: -1,
          userId: null,
          id: null,
        ));
      }
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
      appBar: AppBar(
        title: Text('Listagem de usuários',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            color: Colors.white,
            onPressed: () {
              GoRouter.of(context).push('/account/view');
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            color: Colors.grey.shade800,
            onPressed: () {
              GoRouter.of(context).push('/account/settings');
            },
          ),
        ],
        elevation: 0,
        backgroundColor: Color(0xFF2ECC8F),
      ),
      body: FutureBuilder<List<ListUsers>>(
        future: fetchUsuarios(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar usuários'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum usuário encontrado'));
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
                      color: Color(0xFF2ECC8F),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      decorationColor: Color(0xFF2ECC8F),
                      decoration: TextDecoration.overline),
                  leading: UserImage(user: usuario),
                  title: Text(getListUserFullName(usuario)),
                  subtitle: Text(getListUserFormatedAddress(address[index])),
                  trailing: FavoriteButton(),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserView(usuario: usuario),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
