import 'package:flutter/material.dart';

// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';
import 'lab1.dart';
import 'lab2.dart';
import 'lab3_v2.dart';
// import 'provider_training.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final labs = [const Lab1(), const Lab2(), const Lab3V2()];

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(title: const Text("Лабы")),
          body: ListView(children: [for (var lab in labs) NavButton(lab)])),
    );
  }
}

class NavButton extends StatelessWidget {
  final Widget page;

  const NavButton(this.page, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => page));
        },
        child: Text(page.toString()));
  }
}
