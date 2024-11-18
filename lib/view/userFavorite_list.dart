import 'package:broom_main_vscode/api/user.api.dart';
import 'package:broom_main_vscode/ui-components/favorite_button.dart';
import 'package:broom_main_vscode/ui-components/user_image.dart';
import 'package:broom_main_vscode/user.dart';
import 'package:broom_main_vscode/user_view.dart';
import 'package:flutter/material.dart';

class UserfavoriteList extends StatefulWidget {
  UserfavoriteList({super.key});

  @override
  State<UserfavoriteList> createState() => _UserfavoriteListState();
}

class _UserfavoriteListState extends State<UserfavoriteList> {
  List<Address> address = [];
  Future<List<ListUsers>>? favorites;

  @override
  void initState() {
    favorites = getUserFavorite();
    super.initState();
  }

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
    print(usuario.isFavorite);
    if (usuario.isFavorite) {
      await setUserFavorite(usuario.id);
      return;
    }
    await deleteUserFavorite(usuario.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listagem de favoritos',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
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
        elevation: 0,
        backgroundColor: Color(0xFF2ECC8F),
      ),
      body: FutureBuilder<List<ListUsers>>(
        future: favorites,
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
                );
              },
            );
          }
        },
      ),
    );
  }
}
