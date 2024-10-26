import 'package:broom_main_vscode/api/user.api.dart';
import 'package:broom_main_vscode/resetPassword.dart';
import 'package:broom_main_vscode/signup.dart';
import 'package:broom_main_vscode/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ConfirmEmail extends StatefulWidget {
  const ConfirmEmail({super.key});

  @override
  State<ConfirmEmail> createState() => _ConfirmEmailState();
}

TextEditingController? emailController = TextEditingController(text: '');

//implementar o valid email aqui < >
/*
  Navigator.push(
    context,
      MaterialPageRoute(
        builder: (context) => ResetPasswordScreen()));*/

bool validCredentials() {
  if (emailController!.text.isNotEmpty) {
    return validEmail(emailController!.text);
  }
  return false;
}

class _ConfirmEmailState extends State<ConfirmEmail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2ECC8F),
      appBar: AppBar(
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
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 100,
          width: double.infinity,
          child: Column(
            children: <Widget>[
              Container(
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/Logo_com_letra.png"),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  Text(
                    "A limpeza vai até você!",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Recupere sua conta!",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: <Widget>[
                        inputFile(label: "Email", controller: emailController),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Container(
                      padding: EdgeInsets.only(top: 3, left: 3),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border(
                            bottom: BorderSide(color: Colors.black),
                            top: BorderSide(color: Colors.black),
                            left: BorderSide(color: Colors.black),
                            right: BorderSide(color: Colors.black),
                          )),
                      child: MaterialButton(
                          minWidth: double.infinity,
                          height: 60,
                          onPressed: () {
                            if (validCredentials()) {
                              (context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Preencha o campo e-mail corretamente.',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black),
                                    ),
                                    backgroundColor: Colors.white,
                                  ),
                                  snackBarAnimationStyle: AnimationStyle(
                                      duration:
                                          const Duration(milliseconds: 500)));
                            }
                          },
                          color: Colors.black,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            "Enviar",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Ainda não possui uma conta?"),
                      GestureDetector(
                        child: Text(
                          " Sign up",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                        onTap: () => GoRouter.of(context).push('/register'),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget inputFile(
    {label, TextEditingController? controller, obscureText = false}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label,
        style: TextStyle(
            fontSize: 15, fontWeight: FontWeight.w400, color: Colors.white),
      ),
      SizedBox(
        height: 5,
      ),
      TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            border:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      SizedBox(
        height: 10,
      )
    ],
  );
}
