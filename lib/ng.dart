library ng;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class NGViewController {
  BuildContext context;

  void onReady() async {}

  void onClose() async {}
}

abstract class NGView<C extends NGViewController> extends StatefulWidget {
  final C controller;

  const NGView({Key key, this.controller}) : super(key: key);

  Widget build(BuildContext context);

  @override
  _NGViewState<C> createState() => _NGViewState<C>();
}

class _NGViewState<C extends NGViewController> extends State<NGView<C>> {
  @override
  void initState() {
    SchedulerBinding.instance?.addPostFrameCallback((_) => widget.controller?.onReady());
    super.initState();
  }

  @override
  void dispose() {
    widget.controller?.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.controller?.context = context;
    return widget.build(context);
  }
}

class NGValue<T> {
  T _value;

  T get value => _value;

  set value(T newValue) {
    _value = newValue;
    _valueStreamController.sink.add(newValue);
  }

  final StreamController<T> _valueStreamController = StreamController<T>.broadcast();

  Stream<T> get stream => _valueStreamController.stream;

  NGValue(this._value);

  void dispose() {
    _valueStreamController.close();
  }
}

// name?
//
// NGIndirectValue
// NGDependentValue
// NGComputedValue

abstract class NGDependentValueBase<T> extends NGValue<T> {
  List<StreamSubscription> _subscriptions = [];

  NGDependentValueBase(T val, List<NGValue> dependencies) : super(val) {
    dependencies.forEach((dependency) {
      _subscriptions.add(dependency.stream.listen((_) => updateValue()));
    });
  }

  void updateValue();

  @override
  void dispose() {
    super.dispose();

    _subscriptions?.forEach((subscription) {
      subscription.cancel();
    });
  }
}

typedef T NGDependencyMapper1<T, V1>(V1 val1);

class NGDependentValue<T, V1> extends NGDependentValueBase<T> {
  NGValue<V1> _dependency1;
  NGDependencyMapper1 _mapper;

  NGDependentValue(this._dependency1, this._mapper)
      : super(_mapper(_dependency1.value), [_dependency1]);

  @override
  void updateValue() => value = _mapper(_dependency1.value);
}

typedef T NGDependencyMapper2<T, V1, V2>(V1 val1, V2 val2);

class NGDependentValue2<T, V1, V2> extends NGDependentValueBase<T> {
  NGValue<V1> _dependency1;
  NGValue<V2> _dependency2;
  NGDependencyMapper2 _mapper;

  NGDependentValue2(this._dependency1, this._dependency2, this._mapper)
      : super(_mapper(_dependency1.value, _dependency2.value), [_dependency1, _dependency2]);

  @override
  void updateValue() => value = _mapper(_dependency1.value, _dependency2.value);
}

// *****

abstract class NGValueBase<T> {
  T _value;

  T get value => _value;

  set value(T newValue) {
    _value = newValue;
    _valueStreamController.sink.add(newValue);
  }

  final StreamController<T> _valueStreamController = StreamController<T>.broadcast();

  Stream<T> get stream => _valueStreamController.stream;

  void dispose() {
    _valueStreamController.close();
  }
}

class NGSimpleValue<T> extends NGValueBase<T> {
  NGSimpleValue(T initValue) {
    value = initValue;
  }
}

abstract class NGIndirectValueBase<T> extends NGValueBase<T> {
  List<StreamSubscription> _subscriptions = [];

  NGIndirectValueBase() {
    updateValue();
  }

  void _subscribe(NGValueBase dependency) {
    _subscriptions.add(dependency.stream.listen((_) {
      updateValue();
    }));
  }

  void updateValue();

  void dispose() {
    super.dispose();
    _subscriptions?.forEach((subscription) {
      subscription.cancel();
    });
  }
}

typedef T NGIndirectValueMapper1<T, T1>(T1 t1);

class NGIndirectValue1<T, T1> extends NGIndirectValueBase<T> {
  NGValueBase<T1> _dependency1;
  NGIndirectValueMapper1<T, T1> _mapper;

  NGIndirectValue1(this._dependency1, this._mapper) {
    _subscribe(_dependency1);
  }

  @override
  void updateValue() {
    value = _mapper(_dependency1.value);
  }
}

typedef T NGIndirectValueMapper2<T, T1, T2>(T1 t1, T2 t2);

class NGIndirectValue2<T, T1, T2> extends NGIndirectValueBase<T> {
  NGValueBase<T1> _dependency1;
  NGValueBase<T2> _dependency2;
  NGIndirectValueMapper2<T, T1, T2> _mapper;

  NGIndirectValue2(this._dependency1, this._dependency2, this._mapper) {
    _subscribe(_dependency1);
    _subscribe(_dependency2);
  }

  @override
  void updateValue() {
    value = _mapper(_dependency1.value, _dependency2.value);
  }
}

typedef T NGIndirectValueMapper3<T, T1, T2, T3>(T1 t1, T2 t2, T3 t3);

class NGIndirectValue3<T, T1, T2, T3> extends NGIndirectValueBase<T> {
  NGValueBase<T1> _dependency1;
  NGValueBase<T2> _dependency2;
  NGValueBase<T3> _dependency3;
  NGIndirectValueMapper3<T, T1, T2, T3> _mapper;

  NGIndirectValue3(this._dependency1, this._dependency2, this._dependency3, this._mapper) {
    _subscribe(_dependency1);
    _subscribe(_dependency2);
    _subscribe(_dependency3);
  }

  @override
  void updateValue() {
    value = _mapper(_dependency1.value, _dependency2.value, _dependency3.value);
  }
}

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
