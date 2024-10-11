import 'package:broom_main_vscode/Login.dart';
import 'package:broom_main_vscode/api/user.api.dart';
import 'package:broom_main_vscode/user_provider.dart';
import 'package:broom_main_vscode/view/user_list.dart';
import 'package:flutter/material.dart';
import 'package:broom_main_vscode/signup.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

void main() async {
  bool isExpired = true;
  final String? token = await autentication.getToken();
  if(token!.isNotEmpty) isExpired = JwtDecoder.isExpired(token!);
  runApp(UserProvider(
    child: MaterialApp(
    debugShowCheckedModeBanner: false,
    localizationsDelegates: const [GlobalMaterialLocalizations.delegate],
    supportedLocales: const [Locale('pt')],
    home: isExpired ? HomePage() : UserList(),
    routes: {
      "/list": (_) => UserList(),
    },
  )));
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF2ECC8F),
        body: SafeArea(
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      "Bem vindo!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Broom é o mais novo aplicativo para contratação de diaristas na cidade de Campo Grande MS.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 15,
                      ),
                    )
                  ],
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 2,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/Logo_com_letra.png"))),
                ),
                Column(
                  children: <Widget>[
                    //Botao de Login
                    MaterialButton(
                      minWidth: double.infinity,
                      height: 60,
                      //color: Colors.black,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      },
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(50)),
                      child: Text(
                        "Login",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.black),
                      ),
                    ),
                    //Botao de SignUp
                    SizedBox(height: 20),
                    MaterialButton(
                      minWidth: double.infinity,
                      height: 60,
                      color: Colors.black,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpPage()));
                      },
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(50)),
                      child: Text(
                        "Sign up",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
