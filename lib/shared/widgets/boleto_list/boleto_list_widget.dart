// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:payflow/shared/models/boleto_model.dart';
import 'package:payflow/shared/widgets/boleto_tile/boleto_tile_widget.dart';
import 'boleto_list_controller.dart';
import 'package:payflow/shared/themes/app_text_styles.dart';

class BoletoListWidget extends StatelessWidget {
  final bool fromExtrato;
  final bool enableSwipeRight;

  BoletoListWidget({
    Key? key,
    this.fromExtrato = false,
    this.enableSwipeRight = false,
  }) : super(key: key);

  final controller = BoletoListController();

  @override
  Widget build(BuildContext context) {
    final notifier =
        fromExtrato ? controller.extratosNotifier : controller.boletosNotifier;

    return ValueListenableBuilder<List<BoletoModel>>(
      valueListenable: notifier,
      builder: (_, boletos, __) {
        if (boletos.isEmpty) {
          return SizedBox(
            height: 100,
            child: Center(
              child: Text(
                "Nenhum boleto cadastrado",
                style: TextStyles.captionBody.copyWith(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }

        // 🔽 Agora a lista é rolável verticalmente
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 80),
          physics:
              const BouncingScrollPhysics(), // scroll suave com "efeito mola"
          itemCount: boletos.length,
          itemBuilder: (_, index) {
            final boleto = boletos[index];

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Dismissible(
                  key: ValueKey(UniqueKey()), // Key única por item

                  // Swipe right (pagar)
                  background: enableSwipeRight
                      ? Container(
                          color: Colors.green,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(Icons.payment, color: Colors.white),
                        )
                      : Container(color: Colors.transparent),

                  // Swipe left (remover)
                  secondaryBackground: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),

                  direction: enableSwipeRight
                      ? DismissDirection.horizontal
                      : DismissDirection.endToStart,

                  onDismissed: (direction) async {
                    if (direction == DismissDirection.endToStart) {
                      await controller.removeBoleto(boleto,
                          fromExtrato: fromExtrato);
                    } else if (direction == DismissDirection.startToEnd &&
                        enableSwipeRight) {
                      await controller.pagarBoleto(boleto);
                    }

                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          direction == DismissDirection.startToEnd
                              ? "Boleto pago."
                              : "Boleto removido.",
                        ),
                        action: SnackBarAction(
                          label: "Desfazer",
                          onPressed: () async {
                            await controller.undoLastAction();
                          },
                        ),
                      ),
                    );
                  },

                  child: Container(
                    color: const Color(0xFFF5F5F5),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: BoletoTileWidget(data: boleto),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
