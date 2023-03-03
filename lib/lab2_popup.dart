import 'package:flutter/material.dart';

class Popup extends StatelessWidget {
  final String messageText;
  const Popup(this.messageText, {Key? key}) : super(key: key);


  @override
  build(BuildContext context) {
    return AlertDialog(
      title: const Text("Решение"),
      content: Text(messageText),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Закрыть')),
      ],
    );
  }
}
