import 'package:flutter/material.dart';
import 'package:payflow/shared/themes/app_text_styles.dart';
import 'package:payflow/shared/widgets/divider_vertical/divider_verical.dart';
import 'package:payflow/shared/widgets/label_button/label_button.dart';

class SetLabelButtons extends StatelessWidget {
  final String primaryLabel;
  final VoidCallback primaryOnPressed;
  final String secondaryLabel;
  final VoidCallback secondaryOnPressed;
  final bool enablePrimaryColor;
  const SetLabelButtons(
      {super.key,
      required this.primaryLabel,
      required this.primaryOnPressed,
      required this.secondaryLabel,
      required this.secondaryOnPressed,
      this.enablePrimaryColor = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 56,
        child: Row(
          children: [
            Expanded(
                child: LabelButton(
              label: primaryLabel,
              onPressed: primaryOnPressed,
              style: enablePrimaryColor
                  ? TextStyles.buttonPrimary
                  : TextStyles.buttonHeading,
            )),
            const DividerVertical(),
            Expanded(
                child: LabelButton(
              label: secondaryLabel,
              onPressed: secondaryOnPressed,
              style: TextStyles.buttonHeading,
            )),
          ],
        ));
  }
}
