import 'dart:typed_data';

import 'package:broom_main_vscode/user.dart';
import 'package:flutter/material.dart';
import 'package:broom_main_vscode/api/user.api.dart';

class UserImage extends StatefulWidget {
  final ListUsers user;

  const UserImage({required this.user, super.key});

  @override
  State<UserImage> createState() => _UserImageState();
}

class _UserImageState extends State<UserImage> {
  Future<Uint8List?>? userImage;

  @override
  void initState() {
    userImage = fetchUserImage(widget.user.userImage);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: userImage,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(color: Color(0xFF2ECC8F));
        } else if (snapshot.hasError) {
          return const UserIcon();
        } else if (snapshot.hasData) {
          return Container(
              width: 80,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: MemoryImage(snapshot.data!),
                      fit: BoxFit.contain)));
        } else {
          return const UserIcon();
        }
      },
    );
  }
}

class UserIcon extends StatelessWidget {
  const UserIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      decoration: const BoxDecoration(shape: BoxShape.rectangle,),
      child: const CircleAvatar(child: Icon(Icons.person)),
    );
  }
}
