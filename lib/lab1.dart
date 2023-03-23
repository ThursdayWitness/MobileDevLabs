import 'package:flutter/material.dart';

void main() => runApp(const Lab1());

class Lab1 extends StatefulWidget {
  const Lab1({Key? key}) : super(key: key);

  @override
  _Lab1State createState() => _Lab1State();
}

class _Lab1State extends State<Lab1> {
  final myController = TextEditingController();
  var isTextVisible = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(title: const Text("Lab1: «Hello World»")),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(controller: myController),
                ElevatedButton(
                    onPressed: () {
                      isTextVisible = !isTextVisible;
                      setState(() {});
                    },
                    child: const Text("Отобразить")),
                if (isTextVisible) Text(myController.text),
              ],
            )));
  }
}
