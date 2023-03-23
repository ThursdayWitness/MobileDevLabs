import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(const ProviderApp());

class Counter extends ChangeNotifier {
  var _count = 0;

  int get getCounter => _count;

  void incrementCounter() {
    _count++;
    notifyListeners();
  }
}

class ProviderApp extends StatelessWidget {
  const ProviderApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: Counter(),
        child: MaterialApp(
          title: "Provider Training",
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: const MyHomePage(title: "Provider Training"),
        ));
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  void _incrementCounter(BuildContext context) {
    Provider.of<Counter>(context, listen: false).incrementCounter();
  }

  @override
  Widget build(BuildContext context) {
    var counter = Provider.of<Counter>(context).getCounter;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _incrementCounter(context),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
