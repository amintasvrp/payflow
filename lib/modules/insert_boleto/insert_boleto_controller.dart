import 'package:flutter/material.dart';
import 'package:payflow/shared/models/boleto_model.dart';
import 'package:payflow/shared/widgets/boleto_list/boleto_list_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InsertBoletoController {
  final formKey = GlobalKey<FormState>();
  BoletoModel model = BoletoModel();
  final ValueNotifier<bool> isFormValid = ValueNotifier(false);

  // =========================
  // Validadores
  // =========================
  String? validateNome(String? value) =>
      value?.isEmpty ?? true ? 'Não pode ser vazio' : null;

  String? validateVencimento(String? value) {
    if (value?.isEmpty ?? true) return 'Não pode ser vazio';
    if (value!.length < 10) return 'Deve ter o formato DD/MM/AAAA';
    return null;
  }

  String? validateValor(double value) =>
      value == 0 ? 'Insira um valor maior que R\$0,00' : null;

  String? validateCodigo(String? value) => null;

  // =========================
  // Cadastrar boleto
  // =========================
  Future<void> cadastrarBoleto() async {
    final form = formKey.currentState;

    if (form!.validate()) {
      await saveBoleto();
      // Atualiza a lista global de boletos
      await BoletoListController().refresh();
    }
  }

  Future<void> saveBoleto() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList('boletos') ?? [];
    stored.add(model.toJson());
    await prefs.setStringList('boletos', stored);

    // Atualiza o ValueNotifier
    final controller = BoletoListController();
    controller.boletosNotifier.value = [...controller.boletosNotifier.value, model];
  }

  // =========================
  // Atualiza modelo e valida formulário
  // =========================
  void onChange({
    String? name,
    String? dueDate,
    double? value,
    String? barcode,
  }) {
    model = model.copyWith(
      name: name,
      dueDate: dueDate,
      value: value,
      barcode: barcode,
    );

    final isValid = formKey.currentState?.validate() ?? false;
    isFormValid.value = isValid;
  }
}
