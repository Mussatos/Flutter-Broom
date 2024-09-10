import 'package:broom_main_vscode/user.dart';
import 'package:flutter/material.dart';
import 'package:broom_main_vscode/api/user.api.dart';

class UserImage extends StatelessWidget {
  final String token;
  final ListUsers user;

  const UserImage({required this.user, required this.token, super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchUserImage(user.userImage, token),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const CircleAvatar(child: Icon(Icons.person));
        } else if (snapshot.hasData) {
          return Container(
            width: 80,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: MemoryImage(snapshot.data!),
                      fit: BoxFit.contain)));
        } else {
          return const CircleAvatar(child: Icon(Icons.person));
        }
      },
    );
  }
}
