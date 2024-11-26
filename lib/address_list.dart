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
import 'package:go_router/go_router.dart';

class AddressList extends StatefulWidget {
  const AddressList({super.key});

  @override
  State<AddressList> createState() => _AddressListState();
}

class _AddressListState extends State<AddressList> {
  Future<List<Address>>? addresses;

  @override
  void initState() {
    addresses = fetchAddress();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Address> address = [];

    removeAddressAt(int index) {
      setState(() {
        address.removeAt(index);
      });
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

    String getListAddressMore(Address userAddress) {
      if (userAddress.street == '' || userAddress.number == '') return '';

      return '${userAddress.street}, ${userAddress.number}';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Seus endereços',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            color: Colors.white,
            onPressed: () async {
              final result = await GoRouter.of(context).push("/address/form");

              if (result != null && result is Address) {
                setState(() {
                  address.add(result);
                });
              }
            },
          ),
        ],
        elevation: 0,
        backgroundColor: Color(0xFF2ECC8F),
        leading: IconButton(
          onPressed: () {
            GoRouter.of(context).push('/account/view');
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: FutureBuilder<List<Address>>(
        future: addresses,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar endereços'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum endereço encontrado'));
          } else {
            address = snapshot.data!;
            return ListView.builder(
              itemCount: address.length,
              itemBuilder: (context, index) {
                Address userAddress = address[index];
                return Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      titleTextStyle: const TextStyle(
                          color: Colors.black87,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                      subtitleTextStyle: const TextStyle(
                          color: Color(0xFF2ECC8F),
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                      title: Text(getListUserFormatedAddress(userAddress)),
                      subtitle: Text(getListAddressMore(address[index])),
                      trailing: PopupMenuButton<String>(
                        icon: Icon(Icons.more_vert),
                        onSelected: (value) async {
                          if (value == 'edit') {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditAddressForm(address: userAddress),
                              ),
                            );

                            if (result != null && result is Address) {
                              setState(() {
                                address[index] = result;
                              });
                            }
                          } else if (value == 'delete') {
                            _showDeleteConfirmationDialog(context,
                                userAddress.id, () => removeAddressAt(index));
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
                    ));
              },
            );
          }
        },
      ),
    );
  }
}

void _showDeleteConfirmationDialog(
    BuildContext context, int? id, Function removeAddressAt) {
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
            onPressed: () async {
              await deleteAddress(id);
              removeAddressAt();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
