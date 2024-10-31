import 'package:flutter/material.dart';

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({super.key});

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
      bool isFavoriteList = false;

  Future<void> isLiked() async {
      setState(() {
        isFavoriteList = !isFavoriteList;
      });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.favorite,
        color: isFavoriteList ? Colors.red : Colors.grey,
      ),
      onPressed: (){
        isLiked();
      },
    );
  }
}
