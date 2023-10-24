import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:payflow/app_widget.dart';

void main() {
  runApp(const AppFirebase());
}

class AppFirebase extends StatefulWidget {
  const AppFirebase({super.key});

  @override
  State<AppFirebase> createState() => _AppFirebaseState();
}

class _AppFirebaseState extends State<AppFirebase> {
  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> init = Firebase.initializeApp();

    return FutureBuilder(
        future: init,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Material(
              child: Center(
                  child: Text(
                "Não foi possível iniciar o Firebase",
                textDirection: TextDirection.ltr,
              )),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            return AppWidget();
          } else {
            return const Material(
              child: Center(child: CircularProgressIndicator()),
            );
          }
        });
  }
}
