import 'package:broom_main_vscode/address_form.dart';
import 'package:broom_main_vscode/address_list.dart';
import 'package:broom_main_vscode/api/user.api.dart';
import 'package:broom_main_vscode/calendaryPage.dart';
import 'package:broom_main_vscode/confirmEmail.dart';
import 'package:broom_main_vscode/edit_address.dart';
import 'package:broom_main_vscode/models/bank_info.model.dart';
import 'package:broom_main_vscode/signUp.dart';
import 'package:broom_main_vscode/user.dart';
import 'package:broom_main_vscode/signUp.dart';
import 'package:broom_main_vscode/user_yourself.dart';
import 'package:broom_main_vscode/view/account_settings.dart';
import 'package:broom_main_vscode/view/bank_information.dart';
import 'package:broom_main_vscode/view/bank_information_edit.dart';
import 'package:broom_main_vscode/view/payment_canceled.dart';
import 'package:broom_main_vscode/view/payment_success_view.dart';
import 'package:broom_main_vscode/view/userFavorite_list.dart';
import 'package:broom_main_vscode/view/listMeeting.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:broom_main_vscode/Login.dart';
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
      GoRoute(
        path: '/favorite-page',
        builder: (context, state) => UserfavoriteList(),
      ),
      GoRoute(
        path: '/bank/information',
        builder: (context, state) => const BankInformation(),
        redirect: (context, state) async {
          final bool isDiarist = await autentication.getProfileId() == 2;
          if (isDiarist) return null;

          return '/List';
        },
      ),
      GoRoute(
        path: '/bank/information/edit',
        builder: (context, state) {
          BankInfo? diaristInfo = state.extra as BankInfo?;
          return BankInformationEdit(diaristInfo: diaristInfo);
        },
        redirect: (context, state) async {
          final bool isDiarist = await autentication.getProfileId() == 2;
          if (isDiarist) return null;

          return '/List';
        },
      ),
      GoRoute(
        path: '/meeting-page',
        builder: (context, state) => const Usermeeting(),
      ),
      GoRoute(
          path: '/payment/success',
          builder: (context, state) => PaymentSuccessView()),
      GoRoute(
          path: '/payment/canceled',
          builder: (context, state) => PaymentCanceledView())
    ],
  );
}
