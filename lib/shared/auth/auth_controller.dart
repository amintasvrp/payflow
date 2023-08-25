// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:payflow/shared/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  UserModel? _user;

  UserModel get user => _user!;

  void setUserAuthenticated(BuildContext context, UserModel? user) {
    if (user != null) {
      saveUser(user);
      Navigator.pushReplacementNamed(context, "/home");
    } else {
      Navigator.pushReplacementNamed(context, "/login");
    }
  }

  Future<void> saveUser(UserModel user) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setString("user", user.toJSON());
    _user = user;
  }

  Future<bool> setUserByPreferences(BuildContext context) async {
    final preferences = await SharedPreferences.getInstance();
    if (preferences.containsKey("user")) {
      final json = preferences.get("user") as String;
      setUserAuthenticated(context, UserModel.fromJSON(json));
      return true;
    } else {
      setUserAuthenticated(context, null);
      return false;
    }
  }
}
