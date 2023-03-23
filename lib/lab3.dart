import 'package:flutter/material.dart';

void main() => runApp(const Lab3());

class Lab3 extends StatelessWidget {
  const Lab3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Lab3: «Калькулятор»",
      debugShowCheckedModeBanner: false,
      showSemanticsDebugger: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
            brightness: Brightness.dark,
            primary: Colors.grey,
            secondary: Colors.deepOrange),
      ),
      home: const Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({Key? key}) : super(key: key);

  @override
  State<Calculator> createState() => _CalculatorState();
}

enum Operation {
  none,
  mod,
  divide,
  multiply,
  subtract,
  add,
}

class _CalculatorState extends State<Calculator> {
  var currentOperation = Operation.none;
  var firstValue = 0;
  var secondValue = 0;
  var text = "0";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(text),
        Table(children: [
          TableRow(children: [
            ActionButton(
                child: "C",
                action: () => setState(() {
                      text = "0";
                      currentOperation = Operation.none;
                    })),
            ActionButton(
                child: "\u232B",
                action: () => setState(() {
                      if (text.length == 1) {
                        text = "0";
                        currentOperation = Operation.none;
                        return;
                      }
                      if (text != "0") {
                        if (int.tryParse(text[text.length - 1]) == null) {
                          currentOperation = Operation.none;
                        }
                        text = text.substring(0, text.length - 1);
                      }
                    })),
            ActionButton(
                child: "%",
                action: () => setState(() {
                      if (currentOperation == Operation.none) {
                        firstValue = int.parse(text);
                        text += "%";
                        currentOperation = Operation.mod;
                      }
                    })),
            ActionButton(
                child: "/",
                action: () => setState(() {
                      if (currentOperation == Operation.none) {
                        firstValue = int.parse(text);
                        text += "/";
                        currentOperation = Operation.divide;
                      }
                    })),
          ]),
          TableRow(children: [
            ActionButton(
                child: "7",
                action: () => setState(() {
                      if (text.compareTo("0") == 0) {
                        text = "7";
                      } else {
                        text += "7";
                      }
                    })),
            ActionButton(
                child: "8",
                action: () => setState(() {
                      if (text.compareTo("0") == 0) {
                        text = "8";
                      } else {
                        text += "8";
                      }
                    })),
            ActionButton(
                child: "9",
                action: () => setState(() {
                      if (text.compareTo("0") == 0) {
                        text = "9";
                      } else {
                        text += "9";
                      }
                    })),
            ActionButton(
                child: "x",
                action: () => setState(() {
                      if (currentOperation == Operation.none) {
                        firstValue = int.parse(text);
                        text += "x";
                        currentOperation = Operation.multiply;
                      }
                    })),
          ]),
          TableRow(children: [
            ActionButton(
                child: "4",
                action: () => setState(() {
                      if (text == "0") {
                        text = "4";
                      } else {
                        text += "4";
                      }
                    })),
            ActionButton(
                child: "5",
                action: () => setState(() {
                      if (text.compareTo("0") == 0) {
                        text = "5";
                      } else {
                        text += "5";
                      }
                    })),
            ActionButton(
                child: "6",
                action: () => setState(() {
                      if (text.compareTo("0") == 0) {
                        text = "6";
                      } else {
                        text += "6";
                      }
                    })),
            ActionButton(
                child: "-",
                action: () => setState(() {
                      if (currentOperation == Operation.none) {
                        firstValue = int.parse(text);
                        text += "-";
                        currentOperation = Operation.subtract;
                      }
                    })),
          ]),
          TableRow(children: [
            ActionButton(
                child: "1",
                action: () => setState(() {
                      if (text.compareTo("0") == 0) {
                        text = "1";
                      } else {
                        text += "1";
                      }
                    })),
            ActionButton(
                child: "2",
                action: () => setState(() {
                      if (text.compareTo("0") == 0) {
                        text = "2";
                      } else {
                        text += "2";
                      }
                    })),
            ActionButton(
                child: "3",
                action: () => setState(() {
                      if (text.compareTo("0") == 0) {
                        text = "3";
                      } else {
                        text += "3";
                      }
                    })),
            ActionButton(
                child: "+",
                action: () => setState(() {
                      if (currentOperation == Operation.none) {
                        firstValue = int.parse(text);
                        text += "+";
                        currentOperation = Operation.add;
                      }
                    })),
          ]),
          TableRow(children: [
            const Padding(
              padding: EdgeInsets.zero,
            ),
            ActionButton(child: "0", action: () {}),
            ActionButton(child: ".", action: () {}),
            ActionButton(
                child: "=",
                action: () {
                  switch (currentOperation) {
                    case Operation.mod:
                      {
                        //TODO
                        return;
                      }
                      break;

                    case Operation.divide:
                      {
                        setState(() {
                          secondValue = int.parse(text.split("/")[1]);
                          text = "=${firstValue/secondValue}";
                        });
                      }
                      break;

                    case Operation.multiply:
                      {
                        setState(() {
                          secondValue = int.parse(text.split("*")[1]);
                          text = "=${firstValue*secondValue}";
                        });
                      }
                      break;

                    case Operation.subtract:
                      {
                        setState(() {
                          secondValue = int.parse(text.split("-")[1]);
                          text = "=${firstValue-secondValue}";
                        });
                      }
                      break;

                    case Operation.add:
                      {
                        setState(() {
                          secondValue = int.parse(text.split("+")[1]);
                          text = "=${firstValue+secondValue}";
                        });
                      }
                      break;

                    default:
                      {
                        return;
                      }
                  }
                }),
          ])
        ])
      ],
    ));
  }
}

class ActionButton extends StatefulWidget {
  final String child;
  final void Function() action;

  const ActionButton({required this.child, required this.action, Key? key})
      : super(key: key);

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.action,
      child: Text(widget.child,
          style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.deepOrange)),
    );
  }
}
