import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tuple/tuple.dart';
import 'dart:math';

void main() => runApp(const Lab2());

class Lab2 extends StatelessWidget {
  const Lab2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Lab2: «Квадратное уравнение»",
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var controllerA = TextEditingController();
  var controllerB = TextEditingController();
  var controllerC = TextEditingController();
  var x1Text = "x1 = ";
  var x2Text = "x2 = ";
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var isAlertVisible = false;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lab2: «Квадратное уравнение»"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 88,
                  child: TextFormField(
                      maxLengthEnforcement: MaxLengthEnforcement.none,
                      controller: controllerA,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        border: UnderlineInputBorder(),
                        hintText: 'a',
                      ),
                      validator: (String? value) {
                        if (isEmptyValidator(value) ||
                            isNan(value.toString())) {
                          return 'Введите число!';
                        }
                        return null;
                      }),
                ), // a
                const Text("x\u00b2 + "),
                SizedBox(
                  width: 88,
                  child: TextFormField(
                    controller: controllerB,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      border: UnderlineInputBorder(),
                      hintText: 'b',
                    ),
                    validator: (String? value) {
                      return (isEmptyValidator(value) ||
                              isNan(value.toString()))
                          ? 'Введите число!'
                          : null;
                    },
                  ),
                ),
                const Text("x + "),
                SizedBox(
                  width: 88,
                  child: TextFormField(
                    controller: controllerC,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      border: UnderlineInputBorder(),
                      hintText: 'c',
                    ),
                    validator: (String? value) {
                      return (isEmptyValidator(value) ||
                              isNan(value.toString()))
                          ? 'Введите число!'
                          : null;
                    },
                  ),
                ),
                const Text(" = 0"),
              ],
            ),
            Visibility(
              child: const Text(
                "Коэффициент а не может быть равен нулю!",
                style: TextStyle(color: Colors.red),
              ),
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              visible: isAlertVisible,
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  var result = calculate(
                      controllerA.text, controllerB.text, controllerC.text);
                  showDialog(
                      context: context,
                      builder: (context) {
                        var output = "";
                        var item1 = result.item1;
                        var item2 = result.item2;
                        if (item1.isNaN & item2.isNaN) {
                          return const Popup(
                              "Уравнение не имеет действительных корней.");
                        }
                        if (!item1.isNaN & item2.isNaN) {
                          return Popup("x1 = x2 = ${item1.toStringAsFixed(2)}");
                        }
                        if(item1.isNaN & !item2.isNaN)
                          {
                            return Popup("Уравнение является линейным.\nx = ${item2.toStringAsFixed(2)}");
                          }
                        if (!item1.isNaN) {
                          output += "x1 = ${item1.toStringAsFixed(2)}\n";
                        }
                        if (!item2.isNaN) {
                          output += "x2 = ${item2.toStringAsFixed(2)}";
                        }
                        if(item1.isInfinite || item2.isInfinite)
                          {
                            return const Popup("Уравнение верно при любых x");
                          }
                        return Popup(output);
                      });
                }
              },
              child: const Text("Решить"),
            ),
          ],
        ),
      ),
    );
  }
}

Tuple2<double, double> calculate(String aStr, String bStr, String cStr) {
  /*
  1 2 3
  1 2 -3
  1 -4 4
  1 0 -4
  0 1 2
  0 0 4
  0 0 0
  */
  var a = int.parse(aStr);
  var b = int.parse(bStr);
  var c = int.parse(cStr);
  //Case 0 : a = 0, x = -c/b
  if (a == 0) {
    if(b==0) {
      if(c==0) {
        return const Tuple2(double.negativeInfinity, double.infinity);
      }
      return const Tuple2(double.nan, double.nan);
    }
    return Tuple2(double.nan, (-1 * c) / b);
  }
  //Subcase 0.1: b = 0
  //Subcase 0.2 b != 0

  //Case 1: b=0, c!=0
  //Subcase 1.1: c>0
  if (b == 0 && (-1 * c * a) < 0) return const Tuple2(double.nan, double.nan);
  //Subcase 1.2: c<0
  if (b == 0 && (-1 * c * a) > 0) {
    return Tuple2(sqrt(-c / a), sqrt(-c / a) * -1);
  }
  //Case 2: c=0, b!=0
  if (b != 0 && c == 0) {
    return Tuple2(0.0, -c / a);
  }
  //Case3: b!=0, c!=0
  // D = b^2 - 4ac
  var D = b * b - 4 * a * c;
  //Subcase 3.1: D<0
  if (D < 0) return const Tuple2(double.nan, double.nan);
  //Subcase 3.2: D=0
  if (D == 0) return Tuple2(-b / (2 * a), double.nan);
  //Subcase 3.3: D>0
  // x1 = -b+sqrt(D) / 2a
  // x2 = -b-sqrt(D) / 2a
  var x1 = (-1 * b + sqrt(D)) / (2 * a);
  var x2 = (-1 * b - sqrt(D)) / (2 * a);
  return Tuple2(x1, x2);
}

bool isEmptyValidator(String? value) {
  if (value == null || value.isEmpty) {
    return true;
  }
  return false;
}

bool isZero(String value) {
  final number = int.parse(value);
  return number == 0;
}

bool isNan(String value) {
  return int.tryParse(value) == null;
}

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
