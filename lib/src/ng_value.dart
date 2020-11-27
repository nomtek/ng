import 'dart:async';

import 'dart:math';

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
///
///

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
  NGDependencyMapper1<T, V1> _mapper;

  NGDependentValue(this._dependency1, this._mapper)
      : super(_mapper(_dependency1.value), [_dependency1]);

  @override
  void updateValue() => value = _mapper(_dependency1.value);
}

typedef T NGDependencyMapper2<T, V1, V2>(V1 val1, V2 val2);

class NGDependentValue2<T, V1, V2> extends NGDependentValueBase<T> {
  NGValue<V1> _dependency1;
  NGValue<V2> _dependency2;
  NGDependencyMapper2<T, V1, V2> _mapper;

  NGDependentValue2(this._dependency1, this._dependency2, this._mapper)
      : super(_mapper(_dependency1.value, _dependency2.value), [_dependency1, _dependency2]);

  @override
  void updateValue() => value = _mapper(_dependency1.value, _dependency2.value);
}

typedef T NGDependencyMapper3<T, V1, V2, V3>(V1 val1, V2 val2, V3 val3);

class NGDependentValue3<T, V1, V2, V3> extends NGDependentValueBase<T> {
  NGValue<V1> _dependency1;
  NGValue<V2> _dependency2;
  NGValue<V3> _dependency3;
  NGDependencyMapper3<T, V1, V2, V3> _mapper;

  NGDependentValue3(this._dependency1, this._dependency2, this._dependency3, this._mapper)
      : super(_mapper(_dependency1.value, _dependency2.value, _dependency3.value),
            [_dependency1, _dependency2, _dependency3]);

  @override
  void updateValue() => value = _mapper(_dependency1.value, _dependency2.value, _dependency3.value);
}

/// NGList
///
///

class NGList<T> extends NGValue<List<T>> implements List<T> {
  NGList(List<T> value) : super(value);

  @override
  T get first => value.first;

  @override
  T get last => value.last;

  @override
  int get length => value.length;

  @override
  List<T> operator +(List<T> other) => value + other;

  @override
  T operator [](int index) => value[index];

  @override
  void operator []=(int index, T value) {
    super.value[index] = value;
    super._valueStreamController.sink.add(super.value);
  }

  @override
  void add(T value) {
    super.value.add(value);
    super._valueStreamController.sink.add(super.value);
  }

  @override
  void addAll(Iterable<T> iterable) {
    super.value.addAll(iterable);
    super._valueStreamController.sink.add(super.value);
  }

  @override
  Map<int, T> asMap() => value.asMap();

  @override
  List<R> cast<R>() => value.cast();

  @override
  void clear() {
    super.value.clear();
    super._valueStreamController.sink.add(super.value);
  }

  @override
  bool contains(Object element) => value.contains(element);

  @override
  T elementAt(int index) => value.elementAt(index);

  @override
  void fillRange(int start, int end, [T fillValue]) {
    super.value.fillRange(start, end, fillValue);
    super._valueStreamController.sink.add(super.value);
  }

  @override
  Iterable<T> followedBy(Iterable<T> other) => value.followedBy(other);

  @override
  Iterable<T> getRange(int start, int end) => value.getRange(start, end);

  @override
  int indexOf(T element, [int start = 0]) => value.indexOf(element, start);

  @override
  void insert(int index, T element) {
    super.value.insert(index, element);
    super._valueStreamController.sink.add(super.value);
  }

  @override
  void insertAll(int index, Iterable<T> iterable) {
    super.value.insertAll(index, iterable);
    super._valueStreamController.sink.add(super.value);
  }

  @override
  bool get isEmpty => value.isEmpty;

  @override
  bool get isNotEmpty => value.isNotEmpty;

  @override
  Iterator<T> get iterator => value.iterator;

  @override
  String join([String separator = ""]) => value.join(separator);

  @override
  int lastIndexOf(T element, [int start]) => value.lastIndexOf(element, start);

  @override
  bool remove(Object value) {
    final result = super.value.remove(value);
    if (result == true) super._valueStreamController.sink.add(super.value);
    return result;
  }

  @override
  T removeAt(int index) {
    final result = super.value.removeAt(index);
    super._valueStreamController.sink.add(super.value);
    return result;
  }

  @override
  T removeLast() {
    final result = super.value.removeLast();
    super._valueStreamController.sink.add(super.value);
    return result;
  }

  @override
  void removeRange(int start, int end) {
    super.value.removeRange(start, end);
    super._valueStreamController.sink.add(super.value);
  }

  @override
  void replaceRange(int start, int end, Iterable<T> replacement) {
    super.value.replaceRange(start, end, replacement);
    super._valueStreamController.sink.add(super.value);
  }

  @override
  Iterable<T> get reversed => value.reversed;

  @override
  void setAll(int index, Iterable<T> iterable) {
    super.value.setAll(index, iterable);
    super._valueStreamController.sink.add(super.value);
  }

  @override
  void setRange(int start, int end, Iterable<T> iterable, [int skipCount = 0]) {
    super.value.setRange(start, end, iterable, skipCount);
    super._valueStreamController.sink.add(super.value);
  }

  @override
  void shuffle([Random random]) {
    super.value.shuffle(random);
    super._valueStreamController.sink.add(super.value);
  }

  @override
  T get single => value.single;

  @override
  Iterable<T> skip(int count) => value.skip(count);

  @override
  List<T> sublist(int start, [int end]) => value.sublist(start, end);

  @override
  Iterable<T> take(int count) => value.take(count);

  @override
  List<T> toList({bool growable = true}) => value.toList(growable: growable);

  @override
  Set<T> toSet() => value.toSet();

  @override
  Iterable<T> whereType<T>() => value.whereType();

  @override
  bool any(bool test(T element)) => value.any(test);

  @override
  bool every(bool test(T element)) => value.every(test);

  @override
  Iterable<V> expand<V>(Iterable<V> f(T element)) => value.expand(f);

  @override
  T firstWhere(bool test(T element), {T orElse()}) => value.firstWhere(test, orElse: orElse);

  @override
  set first(T value) {
    super.value.first = value;
    super._valueStreamController.sink.add(super.value);
  }

  @override
  V fold<V>(V initialValue, V Function(V previousValue, T element) combine) =>
      super.value.fold(initialValue, combine);

  @override
  void forEach(void Function(T element) f) => super.value.forEach(f);

  @override
  int indexWhere(bool Function(T element) test, [int start = 0]) =>
      super.value.indexWhere(test, start);

  @override
  set last(T value) {
    super.value.last = value;
    super._valueStreamController.sink.add(super.value);
  }

  @override
  int lastIndexWhere(bool Function(T element) test, [int start]) =>
      super.value.lastIndexWhere(test, start);

  @override
  T lastWhere(bool Function(T element) test, {T Function() orElse}) =>
      super.value.lastWhere(test, orElse: orElse);

  @override
  set length(int newLength) {
    super.value.length = newLength;
    super._valueStreamController.sink.add(super.value);
  }

  @override
  Iterable<V> map<V>(V Function(T e) f) => super.value.map(f);

  @override
  T reduce(T Function(T value, T element) combine) => super.value.reduce(combine);

  @override
  void removeWhere(bool Function(T element) test) {
    super.value.removeWhere(test);
    super._valueStreamController.sink.add(super.value);
  }

  @override
  void retainWhere(bool Function(T element) test) {
    super.value.removeWhere(test);
    super._valueStreamController.sink.add(super.value);
  }

  @override
  T singleWhere(bool Function(T element) test, {T Function() orElse}) =>
      super.value.singleWhere(test, orElse: orElse);

  @override
  Iterable<T> skipWhile(bool Function(T value) test) => super.value.skipWhile(test);

  @override
  void sort([int Function(T a, T b) compare]) {
    super.value.sort(compare);
    super._valueStreamController.sink.add(super.value);
  }

  @override
  Iterable<T> takeWhile(bool Function(T value) test) => super.value.takeWhile(test);

  @override
  Iterable<T> where(bool Function(T element) test) => super.value.where(test);
}
