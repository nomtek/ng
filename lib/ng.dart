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
