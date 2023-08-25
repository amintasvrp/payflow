import 'package:flutter/material.dart';
import 'package:payflow/modules/home/home_controller.dart';
import 'package:payflow/shared/themes/app_colors.dart';
import 'package:payflow/shared/themes/app_text_styles.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final homeCtrl = HomeController();
  final pages = [Container(color: Colors.red), Container(color: Colors.blue)];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(200),
        child: Container(
          color: AppColors.primary,
          height: 200,
          child: Center(
            child: ListTile(
              title: Text.rich(TextSpan(
                  text: "Olá, ",
                  style: TextStyles.titleRegular,
                  children: [
                    TextSpan(
                        text: "Amintas", style: TextStyles.titleBoldBackground)
                  ])),
              subtitle: Text(
                "Mantenha suas contas em dia",
                style: TextStyles.captionShape,
              ),
              trailing: Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(5))),
            ),
          ),
        ),
      ),
      body: pages[homeCtrl.currentPage],
      bottomNavigationBar: SizedBox(
        height: 90,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          IconButton(
              onPressed: () {
                homeCtrl.setPage(0);
                setState(() {});
              },
              icon: Icon(
                Icons.home_rounded,
                color: isActiveColor(0),
              )),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(5)),
              child: const Icon(
                Icons.add_box_outlined,
                color: AppColors.background,
              ),
            ),
          ),
          IconButton(
              onPressed: () {
                homeCtrl.setPage(1);
                setState(() {});
              },
              icon: Icon(Icons.description_rounded, color: isActiveColor(1))),
        ]),
      ),
    );
  }

  Color isActiveColor(int page) {
    return homeCtrl.currentPage == page ? AppColors.primary : AppColors.grey;
  }
}
