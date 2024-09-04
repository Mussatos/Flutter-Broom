import 'package:broom_main_vscode/user.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class UserProvider extends InheritedWidget {
  final Widget child;

  List<User> users = [];
  User? userSelect;
  int? indexUser;

  UserProvider({
    required this.child,
  }) : super(child: child);

  set userSelected(User userSelected) {}

  static UserProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<UserProvider>();
  }

  bool updateShouldNotify(UserProvider widget) {
    return true;
  }
}
