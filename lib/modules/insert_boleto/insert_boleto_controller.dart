import 'package:flutter/material.dart';
import 'package:payflow/shared/models/boleto_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InsertBoletoController {
  final formKey = GlobalKey<FormState>();
  BoletoModel model = BoletoModel();

  String? validateNome(String? value) =>
      value?.isEmpty ?? true ? 'O nome não pode ser vazio' : null;

  String? validateVencimento(String? value) =>
      value?.isEmpty ?? true ? 'O vencimento não pode ser vazio' : null;

  String? validateValor(double value) =>
      value == 0 ? 'Insira um valor maior que \$0.00' : null;

  String? validateCodigo(String? value) =>
      value?.isEmpty ?? true ? 'O código do boleto não pode ser vazio' : null;

  Future<void> cadastrarBoleto() async {
    final form = formKey.currentState;
    if (form!.validate()) {
      return saveBoleto();
    }
  }

  Future<void> saveBoleto() async {
    final instance = await SharedPreferences.getInstance();
    final boletos = instance.getStringList('boletos') ?? <String>[];
    boletos.add(model.toJson());
    await instance.setStringList('boletos', boletos);
    return;
  }

  void onChange({
    String? name,
    String? dueDate,
    double? value,
    String? barcode,
  }) =>
      {
        model = model.copyWith(
            name: name, dueDate: dueDate, value: value, barcode: barcode)
      };
}
