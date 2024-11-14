import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ButtonIcon extends StatelessWidget {
  final String btnText;
  final IconData btnIcon;
  final Function function;
  const ButtonIcon({super.key, required this.btnText, required this.btnIcon, required this.function});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 250,
        child: ElevatedButton(
          onPressed: () {
            function();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2ECC8F),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                btnText,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(
                width: 10,
              ),
              Icon(
                color: Colors.white,
                btnIcon,
              ),
            ],
          ),
        ));
  }
}
