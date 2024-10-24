import 'package:broom_main_vscode/field_form.dart';
import 'package:broom_main_vscode/login.dart';
import 'package:broom_main_vscode/user.dart';
import 'package:broom_main_vscode/user_provider.dart';
import 'package:broom_main_vscode/view/user_list.dart';
import 'package:flutter/material.dart';
import 'package:broom_main_vscode/utils/validators.dart';
import 'package:broom_main_vscode/api/user.api.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:go_router/go_router.dart';

class UserForm extends StatefulWidget {
  const UserForm({super.key});

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerSobrenome = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  MaskedTextController controllerCpf =
      MaskedTextController(mask: '000.000.000-00');
  TextEditingController controllerDate = TextEditingController();
  List<int> profileType = [1, 2];
  int userProfileSelected = 1;
  DateTime picked = new DateTime(0);
  bool isValidEmail = true;
  String gender = '';
  bool isValidName = true;

  String? cpfError;
  String? emailError;
  String? nameError;
  String? lastNameError;
  String? passwordError;
  String? dateError;
  String? genderError;

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = UserProvider.of(context) as UserProvider;

    bool validCredentials() {
      setState(() {
        emailError =
            validEmail(controllerEmail.text) && controllerEmail.text.isNotEmpty
                ? null
                : 'Preencha o campo Email corretamente';
        nameError = validName(controllerName.text)
            ? null
            : 'Preencha o campo Nome corretamente';
        lastNameError = validName(controllerSobrenome.text)
            ? null
            : 'Preencha o campo Sobrenome corretamente';
        cpfError = controllerCpf.text.isNotEmpty &&
                controllerCpf.text.length == 14 &&
                validCpf(controllerCpf.text.replaceAll(RegExp(r'[\.-]'), ''))
            ? null
            : 'Preencha o campo CPF corretamente';
        passwordError = controllerPassword.text.isNotEmpty
            ? null
            : 'Preencha o campo senha corretamente';
        dateError = controllerDate.text.isNotEmpty
            ? null
            : 'Preencha o campo Data de Nascimento corretamente';
        genderError =
            gender.isNotEmpty ? null : 'Preencha o campo genero corretamente';
      });

      return emailError == null &&
          nameError == null &&
          lastNameError == null &&
          cpfError == null &&
          passwordError == null &&
          dateError == null &&
          genderError == null;
    }

    void save(context) async {
      if (!validCredentials()) {
        return;
      }

      User user = User(
          name: controllerName.text,
          sobrenome: controllerSobrenome.text,
          email: controllerEmail.text,
          password: controllerPassword.text,
          cpf: controllerCpf.text.replaceAll(RegExp(r'[\.-]'), ''),
          data: picked,
          profileId: userProfileSelected,
          description: '',
          cellphone_number: '',
          user_image: '',
          wantService: true,
          gender: gender);

      userProvider.users.add(user);

      if (await register(user.toJson())) {
        GoRouter.of(context).push('/List');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Falha ao registrar usuário.'),
          ),
        );
      }
    }

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Selecione o seu perfil: ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 120,
                  child: DropdownButton<int>(
                      value: userProfileSelected,
                      underline: Container(
                        height: 1,
                        color: Colors.white,
                      ),
                      dropdownColor: Colors.black,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      isExpanded: true,
                      iconSize: 35,
                      iconEnabledColor: Colors.white,
                      items:
                          profileType.map<DropdownMenuItem<int>>((int value) {
                        return DropdownMenuItem<int>(
                            value: value,
                            child: Text(value == 1 ? 'Cliente' : 'Diarista'));
                      }).toList(),
                      onChanged: (int? value) {
                        setState(() {
                          userProfileSelected = value!;
                        });
                      }),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              color: Color(0xFF2ECC8F),
              padding: EdgeInsets.all(5),
              child: SizedBox(
                width: 350,
                child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Nome',
                      errorText: nameError,
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.transparent,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    controller: controllerName,
                    onChanged: (value) {
                      setState(() {
                        isValidName = validName(controllerName.text);
                      });
                    }),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              color: Color(0xFF2ECC8F),
              padding: EdgeInsets.all(5),
              child: SizedBox(
                width: 350,
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Sobrenome',
                    errorText: lastNameError,
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.transparent,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  controller: controllerSobrenome,
                  onChanged: (value) {
                    setState(() {
                      isValidName = validName(controllerSobrenome.text);
                    });
                  },
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              color: Color(0xFF2ECC8F),
              padding: EdgeInsets.all(5),
              child: SizedBox(
                width: 350,
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    errorText: emailError,
                    labelStyle:
                        TextStyle(color: Colors.white), // Placeholder branco
                    filled: true,
                    fillColor: Colors.transparent,
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.white), // Borda branca
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  obscureText: false,
                  controller: controllerEmail,
                  onChanged: (value) {
                    setState(() {
                      isValidEmail = validEmail(controllerEmail.text);
                    });
                  },
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              color: Color(0xFF2ECC8F),
              padding: EdgeInsets.all(5),
              child: SizedBox(
                width: 350,
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    errorText: passwordError,
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.transparent,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  obscureText: true,
                  controller: controllerPassword,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              color: Color(0xFF2ECC8F),
              padding: EdgeInsets.all(5),
              child: SizedBox(
                width: 350,
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'CPF',
                    errorText: cpfError,
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.transparent,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  obscureText: false,
                  controller: controllerCpf,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              color: Color(0xFF2ECC8F),
              padding: EdgeInsets.all(5),
              child: SizedBox(
                width: 350,
                child: TextField(
                  controller: controllerDate,
                  decoration: InputDecoration(
                    labelText: 'Data de Nascimento',
                    errorText: dateError,
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.transparent,
                    prefixIcon: Icon(Icons.calendar_today, color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  readOnly: true,
                  onTap: () {
                    _selectDate();
                  },
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 350,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selecione seu gênero:',
                    style: TextStyle(color: Colors.white),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Radio(
                            activeColor: Colors.white,
                            value: 'M',
                            groupValue: gender,
                            onChanged: (value) {
                              setState(() {
                                gender = value!;
                              });
                            },
                          ),
                          Text(
                            'Masculino',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      SizedBox(width: 20),
                      Row(
                        children: [
                          Radio(
                            activeColor: Colors.white,
                            value: 'F',
                            groupValue: gender,
                            onChanged: (value) {
                              setState(() {
                                gender = value!;
                              });
                            },
                          ),
                          Text(
                            'Feminino',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      SizedBox(width: 20),
                      Row(
                        children: [
                          Radio(
                            activeColor: Colors.white,
                            value: 'O',
                            groupValue: gender,
                            onChanged: (value) {
                              setState(() {
                                gender = value!;
                              });
                            },
                          ),
                          Text(
                            'Outro',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    genderError ?? '',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 350,
              height: 50,
              child: TextButton(
                onPressed: () => save(context),
                child: Text('Salvar'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: DateTime(2000),
        firstDate: DateTime(1950),
        lastDate: DateTime(2500));

    if (_picked != null) {
      setState(() {
        print(_picked);
        List<String> dateToString = _picked.toString().split(" ")[0].split("-");
        controllerDate.text =
            '${dateToString[2]}/${dateToString[1]}/${dateToString[0]}';
        picked = _picked;
      });
    }
  }
}
