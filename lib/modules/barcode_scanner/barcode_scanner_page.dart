import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({super.key});

  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startScanner();
    });
  }

  Map<String, dynamic> parseBoleto(String barcode) {

    if (barcode.length != 44) return {};

    try {
      String factorStr = barcode.substring(6, 9);
      int factor = int.tryParse(factorStr) ?? 0;
      DateTime baseDate = DateTime(1997, 10, 7);
      DateTime dueDate = baseDate.add(Duration(days: factor + 10001));

      String valueStr = barcode.substring(9, 19);
      int valueInt = int.tryParse(valueStr) ?? 0;
      double value = valueInt / 100.0;

      String dueDateFormatted =
          "${dueDate.day.toString().padLeft(2, '0')}/${dueDate.month.toString().padLeft(2, '0')}/${dueDate.year}";

      return {
        'barcode': barcode,
        'dueDate': dueDateFormatted,
        'value': value,
      };
    } catch (e) {
      return {'barcode': barcode};
    }
  }

  Future<void> startScanner() async {
    if (_isScanning) return;
    _isScanning = true;

    try {
      final barcode = await FlutterBarcodeScanner.scanBarcode(
        '#FFFF941A', // cor do overlay
        'CANCELAR',
        true,
        ScanMode.BARCODE,
      );

      if (!mounted) return;

      // Usuário cancelou
      if (barcode == '-1') {
        Navigator.pushReplacementNamed(context, "/insert_boleto");
        return;
      }

      // Valida tamanho do código de barras
      if (barcode.length != 44) {
        // Mostra alerta e permite tentar novamente
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Código inválido"),
            content:
                const Text("O código escaneado não é válido. Tente novamente."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  startScanner(); // reinicia o scanner
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );
        return;
      }

      // Extrai dados do boleto
      final boletoData = parseBoleto(barcode);

      // Navega para InsertBoletoPage passando os dados
      Navigator.pushReplacementNamed(
        context,
        "/insert_boleto",
        arguments: boletoData,
      );
    } catch (e) {
      Navigator.pushReplacementNamed(context, "/insert_boleto");
    } finally {
      _isScanning = false;
    }
  }

  // =========================
  // Intercepta botão de voltar físico
  // =========================
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, "/insert_boleto");
        return false; // impede o pop padrão
      },
      child: const Scaffold(),
    );
  }
}
