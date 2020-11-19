import 'dart:async';

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

/// Dependent Values

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

typedef T NGDependencyMapper3<T, V1, V2, V3>(V1 val1, V2 val2, V3 val3);

class NGDependentValue3<T, V1, V2> extends NGDependentValueBase<T> {
  NGValue<V1> _dependency1;
  NGValue<V2> _dependency2;
  NGValue<V2> _dependency3;
  NGDependencyMapper3 _mapper;

  NGDependentValue3(this._dependency1, this._dependency2, this._dependency3, this._mapper)
      : super(_mapper(_dependency1.value, _dependency2.value, _dependency3.value),
            [_dependency1, _dependency2, _dependency3]);

  @override
  void updateValue() => value = _mapper(_dependency1.value, _dependency2.value, _dependency3.value);
}
