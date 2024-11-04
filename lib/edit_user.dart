import 'dart:io';
import 'package:broom_main_vscode/api/user.api.dart';
import 'package:broom_main_vscode/ui-components/user_image.dart';
import 'package:broom_main_vscode/user.dart';
import 'package:broom_main_vscode/user_yourself.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

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
  late String userActualImage;
  late bool? wantService;
  File? userImage;
  PlatformFile? _selectedFile;
  String _urlImagem = '';

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      setState(() {
        _selectedFile = result.files.first;
      });
    } else {
      print('Nenhum arquivo selecionado.');
    }
  }


  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.usersEdit.name);
    lastNameController = TextEditingController(text: widget.usersEdit.lastName);
    emailController = TextEditingController(text: widget.usersEdit.email);
    cellphoneNumberController = MaskedTextController(
        mask: '(00)0 0000-0000', text: widget.usersEdit.cellphoneNumber);
    descriptionController =
        TextEditingController(text: widget.usersEdit.description);
    wantService = widget.usersEdit.wantService ?? false;
    userActualImage = widget.usersEdit.userActualImage ?? '';
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
        cellphoneNumber:
            cellphoneNumberController.text.replaceAll(RegExp(r'[\(\)\s-]'), ''),
        description: descriptionController.text,
        wantService: wantService ?? false,
      );

      updateUser(updatedUser.toJson());

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => UserYourself()));
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
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Stack(children: [
                    GestureDetector(
                      onTap: () {
                        _pickImage();
                      },
                      child: _selectedFile != null
                          ? CircleAvatar(
                              radius: 50,
                              child: Container(
                                width: 80,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: MemoryImage(
                                            _selectedFile!.bytes!))),
                              ),
                            )
                          : CircleAvatar(
                              radius: 50,
                              child: UserImage(
                                  user: ListUsers(
                                      id: -1,
                                      address: [],
                                      firstName: '',
                                      lastName: '',
                                      profileId: -1,
                                      userImage: userActualImage ?? '',
                                      wantService: false,
                                      isFavorite: false)),
                            ),
                    ),
                    Positioned(
                      bottom: 5,
                      right: 5,
                      child: IconButton(
                          onPressed: () {
                            _pickImage();
                          },
                          icon: const Icon(
                            Icons.add_a_photo,
                            color: Color(0xFF2ECC8F),
                          )),
                    )
                  ]),
                  SizedBox(height: 10),
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
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
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
                      onPressed: () async {
                        saveUser();
                        sendImage(_selectedFile!);
                      },
                      child: Text('Salvar'),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.black),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
