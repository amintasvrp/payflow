import 'package:flutter/material.dart';
import 'package:payflow/modules/extract/extract_page.dart';
import 'package:payflow/modules/home/home_controller.dart';
import 'package:payflow/modules/meus_boletos/meus_boletos_page.dart';
import 'package:payflow/shared/themes/app_colors.dart';
import 'package:payflow/shared/themes/app_text_styles.dart';
import 'package:payflow/main.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final homeCtrl = HomeController();
  final pages = [MeusBoletosPage(), ExtractPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // fundo padrão

      body: Column(
        children: [
          // Header azul
          Container(
            height: 200,
            color: AppColors.primary,
            child: Center(
              child: ListTile(
                title: Text.rich(TextSpan(
                  text: "Olá, ",
                  style: TextStyles.titleRegular,
                  children: [
                    TextSpan(
                      text: authController.user?.name,
                      style: TextStyles.titleBoldBackground,
                    )
                  ],
                )),
                subtitle: Text("Mantenha seus boletos em dia",
                    style: TextStyles.captionShape),
                trailing: _buildUserAvatar(),
              ),
            ),
          ),

          // Body expandido
          Expanded(
            child: pages[homeCtrl.currentPage], // MeusBoletosPage
          ),
        ],
      ),

      bottomNavigationBar: SizedBox(
        height: 90,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                homeCtrl.setPage(0);
                setState(() {});
              },
              icon: Icon(Icons.home_rounded, color: isActiveColor(0)),
            ),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, "/insert_boleto"),
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Icon(Icons.add_box_outlined, color: AppColors.background),
              ),
            ),
            IconButton(
              onPressed: () {
                homeCtrl.setPage(1);
                setState(() {});
              },
              icon: Icon(Icons.description_rounded, color: isActiveColor(1)),
            ),
          ],
        ),
      ),
    );
  }

  Color isActiveColor(int page) =>
      homeCtrl.currentPage == page ? AppColors.primary : AppColors.grey;

  Widget _buildUserAvatar() {
    final user = authController.user;
    if (user == null || user.photoURL == null || user.photoURL!.isEmpty) {
      return Container(
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(24),
        ),
      );
    } else {
      return CircleAvatar(
        radius: 24,
        backgroundImage: NetworkImage(user.photoURL!),
        backgroundColor: Colors.grey[200],
      );
    }
  }
}

