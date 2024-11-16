import 'package:flutter/material.dart';

class ButtonText extends StatelessWidget {
  final String btnText;
  final Function function;
  final double? width;
  const ButtonText(
      {super.key, required this.btnText, required this.function, this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width ?? 250,
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
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ));
  }
}
