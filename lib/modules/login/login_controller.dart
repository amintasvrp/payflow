// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:payflow/shared/models/user_model.dart';
import 'package:payflow/main.dart'; // importa a instância global


class LoginController {
  Future<void> googleSignIn(BuildContext context) async {
    GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: ['email'],
    );

    try {
      final response = await googleSignIn.signIn();
      final user =
          UserModel(name: response!.displayName!, photoURL: response.photoUrl);
      authController.setUserAuthenticated(context, user);
      print(response);
    } catch (error) {
      authController.setUserAuthenticated(context, null);
      print(error);
    }
  }
}
