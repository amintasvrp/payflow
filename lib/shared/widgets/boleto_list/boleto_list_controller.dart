import 'package:flutter/material.dart';
import 'package:payflow/shared/models/boleto_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BoletoListController {
  static final BoletoListController _instance =
      BoletoListController._internal();
  factory BoletoListController() => _instance;

  BoletoListController._internal() {
    _loadBoletos();
    _loadExtratos();
  }

  final boletosNotifier = ValueNotifier<List<BoletoModel>>([]);
  final extratosNotifier = ValueNotifier<List<BoletoModel>>([]);

  BoletoModel? _lastBoleto;
  bool _lastWasPayment = false;
  bool _lastFromExtrato = false;

  Future<void> _loadBoletos() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList('boletos') ?? [];
    boletosNotifier.value = stored.map((e) => BoletoModel.fromJson(e)).toList();
  }

  Future<void> _loadExtratos() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList('extratos') ?? [];
    extratosNotifier.value =
        stored.map((e) => BoletoModel.fromJson(e)).toList();
  }

  Future<void> _updateStorage({required bool extrato}) async {
    final prefs = await SharedPreferences.getInstance();
    if (extrato) {
      await prefs.setStringList(
        'extratos',
        extratosNotifier.value.map((b) => b.toJson()).toList(),
      );
    } else {
      await prefs.setStringList(
        'boletos',
        boletosNotifier.value.map((b) => b.toJson()).toList(),
      );
    }
  }

  Future<void> removeBoleto(BoletoModel boleto,
      {required bool fromExtrato}) async {
    _lastBoleto = boleto;
    _lastWasPayment = false;
    _lastFromExtrato = fromExtrato;

    if (fromExtrato) {
      extratosNotifier.value =
          extratosNotifier.value.where((b) => b != boleto).toList();
      await _updateStorage(extrato: true);
    } else {
      boletosNotifier.value =
          boletosNotifier.value.where((b) => b != boleto).toList();
      await _updateStorage(extrato: false);
    }
  }

  Future<void> pagarBoleto(BoletoModel boleto) async {
    _lastBoleto = boleto;
    _lastWasPayment = true;
    _lastFromExtrato = false;

    boletosNotifier.value =
        boletosNotifier.value.where((b) => b != boleto).toList();
    extratosNotifier.value = List.from(extratosNotifier.value)..add(boleto);

    await _updateStorage(extrato: false);
    await _updateStorage(extrato: true);
  }

  Future<void> undoLastAction() async {
    if (_lastBoleto == null) return;

    if (_lastWasPayment) {
      extratosNotifier.value =
          extratosNotifier.value.where((b) => b != _lastBoleto).toList();
      boletosNotifier.value = List.from(boletosNotifier.value)
        ..add(_lastBoleto!);
      await _updateStorage(extrato: false);
      await _updateStorage(extrato: true);
    } else {
      if (_lastFromExtrato) {
        extratosNotifier.value = List.from(extratosNotifier.value)
          ..add(_lastBoleto!);
        await _updateStorage(extrato: true);
      } else {
        boletosNotifier.value = List.from(boletosNotifier.value)
          ..add(_lastBoleto!);
        await _updateStorage(extrato: false);
      }
    }

    _lastBoleto = null;
  }

  Future<void> refresh() async {
    await _loadBoletos();
    await _loadExtratos();
  }
}
