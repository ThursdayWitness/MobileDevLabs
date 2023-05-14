import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

import './buttons.dart';

void main() {
  runApp(const Lab3V2());
}

class Lab3V2 extends StatelessWidget {
  const Lab3V2({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.deepOrange,
      ),
      home: const HomePage(),
    ); // MaterialApp
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  var userInput = '';
  var result = '';

  @override
  Widget build(BuildContext context) {
    final Map<String, Map<String, dynamic>> buttons = {
      'C': {
        "action": () {
          userInput = '';
          result = '0';
        },
        "textColor": Theme.of(context).primaryColor
      },
      '\u232B': {
        "action": () {
          if (userInput.isNotEmpty) {
            userInput = userInput.substring(0, userInput.length - 1);
          }
        },
        "textColor": Theme.of(context).primaryColor
      },
      '%': {
        "action": () {
          if (userInput.isNotEmpty && !RegExp(r'\D$').hasMatch(userInput)) {
            userInput += "%";
          }
        },
        "textColor": Theme.of(context).primaryColor
      },
      '/': {
        "action": () {
          if (userInput.isNotEmpty && !RegExp(r'\D$').hasMatch(userInput)) {
            userInput += "/";
          }
        },
        "textColor": Theme.of(context).primaryColor
      },
      '7': {
        "action": () {
          userInput += "7";
        }
      },
      '8': {
        "action": () {
          userInput += "8";
        }
      },
      '9': {
        "action": () {
          userInput += "9";
        }
      },
      'x': {
        "action": () {
          if (userInput.isNotEmpty && !RegExp(r'\D$').hasMatch(userInput)) {
            userInput += "x";
          }
        },
        "textColor": Theme.of(context).primaryColor
      },
      '4': {
        "action": () {
          userInput += "4";
        }
      },
      '5': {
        "action": () {
          userInput += "5";
        }
      },
      '6': {
        "action": () {
          userInput += "6";
        }
      },
      '—': {
        "action": () {
          if (userInput.isNotEmpty && !RegExp(r'\D$').hasMatch(userInput)) {
            userInput += "-";
          }
        },
        "textColor": Theme.of(context).primaryColor
      },
      '1': {
        "action": () {
          userInput += "1";
        }
      },
      '2': {
        "action": () {
          userInput += "2";
        }
      },
      '3': {
        "action": () {
          userInput += "3";
        }
      },
      '+': {
        "action": () {
          // var shit = RegExp(r'\D').allMatches(userInput);
          // for (var element in shit) {print(element.group(0));}
          if (userInput.isNotEmpty && !RegExp(r'\D$').hasMatch(userInput)) {
            userInput += "+";
          }
        },
        "textColor": Theme.of(context).primaryColor
      },
      "": {},
      '0': {
        "action": () {
          userInput += "0";
        }
      },
      '.': {
        "action": () {
          //TODO: finish dots regex
          if (userInput.isNotEmpty && !RegExp(r'\D$').hasMatch(userInput) && !RegExp(r'\d[.]\d').hasMatch(userInput)) {
            userInput += ".";
          }
        },
        "textColor": Theme.of(context).primaryColor
      },
      '=': {
        "action": () {
          if (userInput.isNotEmpty) calculate(userInput);
        },
        "color": Theme.of(context).primaryColor,
        "textColor": Colors.white,
      },
    };
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Container(
              padding: const EdgeInsets.all(15),
              alignment: Alignment.centerRight,
              child: Text(
                result,
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              alignment: Alignment.centerRight,
              child: Text(
                userInput,
                style: const TextStyle(fontSize: 18),
              ),
            )
          ]),
          GridView(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4),
            children: [
              for (var button in buttons.entries)
                CalcButton(
                  action: () {
                    setState(() {
                      button.value["action"]();
                    });
                  },
                  buttonText: button.key,
                  color: button.value["color"],
                  textColor: button.value["textColor"],
                )
            ],
          ),
        ],
      ),
    );
  }

  void calculate(String userInput) {
    userInput = userInput.replaceAll('x', '*');
    var exp = Parser().parse(userInput);
    var cm = ContextModel();
    var eval = exp.evaluate(EvaluationType.REAL, cm);
    result = eval.toString();
  }
}
