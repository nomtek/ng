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

class NG2<T1, T2> extends StatefulWidget {
  final NGValue<T1> value1;
  final NGValue<T2> value2;
  final Widget Function(T1 value1, T2 value2) builder;

  NG2(this.value1, this.value2, this.builder);

  @override
  _NG2State createState() => _NG2State<T1, T2>(NGDependentValue2<_Tuple2<T1, T2>, T1, T2>(
      value1, value2, (T1 v1, T2 v2) => _Tuple2(v1, v2)));
}

class _NG2State<T1, T2> extends State<NG2<T1, T2>> {
  final NGDependentValue2<_Tuple2, T1, T2> _value;

  _NG2State(this._value);

  @override
  Widget build(BuildContext context) {
    return NG(_value, (_Tuple2 result) {
      return widget.builder(result.value1, result.value2);
    });
  }

  @override
  void dispose() {
    _value.dispose();
    super.dispose();
  }
}

class _Tuple2<T1, T2> {
  final T1 value1;
  final T2 value2;

  _Tuple2(this.value1, this.value2);
}
