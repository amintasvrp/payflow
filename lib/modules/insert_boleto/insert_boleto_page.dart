// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:payflow/modules/insert_boleto/insert_boleto_controller.dart';
import 'package:payflow/shared/themes/app_colors.dart';
import 'package:payflow/shared/themes/app_text_styles.dart';
import 'package:payflow/shared/widgets/input_text/input_text_widget.dart';
import 'package:payflow/shared/widgets/set_label_buttons/set_label_bottons.dart';

class InsertBoletoPage extends StatefulWidget {
  const InsertBoletoPage({super.key});

  @override
  State<InsertBoletoPage> createState() => _InsertBoletoPageState();
}

class _InsertBoletoPageState extends State<InsertBoletoPage> {
  final controller = InsertBoletoController();
  final moneyInputTextController =
      MoneyMaskedTextController(leftSymbol: "R\$ ", decimalSeparator: ",");
  final dueDateTextController = MaskedTextController(mask: "00/00/0000");
  final barcodeInputTextController = TextEditingController();
  final nameInputTextController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<String, dynamic>) {
      final barcode = args['barcode'] as String?;
      final dueDate = args['dueDate'] as String?;
      final value = args['value'] as double?;

      if (barcode != null) {
        barcodeInputTextController.text = barcode;
        controller.onChange(barcode: barcode);
      }
      if (dueDate != null) {
        dueDateTextController.text = dueDate;
        controller.onChange(dueDate: dueDate);
      }
      if (value != null) {
        moneyInputTextController.updateValue(value);
        controller.onChange(value: value);
      }

      // Foco no nome do boleto
      FocusScope.of(context).requestFocus(FocusNode());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.input),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              "/home",
              (route) => false,
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 20, bottom: 125),
                child: Text(
                  "Preencha os dados do boleto",
                  style: TextStyles.titleBoldHeading,
                  textAlign: TextAlign.center,
                ),
              ),
              Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    InputTextWidget(
                      label: "Nome do Boleto",
                      icon: Icons.description_outlined,
                      controller: nameInputTextController,
                      validator: controller.validateNome,
                      onChanged: (value) {
                        controller.onChange(name: value);
                      },
                    ),
                    InputTextWidget(
                      label: "Vencimento",
                      icon: FontAwesomeIcons.circleXmark,
                      controller: dueDateTextController,
                      validator: controller.validateVencimento,
                      onChanged: (value) {
                        controller.onChange(dueDate: value);
                      },
                    ),
                    InputTextWidget(
                      label: "Valor",
                      icon: FontAwesomeIcons.wallet,
                      controller: moneyInputTextController,
                      validator: (_) => controller
                          .validateValor(moneyInputTextController.numberValue),
                      onChanged: (value) {
                        controller.onChange(
                            value: moneyInputTextController.numberValue);
                      },
                    ),
                    InputTextWidget(
                      label: "Código",
                      icon: FontAwesomeIcons.barcode,
                      controller: barcodeInputTextController,
                      validator: controller.validateCodigo,
                      onChanged: (value) {
                        controller.onChange(barcode: value);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ValueListenableBuilder<bool>(
        valueListenable: controller.isFormValid,
        builder: (_, isValid, __) => SetLabelButtons(
          primaryLabel: "Escanear",
          primaryOnPressed: () {
            Navigator.pushNamed(context, "/barcode_scanner");
          },
          secondaryLabel: "Cadastrar",
          secondaryOnPressed: isValid
              ? () {
                  controller.cadastrarBoleto().then((_) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      "/home",
                      (route) => false,
                    );
                  });
                }
              : () {},
          enableSecondaryColor: true,
          isSecondaryEnabled: isValid,
        ),
      ),
    );
  }
}
