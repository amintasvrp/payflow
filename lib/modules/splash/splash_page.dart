// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:payflow/shared/auth/auth_controller.dart';
import 'package:payflow/shared/themes/app_colors.dart';
import 'package:payflow/shared/themes/app_images.dart';
import 'package:payflow/shared/themes/app_text_styles.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    goToFirstPage(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 0, right: 0, bottom: 20),
              child: Center(
                  child: Image.asset(
                AppImages.logomini,
                scale: 3,
              )),
            ),
            Center(
                child: Text(
              "PayFlow",
              style: TextStyles.logoFull,
            ))
          ]),
    );
  }

  Future<void> goToFirstPage(BuildContext context) async {
    final authCtrl = AuthController();
    await Future.delayed(const Duration(seconds: 3));
    authCtrl.setUserByPreferences(context);
  }
}
