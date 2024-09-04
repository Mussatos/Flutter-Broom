import 'package:broom_main_vscode/field_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class UserView extends StatelessWidget {
  UserView({super.key});

  String title = "Show User";

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
              onChanged: (int? value) {},
            ),
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
              ),
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
            ),
          ),
          SizedBox(
            width: 350,
            height: 50,
            child: TextButton(
              onPressed: () {
                Navigator.popAndPushNamed(context, "/create");
              },
              child: Text('Edit'),
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
}

