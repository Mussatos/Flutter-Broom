import 'package:broom_main_vscode/field_form.dart';
import 'package:broom_main_vscode/user.dart';
import 'package:broom_main_vscode/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:broom_main_vscode/utils/validators.dart';
import 'package:broom_main_vscode/api/user.api.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class UserForm extends StatefulWidget {
  const UserForm({super.key, required List<Container> children});

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerSobrenome = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  TextEditingController controllerCpf = TextEditingController();
  TextEditingController controllerDate = TextEditingController();
  List<int> profileType = [1, 2];
  int userProfileSelected = 1;
  DateTime picked = new DateTime(0);
  bool isValidEmail = true;
  String gender = '';

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = UserProvider.of(context) as UserProvider;

    void save() {
      User user = User(
          name: controllerName.text,
          sobrenome: controllerSobrenome.text,
          email: controllerEmail.text,
          password: controllerPassword.text,
          cpf: controllerCpf.text,
          data: picked,
          profileId: userProfileSelected,
          description: '',
          cellphone_number: '',
          user_image: '',
          wantService: null,
          gender: gender);

      int usersLength = userProvider.users.length;

      userProvider.users.insert(usersLength, user);

      if (isValidEmail && controllerEmail.text.isNotEmpty) {
        register(user.toJson());
        Navigator.popAndPushNamed(context, "/list");
      } else {
        Error();
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
                  ),
                  style: TextStyle(
                    color: Colors.white,
                  ),  
                  controller: controllerName,
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
                    labelText: 'Sobrenome',
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
                  ), 
                  style: TextStyle(
                    color: Colors.white,
                  ), 
                  controller: controllerSobrenome,
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
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.transparent,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
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
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.transparent,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
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
                      SizedBox(width: 20), // Espaço entre as opções
                      Row(
                        children: [
                          Radio(
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
                      SizedBox(width: 20), // Espaço entre as opções
                      Row(
                        children: [
                          Radio(
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
                onPressed: () => save(),
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
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime(2500));

    if (_picked != null) {
      setState(() {
        controllerDate.text = _picked.toString().split(" ")[0];
        picked = _picked;
      });
    }
  }
}
