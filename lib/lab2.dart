import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'dart:math';
import 'lab2_popup.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
                      controller: controllerA,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        border: UnderlineInputBorder(),
                        hintText: 'a',
                      ),
                      validator: (String? value) {
                        if (isEmptyValidator(value) || isNan(value.toString())) return 'Введите число!';
                        return (isZero(value.toString())) ? 'a\u22600 !' : null;
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
                      return (isEmptyValidator(value) || isNan(value.toString()))
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
                      return (isEmptyValidator(value) || isNan(value.toString()))
                          ? 'Введите число!'
                          : null;
                    },
                  ),
                ),
                const Text(" = 0"),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  var result = calculate(
                      controllerA.text, controllerB.text, controllerC.text);
                  showDialog(
                    context: context,
                    builder: (context){
                      var output = "";
                      if(result.item1.isNaN & result.item2.isNaN) return const Popup("Уравнение не имеет действительных корней.");
                      if(!result.item1.isNaN) output += "x1 = ${result.item1}\n";
                      if(!result.item2.isNaN) output += "x2 = ${result.item2}";
                      return Popup(output);
                    }
                  );
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

  //Case 1: b=0, c!=0
    //Subcase 1.1: c>0
  if(b==0 && (-1*c*a)<0) return const Tuple2(double.nan, double.nan);
    //Subcase 1.2: c<0
  if(b==0 && (-1*c*a)>0)
    {
      return Tuple2(sqrt(-c/a), sqrt(-c/a)*-1);
    }
  //Case 2: c=0, b!=0
  if(b!=0 && c==0)
    {
      return Tuple2(0.0, -c/a);
    }
  //Case3: b!=0, c!=0
  // D = b^2 - 4ac
  var D = b * b - 4 * a * c;
    //Subcase 3.1: D<0
  if(D<0) return const Tuple2(double.nan, double.nan);
    //Subcase 3.2: D=0
  if(D==0) return Tuple2(-b/(2*a), double.nan);
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