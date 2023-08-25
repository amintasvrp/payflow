// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:payflow/shared/auth/auth_controller.dart';
import 'package:payflow/shared/models/user_model.dart';

class LoginController {
  final authCtrl = AuthController();
  Future<void> googleSignIn(BuildContext context) async {
    GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: ['email'],
    );

    try {
      final response = await googleSignIn.signIn();
      final user =
          UserModel(name: response!.displayName!, photoURL: response.photoUrl);
      authCtrl.setUserAuthenticated(context, user);
      print(response);
    } catch (error) {
      authCtrl.setUserAuthenticated(context, null);
      print(error);
    }
  }
}
