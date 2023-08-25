import 'package:flutter/material.dart';
import 'package:payflow/shared/themes/app_colors.dart';
import 'package:payflow/shared/themes/app_images.dart';
import 'package:payflow/shared/themes/app_text_styles.dart';

class SocialLoginButton extends StatelessWidget {
  final VoidCallback onTap;

  const SocialLoginButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
            color: AppColors.shape,
            border: const Border.fromBorderSide(
                BorderSide(color: AppColors.stroke)),
            borderRadius: BorderRadius.circular(5)),
        child: Row(children: [
          Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 15,
                  ),
                  Image.asset(
                    AppImages.google,
                    scale: 10,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Container(
                    height: 56,
                    width: 1,
                    color: AppColors.stroke,
                  )
                ],
              )),
          Expanded(
            flex: 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Entrar com o Google",
                  style: TextStyles.buttonGray,
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
