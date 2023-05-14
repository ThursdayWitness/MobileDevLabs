import 'package:flutter/material.dart';

class CalcButton extends StatelessWidget {
  final Color? color;
  final Color? textColor;
  final String buttonText;
  final void Function() action;

  const CalcButton(
      {super.key,
      this.color,
      this.textColor,
      required this.buttonText,
      required this.action});

  @override
  Widget build(BuildContext context) {
    if(buttonText == "") return const Text("");
    return TextButton(
      onPressed: action,
      style: TextButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: color,
      ),
      child: Text(
        buttonText,
        style: TextStyle(
          color: textColor ?? Colors.white,
          fontSize: 36,
          // fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
