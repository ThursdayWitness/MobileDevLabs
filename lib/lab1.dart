import 'package:flutter/material.dart';


void main() => runApp(const MainPage());

class MainPage extends StatefulWidget
{
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
{
  final myController = TextEditingController();
  var isTextVisible = false;

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(controller: myController),
                ElevatedButton(onPressed: () {isTextVisible = true; setState((){});}, child: const Text("Отобразить")),
                if(isTextVisible) Text(myController.text),
              ],
            )
        )
    );
  }
}