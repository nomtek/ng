import 'package:flutter/material.dart';
import 'package:ng/ng.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NG Demo',
      home: CounterScreen(controller: CounterController()),
    );
  }
}

class CounterScreen extends NGView<CounterController> {
  CounterScreen({Key key, CounterController controller}) : super(controller: controller, key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            NG(
              controller.counter,
              (int counterValue) => Text(
                '$counterValue',
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.increment,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class CounterController extends NGViewController {
  final counter = NGValue(0);

  void increment() => counter.value++;
}
