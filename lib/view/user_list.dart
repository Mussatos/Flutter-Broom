import 'dart:typed_data';

import 'package:broom_main_vscode/address_list.dart';
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
  Future<List<ListUsers>>? handleUsuarios;
  bool hasNoAddress = false;

  @override
  void initState() {
    handleUsuarios = fetchUsuarios();
    super.initState();
    _checkUserAddresses();
  }

 Future<void> _checkUserAddresses() async {
    try {
      final addresses = await fetchAddress();
      setState(() {
        hasNoAddress = addresses.isEmpty; 
      });
    } catch (error) {
      print('Erro ao buscar endereços: $error');
    }
  }

   void _showAddressesDialog() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Aviso',
               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            content: const Text(
                'Você ainda não possui nenhum endereço cadastrado. Deseja adicionar um agora?', 
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                        'Cancelar',
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 16),
                        ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text(
                  'Adicionar endereço',
                   style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AddressList(),
                    ),
                  );
                },
              ),
            ],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
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

    Future<void> changeFavorite(ListUsers usuario) async {
      usuario.isFavorite = !usuario.isFavorite;

      if (usuario.isFavorite) {
        await setUserFavorite(usuario.id);
        return;
      }
      await deleteUserFavorite(usuario.id);
    }

    return Scaffold(
      backgroundColor: Color(0xFF2ECC8F),
      appBar: AppBar(
        title: Text('Listagem de usuários',
            style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.w600)),
        automaticallyImplyLeading: false,
        actions: [
           Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications),
                color: Colors.black,
                onPressed: () {
                  if (hasNoAddress) {
                    _showAddressesDialog();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Nenhuma notificação no momento.'),
                      ),
                    );
                  }
                },
              ),
              if (hasNoAddress)
              Positioned(
                right: 12,
                top: 12,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.person),
            color: Colors.black,
            onPressed: () {
              GoRouter.of(context).push('/account/view');
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            color: Colors.black,
            onPressed: () {
              GoRouter.of(context).push('/account/settings');
            },
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: FutureBuilder<List<ListUsers>>(
        future: handleUsuarios,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Color(0xFF2ECC8F)));
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar usuários'));
          } else {
            List<ListUsers> usuarios = snapshot.data!;
            return ListView.builder(
              itemCount: usuarios.length,
              itemBuilder: (context, index) {
                ListUsers usuario = usuarios[index];
                addAddressForUser(usuario);
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Colors.white,
                  child: ListTile(
                    titleTextStyle: const TextStyle(
                        color: Colors.black87,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                    subtitleTextStyle: const TextStyle(
                      color: Color(0xFF2ECC8F),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    leading: UserImage(user: usuario),
                    title: Text(getListUserFullName(usuario)),
                    subtitle: Text(getListUserFormatedAddress(address[index])),
                    trailing: FavoriteButton(
                      isFavorite: usuario.isFavorite,
                      callback: () => changeFavorite(usuario),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserView(usuario: usuario),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
