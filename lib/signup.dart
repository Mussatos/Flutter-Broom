import 'package:broom_main_vscode/login.dart';
import 'package:broom_main_vscode/user_form.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
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
        body: UserForm(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 40),
              height: MediaQuery.of(context).size.height - 50,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        "Sign up",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 1,
                      ),
                      Text(
                        "Create your account, It's Free",
                        style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      inputFile(label: "Username"),
                      inputFile(label: "Email"),
                      inputFile(label: "Passowrd", obscureText: true),
                      inputFile(label: "Confirm Password", obscureText: true)
                    ],
                  ),
                  Container(
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
                      onPressed: () {},
                      color: Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        "Sign up",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Already have an account?"),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  LoginPage(), // Altere LoginPage para sua pÃ¡gina de login
                            ),
                          );
                        },
                        child: Text(
                          " Login",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.black, // Altere para a cor desejada
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
