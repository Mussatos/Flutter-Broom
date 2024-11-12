import 'package:broom_main_vscode/user.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class FavoriteButton extends StatefulWidget {
  bool isFavorite;
  Function callback;

  FavoriteButton({super.key, required this.isFavorite, required this.callback});

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton>
    with TickerProviderStateMixin {
  // late final AnimationController _controller;
  bool isButtonEnabled = true;

  // @override
  // void initState() {
  //   super.initState();

  //   _controller = AnimationController(vsync: this);
  // }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> isLiked() async {
    if (!isButtonEnabled) return;

    setState(() {
      widget.isFavorite = !widget.isFavorite;
      isButtonEnabled = false;
    });

    widget.callback();

    await Future.delayed(Duration(milliseconds: 100));
    setState(() {
      isButtonEnabled = true;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.favorite,
        color: widget.isFavorite ? Colors.red : Colors.grey,
      ),
      onPressed: isButtonEnabled ? isLiked : null,
    );
  }
}
