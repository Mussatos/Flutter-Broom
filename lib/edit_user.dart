import 'package:broom_main_vscode/api/user.api.dart';
import 'package:broom_main_vscode/user.dart';
import 'package:broom_main_vscode/utils/user_autentication.dart';
import 'package:flutter/material.dart';

class EditUserForm extends StatefulWidget {
  final EditUser usersEdit;

  EditUserForm({required this.usersEdit});

  @override
  _EditUserFormState createState() => _EditUserFormState();
}

class _EditUserFormState extends State<EditUserForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController cellphoneNumberController;
  late TextEditingController descriptionController;
  late bool? wantService;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.usersEdit.name);
    lastNameController = TextEditingController(text: widget.usersEdit.lastName);
    emailController = TextEditingController(text: widget.usersEdit.email);
    cellphoneNumberController =
        TextEditingController(text: widget.usersEdit.cellphoneNumber);
    descriptionController =
        TextEditingController(text: widget.usersEdit.description);
    wantService = widget.usersEdit.wantService ?? false;
  }

  @override
  void dispose() {
    nameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    cellphoneNumberController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void saveUser() {
    if (_formKey.currentState!.validate()) {
      EditUser updatedUser = EditUser(
        name: nameController.text,
        lastName: lastNameController.text,
        email: emailController.text,
        cellphoneNumber: cellphoneNumberController.text,
        description: descriptionController.text,
        wantService: wantService ?? false,
      );

      updateUser(updatedUser.toJson());

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edição de perfil',
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
      body: Container(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Nome',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe o nome';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Sobrenome',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe o sobrenome';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe o e-mail';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: cellphoneNumberController,
                  decoration: InputDecoration(
                    labelText: 'Número de celular',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe o número de celular';
                    }
                    return null;
                  },
                ),
                /*
                SizedBox(height: 10),
                TextFormField(
                  controller: ,
                  decoration: InputDecoration(
                    labelText: 'Imagem do usuário (URL)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe a imagem do usuário';
                    }
                    return null;
                  },
                ),
                */
                SizedBox(height: 10),
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Descrição',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe a descrição';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'Quer serviço?',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Switch(
                      activeColor: Color(0xFF2ECC8F),
                      value: wantService!,
                      onChanged: (bool? value) {
                        setState(() {
                          wantService = value ?? false;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: saveUser,
                    child: Text('Salvar'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
