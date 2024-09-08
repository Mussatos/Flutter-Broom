import 'package:broom_main_vscode/api/user.api.dart';
import 'package:broom_main_vscode/user.dart';
import 'package:broom_main_vscode/user_provider.dart';
import 'package:flutter/material.dart';

class UserList extends StatelessWidget {
  const UserList({super.key});

  @override
  Widget build(BuildContext context) {
    final String token =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InZpbmljaXVzc2FudGFuYS5hemFtYnVqNEBnbWFpbC5jb20iLCJpZCI6MSwiaWF0IjoxNzI1ODIzNTgzLCJleHAiOjE3MjU4Mzc5ODMsImlzcyI6InJlZ2lzdGVyIiwic3ViIjoiMSJ9.je2kcfqb9_TeRB--7THiBE6fqWfPOrppyqJyrLo81s0';
    UserProvider userProvider = UserProvider.of(context) as UserProvider;

    List<User> users = userProvider.users;

    int usersLength = users.length;

    return Scaffold(
      backgroundColor: Color(0xFF2ECC8F),
      appBar: AppBar(
        title: Text('User List'),
        elevation: 0,
        backgroundColor: Color(0xFF2ECC8F),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: FutureBuilder<List<ListUsers>>(
        future: fetchUsuarios(token),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print(snapshot.data);
            print(snapshot.hasError);
            return Center(child: Text('Erro ao carregar usuários'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum usuário encontrado'));
          } else {
            List<ListUsers> usuarios = snapshot.data!;
            return ListView.builder(
              itemCount: usuarios.length,
              itemBuilder: (context, index) {
                ListUsers usuario = usuarios[index];
                return ListTile(
                  leading: CircleAvatar(child: Text(usuario.firstName)),
                  title: Text(usuario.firstName),
                  subtitle: Text(usuario.lastName),
                );
              },
            );
          }
        },
      ),
    );
    /*
      ListView.builder(
        itemCount: usersLength,
        itemBuilder: (BuildContext contextBuilder, indexBuilder) => Container(
          child: ListTile(
              title: Text(users[indexBuilder].name),
              subtitle: Text(users[indexBuilder].sobrenome),
              leading: Image.asset("assets/Logo_so_o_balde.png"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      onPressed: () {
                        //print(users[indexBuilder].profileId);
                        Navigator.popAndPushNamed(context, "/view");
                      },
                      icon: Icon(Icons.visibility, color: Colors.blue)),
                ],
              )),
          decoration:
              BoxDecoration(border: Border(bottom: BorderSide(width: 0.4))),
        ),
      ),*/
  }
}
