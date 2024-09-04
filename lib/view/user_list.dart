import 'package:broom_main_vscode/user.dart';
import 'package:broom_main_vscode/user_provider.dart';
import 'package:flutter/material.dart';

class UserList extends StatelessWidget {
  const UserList({super.key});

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = UserProvider.of(context) as UserProvider;

    List<User> users = userProvider.users;

    int usersLength = users.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: ListView.builder(
        itemCount: usersLength,
        itemBuilder: (BuildContext contextBuilder, indexBuilder) => Container(
          child: ListTile(
              title: Text(users[indexBuilder].name),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      onPressed: () {
                        userProvider.userSelect = users[indexBuilder];
                        userProvider.indexUser = indexBuilder;
                        Navigator.popAndPushNamed(context, "/view");
                      },
                      icon: Icon(Icons.visibility, color: Colors.blue)),
                ],
              )),
          decoration:
              BoxDecoration(border: Border(bottom: BorderSide(width: 0.4))),
        ),
      ),
    );
  }
}
