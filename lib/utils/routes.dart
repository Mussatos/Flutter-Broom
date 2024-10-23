import 'package:broom_main_vscode/Login.dart';
import 'package:broom_main_vscode/api/user.api.dart';
import 'package:broom_main_vscode/main.dart';
import 'package:broom_main_vscode/resetPassword.dart';
import 'package:broom_main_vscode/signup.dart';
import 'package:go_router/go_router.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

final GoRouter routes = GoRouter(routes: [
  GoRoute(path: '/', builder: (context, state) => HomePage()),
  GoRoute(
    path: '/login',
    builder: (context, state) => LoginPage(),
  ),
  GoRoute(
    path: '/register',
    builder: (context, state) => SignUpPage(),
  ),
 GoRoute(
    path: '/reset-password',
    builder: (context, state) {
        final token = state.pathParameters['token']; // Usa queryParams
        return ResetPasswordScreen(token: token);
    },
),
]);
