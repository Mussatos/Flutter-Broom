import 'package:flutter/material.dart';

class Modal extends StatelessWidget {
  String? title = '';
  String? message = '';
  Function? click = () => 'default';
  bool showOneButton = false;
  String? mainButtonTitle = '';

  Modal(
      {super.key,
      this.title,
      this.message,
      this.click,
      this.mainButtonTitle,
      required this.showOneButton});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title!,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        textAlign: TextAlign.center,
      ),
      content: Text(
        message!,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        textAlign: TextAlign.center,
        softWrap: true,
        strutStyle: StrutStyle(
          fontFamily: 'Roboto',
          fontSize: 14,
          height: 1.5,
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if (!showOneButton!)
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Não',
                  style: TextStyle(color: Colors.white),
                ),
                style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Color(0xFF2ECC8F))),
              ),
            ElevatedButton(
                onPressed: () {
                  click!();
                },
                child: Text(
                  mainButtonTitle ?? 'Sim',
                  style: TextStyle(color: Colors.white),
                ),
                style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Color(0xFF2ECC8F))))
          ],
        ),
      ],
    );
  }
}
