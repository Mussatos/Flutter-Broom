import 'package:broom_main_vscode/field_form.dart';
import 'package:broom_main_vscode/user.dart';
import 'package:broom_main_vscode/user_provider.dart';
import 'package:flutter/material.dart';

class UserForm extends StatefulWidget {
  const UserForm({super.key, required List<Container> children});

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void save() {
      UserProvider userProvider = UserProvider.of(context) as UserProvider;

      User user = User(
          name: controllerName.text,
          email: controllerEmail.text,
          password: controllerPassword.text);

      userProvider.users.insert(0, user);
    }

    return Center(
      child: Column(
        children: [
          FieldForm(label: 'Name', isPassoword: false, controller: controllerName),
          FieldForm(label: 'Email', isPassoword: false, controller: controllerEmail),
          FieldForm(label: 'Password', isPassoword: true, controller: controllerPassword),
          
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: save,
              child: Text('Salvar'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
