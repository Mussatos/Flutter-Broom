import 'package:broom_main_vscode/address_form.dart';
import 'package:broom_main_vscode/address_list.dart';
import 'package:broom_main_vscode/api/user.api.dart';
import 'package:broom_main_vscode/confirmEmail.dart';
import 'package:broom_main_vscode/edit_address.dart';
import 'package:broom_main_vscode/user.dart';
import 'package:broom_main_vscode/user_yourself.dart';
import 'package:broom_main_vscode/view/account_settings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:broom_main_vscode/Login.dart';
import 'package:broom_main_vscode/signup.dart';
import 'package:broom_main_vscode/resetPassword.dart';
import 'package:broom_main_vscode/view/user_list.dart';
import 'package:broom_main_vscode/main.dart';
import 'package:jwt_decoder/jwt_decoder.dart'; // HomePage()

GoRouter createRouter(String initialLocation) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => HomePage(),
      ),
      GoRoute(
        path: '/logout',
        builder: (context, state) => HomePage(
          loggedOut: true,
        ),
      ),
      GoRoute(
        path: '/List',
        builder: (context, state) => UserList(),
        redirect: (context, state) async {
          final String? token = await autentication.getToken();
          bool isExpired = true;
          if (token != null && token.isNotEmpty) {
            isExpired = JwtDecoder.isExpired(token);
          }
          if (isExpired) {
            return '/';
          }
          return null;
        },
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => SignUpPage(),
      ),
      GoRoute(
        path: '/forget-password',
        builder: (context, state) => ConfirmEmail(),
      ),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) {
          final token = state.uri.queryParameters['token'];
          return ResetPasswordScreen(token: token);
        },
      ),
      GoRoute(
          path: '/account/view', builder: (context, state) => UserYourself()),
      GoRoute(
        path: '/account/settings',
        builder: (context, state) => AccountSettings(),
      ),
      GoRoute(
          path: '/address/form', builder: (context, state) => AddressForm()),
      GoRoute(
        path: '/address/list',
        builder: (context, state) => AddressList(),
      ),
    ],
  );
}
