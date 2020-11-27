import 'package:flutter/widgets.dart';
import 'package:ng/src/ng_value.dart';

class NG<T> extends StatelessWidget {
  final NGValue<T> ngValue;
  final Widget Function(T value) builder;

  const NG(this.ngValue, this.builder, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      initialData: ngValue.value,
      stream: ngValue.stream,
      builder: (context, snapshot) => builder(snapshot.data),
    );
  }
}