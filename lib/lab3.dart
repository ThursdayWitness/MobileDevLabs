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
            primary: Colors.white70,
            secondary: Colors.deepOrange,
            tertiary: Colors.grey),
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
  var text = "0";
  var result = "0";
  bool isResultVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Visibility(
              visible: isResultVisible,
              child: Text(
                result,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontSize: 24),
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Text(
            text,
            style: TextStyle(
                color: Theme.of(context).colorScheme.primary, fontSize: 48),
          ),
        ),
        Table(children: [
          TableRow(children: [
            ActionButton(
                child: "AC",
                action: () => setState(() {
                      if (text == "0") {
                        result = "0";
                        isResultVisible = false;
                      }
                      text = "0";
                      currentOperation = Operation.none;
                    })),
            ActionButton(
                child: "+/-",
                action: () => setState(() {
                      if (currentOperation == Operation.none) {
                        text = (-1 * int.parse(text)).toString();
                      }
                    })),
            ActionButton(
                child: "%",
                action: () => setState(() {
                      if (currentOperation == Operation.none) {
                        text += "%";
                        currentOperation = Operation.mod;
                      }
                    })),
            ActionButton(
                child: "/",
                action: () => setState(() {
                      if (currentOperation == Operation.none) {
                        text += "/";
                        currentOperation = Operation.divide;
                      }
                    })),
          ]),
          TableRow(children: [
            ActionButton(
                child: "7",
                action: () => setState(() {
                      if (text == "0") {
                        text = "7";
                      } else {
                        text += "7";
                      }
                    })),
            ActionButton(
                child: "8",
                action: () => setState(() {
                      if (text == "0") {
                        text = "8";
                      } else {
                        text += "8";
                      }
                    })),
            ActionButton(
                child: "9",
                action: () => setState(() {
                      if (text == "0") {
                        text = "9";
                      } else {
                        text += "9";
                      }
                    })),
            ActionButton(
                child: "x",
                action: () => setState(() {
                      if (currentOperation == Operation.none) {
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
                      if (text == "0") {
                        text = "5";
                      } else {
                        text += "5";
                      }
                    })),
            ActionButton(
                child: "6",
                action: () => setState(() {
                      if (text == "0") {
                        text = "6";
                      } else {
                        text += "6";
                      }
                    })),
            ActionButton(
                child: "-",
                action: () => setState(() {
                      if (currentOperation == Operation.none) {
                        text += "-";
                        currentOperation = Operation.subtract;
                      }
                    })),
          ]),
          TableRow(children: [
            ActionButton(
                child: "1",
                action: () => setState(() {
                      if (text == "0") {
                        text = "1";
                      } else {
                        text += "1";
                      }
                    })),
            ActionButton(
                child: "2",
                action: () => setState(() {
                      if (text == "0") {
                        text = "2";
                      } else {
                        text += "2";
                      }
                    })),
            ActionButton(
                child: "3",
                action: () => setState(() {
                      if (text == "0") {
                        text = "3";
                      } else {
                        text += "3";
                      }
                    })),
            ActionButton(
                child: "+",
                action: () => setState(() {
                      if (currentOperation == Operation.none) {
                        text += "+";
                        currentOperation = Operation.add;
                      }
                    })),
          ]),
          TableRow(children: [
            const Padding(
              padding: EdgeInsets.zero,
            ),
            ActionButton(
              child: "0",
              action: () => setState(() {
                if (text != "0") {
                  text += "0";
                }
              }),
            ),
            ActionButton(
                child: ",",
                action: () {
                  if (double.tryParse(text) != null) {
                    setState(() {
                      text += ".";
                    });
                  }
                }),
            ActionButton(
                child: "=",
                customStyle: TextButton.styleFrom(
                  shape: const CircleBorder(side: BorderSide()),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
                customTextStyle: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).colorScheme.primary),
                action: () {
                  var operationResult = 0.0;
                  switch (currentOperation) {
                    case Operation.mod:
                      {
                        setState(() {
                          operationResult =
                              double.parse(text.substring(0, text.length - 1)) /
                                  100;
                          text = operationResult.toString();
                          currentOperation = Operation.none;
                        });
                        return;
                      }

                    case Operation.divide:
                      {
                        setState(() {
                          if (text.split("/")[1] == "0") {
                            operationResult = double.infinity;
                            return;
                          }
                          operationResult = double.parse(text.split("/")[0]) /
                              double.parse(text.split("/")[1]);
                        });
                      }
                      break;

                    case Operation.multiply:
                      {
                        setState(() {
                          operationResult = double.parse(text.split("x")[0]) *
                              double.parse(text.split("x")[1]);
                        });
                      }
                      break;

                    case Operation.subtract:
                      {
                        setState(() {
                          operationResult = double.parse(text.split("-")[0]) -
                              double.parse(text.split("-")[1]);
                        });
                      }
                      break;

                    case Operation.add:
                      {
                        setState(() {
                          operationResult = double.parse(text.split("+")[0]) +
                              double.parse(text.split("+")[1]);
                        });
                      }
                      break;

                    default:
                      {
                        return;
                      }
                  }
                  if (operationResult == double.infinity) {
                    result = text + "=" + "Inf";
                    text = "0";
                  } else {
                    if (operationResult.roundToDouble() ==
                        operationResult.toInt()) {
                      result = text + "=" + operationResult.toInt().toString();
                      text = "${operationResult.toInt()}";
                    } else {
                      result = text + "=" + operationResult.toString();
                      text = "$operationResult";
                    }
                  }
                  currentOperation = Operation.none;
                  isResultVisible = true;
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
  final ButtonStyle? customStyle;
  final TextStyle? customTextStyle;

  const ActionButton(
      {required this.child,
      required this.action,
      this.customStyle,
      this.customTextStyle,
      Key? key})
      : super(key: key);

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).colorScheme.primary;
    if (int.tryParse(widget.child) == null && widget.child != ",") {
      color = Theme.of(context).colorScheme.secondary;
    }
    return TextButton(
        style: widget.customStyle ??
            TextButton.styleFrom(
              fixedSize: const Size(100, 66),
              shape:
                  const CircleBorder(side: BorderSide(style: BorderStyle.none)),
            ),
        onPressed: widget.action,
        child: Text(
          widget.child,
          style: widget.customTextStyle ??
              TextStyle(
                  fontSize: 36, fontWeight: FontWeight.normal, color: color),
        ));
  }
}
