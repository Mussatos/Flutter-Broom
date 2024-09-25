import 'dart:typed_data';

import 'package:broom_main_vscode/address_form.dart';
import 'package:broom_main_vscode/api/user.api.dart';
import 'package:broom_main_vscode/edit_address.dart';
import 'package:broom_main_vscode/user.dart';
import 'package:broom_main_vscode/user_provider.dart';
import 'package:broom_main_vscode/user_yourself.dart';
import 'package:flutter/material.dart';
import 'package:broom_main_vscode/ui-components/user_image.dart';
import 'package:broom_main_vscode/user_view.dart';

class AddressList extends StatelessWidget {
  const AddressList({super.key});

  @override
  Widget build(BuildContext context) {
    final String token =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InJhZmFAZ21haWwuY29tIiwiaWQiOjQsImlhdCI6MTcyNjQ1NzU5MiwiZXhwIjoxNzI2NDcxOTkyLCJpc3MiOiJsb2dpbiIsInN1YiI6IjQifQ.aJN3DFH5pC1hjHkVMjgBM25L3O9ofAMbFabPZ2twz24';

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
        ));
      }
    }

    String getListUserFormatedAddress(Address userAddress) {
      if (userAddress.state == '' ||
          userAddress.neighborhood == '' ||
          userAddress.city == '') return '';

      return '${userAddress.neighborhood} - ${userAddress.city!}, ${userAddress.state!}';
    }

    String getListAddressMore(Address userAddress) {
      if (userAddress.street == '' || userAddress.number == '') return '';

      return '${userAddress.street}, ${userAddress.number}';
    }

    String getListUserFullName(ListUsers user) {
      return '${user.firstName} ${user.lastName}';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Address List'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            color: Colors.white,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddressForm()));
            },
          ),
        ],
        elevation: 0,
        backgroundColor: Color(0xFF2ECC8F),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: FutureBuilder<List<Address>>(
        future: fetchAddress(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar endereços'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum endereço encontrado'));
          } else {
            List<Address> address = snapshot.data!;
            return ListView.builder(
              itemCount: address.length,
              itemBuilder: (context, index) {
                Address userAddress = address[index];
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
                  title: Text(getListUserFormatedAddress(userAddress)),
                  subtitle: Text(getListAddressMore(address[index])),
                  trailing: PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert),
                    onSelected: (value) {
                      if (value == 'edit') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditAddress()),
                        );
                      } else if (value == 'delete') {
                        _showDeleteConfirmationDialog(context);
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem(
                          value: 'edit',
                          child: Text('Editar'),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text('Deletar'),
                        ),
                      ];
                    },
                  ),
                  onTap: () {},
                );
              },
            );
          }
        },
      ),
    );
  }
}

void _showDeleteConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirmação'),
        content: Text('Tem certeza de que deseja excluir este endereço?'),
        actions: <Widget>[
          TextButton(
            child: Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Confirmar'),
            onPressed: () {
              Navigator.of(context)
                  .pop();
            },
          ),
        ],
      );
    },
  );
}
