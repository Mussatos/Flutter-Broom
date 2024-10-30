import 'package:broom_main_vscode/Login.dart';
import 'package:broom_main_vscode/api/user.api.dart';
import 'package:broom_main_vscode/resetPassword.dart';
import 'package:broom_main_vscode/user_form.dart';
import 'package:broom_main_vscode/user_provider.dart';
import 'package:broom_main_vscode/view/user_list.dart';
import 'package:flutter/material.dart';
import 'package:broom_main_vscode/signup.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:go_router/go_router.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:broom_main_vscode/utils/routes.dart';
import 'package:splash_view/source/presentation/pages/pages.dart';
import 'package:splash_view/splash_view.dart';

void main() async {
  String stripePublishableKey =
      "pk_live_51Plexm08Kz6lXWDqdCco7V1icaeMZTQBZJEdDt1jeZLOB38iG15vgJOSlvFb8YTF5Q2DQLzl7BqUx57WDJb9Tr2100ydrJ3YUw";

  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = stripePublishableKey;
  Stripe.merchantIdentifier = 'any string works';
  await Stripe.instance.applySettings();

  bool isExpired = true;

  final String? token = await autentication.getToken();
  if (token != null && token.isNotEmpty)
    isExpired = JwtDecoder.isExpired(token);

  final String initialLocation = isExpired ? '/' : '/List';

  runApp(UserProvider(
      child: MaterialApp.router(
    debugShowCheckedModeBanner: false,
    localizationsDelegates: const [GlobalMaterialLocalizations.delegate],
    supportedLocales: const [Locale('pt')],
    routerConfig: createRouter(initialLocation),
  )));
}

class HomePage extends StatefulWidget {
  bool? loggedOut;
  HomePage({this.loggedOut});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    if (widget.loggedOut != null) {
      autentication.setToken('');
    }
  }


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
                    WebViewWidget(controller: controller),
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
                      onPressed: () => GoRouter.of(context).push('/login'),
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
                      onPressed: () => GoRouter.of(context).push('/register'),
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
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
