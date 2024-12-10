import 'package:broom_main_vscode/confirmEmail.dart';
import 'package:broom_main_vscode/resetPassword.dart';
import 'package:broom_main_vscode/view/user_list.dart';
import 'package:flutter/material.dart';
import 'package:broom_main_vscode/api/user.api.dart';
import 'package:broom_main_vscode/utils/validators.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  TextEditingController? emailController = TextEditingController(text: '');
  TextEditingController? passwordController = TextEditingController(text: '');

  void userLogged(context) async {
    if (await login(emailController!.text, passwordController!.text)) {
      emailController!.dispose();
      passwordController!.dispose();

      GoRouter.of(context).push('/List');
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Credenciais inválidas.',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ),
        snackBarAnimationStyle:
            AnimationStyle(duration: const Duration(milliseconds: 500)));
  }

  bool validCredentials() {
    if (emailController!.text.isNotEmpty && passwordController!.text.isNotEmpty) {
      return validEmail(emailController!.text);
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                        "Faça o seu login",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: <Widget>[
                        inputFile(label: "Email", controller: emailController),
                        inputFile(
                            label: "Senha",
                            controller: passwordController,
                            obscureText: true)
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          child: Text(
                            " Esqueçeu a senha?",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          onTap: () {
                            GoRouter.of(context).push('/forget-password');
                          },
                        ),
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
                          borderRadius: BorderRadius.circular(50)),
                      child: MaterialButton(
                          minWidth: double.infinity,
                          height: 60,
                          onPressed: () {
                            if (validCredentials()) {
                              userLogged(context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Preencha os campos de e-mail e senha corretamente.',
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
                            "Entrar",
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
                      Text("Ainda não possui uma conta?",
                          style:
                              TextStyle(color: Colors.black)),
                      GestureDetector(
                        child: Text(
                          " Cadastre-se",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.black, 
                          ),
                        ),
                        onTap: () {
                          GoRouter.of(context).push('/register');
                        },
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
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.black),
      ),
      SizedBox(
        height: 5,
      ),
      TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            border:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      SizedBox(
        height: 10,
      )
    ],
  );
}
