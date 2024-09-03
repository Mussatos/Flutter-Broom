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
  bool isValidPassword = true;

  @override
  Widget build(BuildContext context) {
    void save() {
      UserProvider userProvider = UserProvider.of(context) as UserProvider;

      User user = User(
          name: controllerName.text,
          sobrenome: controllerSobrenome.text,
          email: controllerEmail.text,
          password: controllerPassword.text,
          cpf: controllerCpf.text,
          data: picked,
          profileId: userProfileSelected,
          basic_description: '',
          cellphone_number: '',
          user_image: '');

      int usersLength = userProvider.users.length;

      userProvider.users.insert(usersLength, user);

      if (isValidEmail && isValidPassword) {
        register(user.toJson());
      } else {
        Error();
      }

      Navigator.popAndPushNamed(context, "/list");
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: 120,
            child: DropdownButton<int>(
                value: userProfileSelected,
                underline: Container(
                  height: 1,
                  color: Colors.white,
                ),
                dropdownColor: Colors.white,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                isExpanded: true,
                iconSize: 35,
                iconEnabledColor: Colors.white,
                items: profileType.map<DropdownMenuItem<int>>((int value) {
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
          SizedBox(
            width: 350,
            child: FieldForm(
                label: 'Name', isPassoword: false, controller: controllerName),
          ),
          SizedBox(
            width: 350,
            child: FieldForm(
                label: 'Sobrenome',
                isPassoword: false,
                controller: controllerSobrenome),
          ),
          SizedBox(
            width: 350,
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                filled: true,
                fillColor: Colors.white,
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
          SizedBox(
            width: 350,
            child: TextField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  filled: true,
                  fillColor: Colors.white,
                ),
                obscureText: true,
                controller: controllerPassword,
                onChanged: (value) {
                  setState(() {
                    isValidPassword = validPassword(controllerPassword.text);
                  });
                }),
          ),
          SizedBox(
            width: 350,
            child: FieldForm(
                label: 'CPF', isPassoword: false, controller: controllerCpf),
          ),
          SizedBox(
            width: 350,
            child: TextField(
              controller: controllerDate,
              decoration: InputDecoration(
                labelText: 'Date',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () {
                _selectDate();
              },
            ),
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
          )
        ],
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
