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

// TOOD: add 4 & 5

class NGDependentValue6<T, V1, V2, V3, V4, V5, V6> extends NGDependentValueBase<T> {
  NGValue<V1> _dependency1;
  NGValue<V2> _dependency2;
  NGValue<V3> _dependency3;
  NGValue<V4> _dependency4;
  NGValue<V5> _dependency5;
  NGValue<V6> _dependency6;

  NGDependencyMapper6<T, V1, V2, V3, V4, V5, V6> _mapper;

  NGDependentValue6(this._dependency1, this._dependency2, this._dependency3, this._dependency4,
      this._dependency5, this._dependency6, this._mapper)
      : super(
            _mapper(
              _dependency1.value,
              _dependency2.value,
              _dependency3.value,
              _dependency4.value,
              _dependency5.value,
              _dependency6.value,
            ),
            [_dependency1, _dependency2, _dependency3, _dependency4, _dependency5, _dependency6]);

  @override
  void updateValue() => value = _mapper(
        _dependency1.value,
        _dependency2.value,
        _dependency3.value,
        _dependency4.value,
        _dependency5.value,
        _dependency6.value,
      );
}

typedef T NGDependencyMapper6<T, V1, V2, V3, V4, V5, V6>(
    V1 val1, V2 val2, V3 val3, V4 val4, V5 val5, V6 val6);

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
    super.value.retainWhere(test);
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

/// NGMap
///
///

class NGMap<K, V> extends NGValue<Map<K, V>> implements Map<K, V> {
  NGMap(Map<K, V> value) : super(value);

  @override
  V operator [](Object key) {
    return value[key];
  }

  @override
  void operator []=(K key, V value) {
    super.value[key] = value;
    super._valueStreamController.sink.add(super.value);
  }

  @override
  void addAll(Map<K, V> other) {
    super.value.addAll(other);
    super._valueStreamController.sink.add(super.value);
  }

  @override
  void addEntries(Iterable<MapEntry<K, V>> newEntries) {
    super.value.addEntries(newEntries);
    super._valueStreamController.sink.add(super.value);
  }

  @override
  Map<RK, RV> cast<RK, RV>() => super.value.cast();

  @override
  void clear() {
    super.value.clear();
    super._valueStreamController.sink.add(super.value);
  }

  @override
  bool containsKey(Object key) => value.containsKey(key);

  @override
  bool containsValue(Object value) => super.value.containsValue(value);

  @override
  Iterable<MapEntry<K, V>> get entries => super.value.entries;

  @override
  void forEach(void Function(K key, V value) f) => super.value.forEach(f);

  @override
  bool get isEmpty => super.value.isEmpty;

  @override
  bool get isNotEmpty => super.value.isNotEmpty;

  @override
  Iterable<K> get keys => super.value.keys;

  @override
  int get length => super.value.length;

  @override
  Map<K2, V2> map<K2, V2>(MapEntry<K2, V2> Function(K key, V value) f) => super.value.map(f);

  @override
  V putIfAbsent(K key, V Function() ifAbsent) {
    final contains = containsKey(key);
    final result = super.value.putIfAbsent(key, ifAbsent);
    if (!contains) super._valueStreamController.sink.add(super.value);
    return result;
  }

  @override
  V remove(Object key) {
    final result = super.value.remove(value);
    if (result != null) super._valueStreamController.sink.add(super.value);
    return result;
  }

  @override
  void removeWhere(bool Function(K key, V value) predicate) {
    final oldLength = super.value.length;
    super.value.removeWhere(predicate);
    if (oldLength != super.value.length) super._valueStreamController.sink.add(super.value);
  }

  @override
  V update(K key, V Function(V value) update, {V Function() ifAbsent}) {
    final result = super.value.update(key, update, ifAbsent: ifAbsent);
    super._valueStreamController.sink.add(super.value);
    return result;
  }

  @override
  void updateAll(V Function(K key, V value) update) {
    super.value.updateAll(update);
    super._valueStreamController.sink.add(super.value);
  }

  @override
  Iterable<V> get values => super.value.values;
}

/// NGSet
///
///

class NGSet<E> extends NGValue<Set<E>> implements Set<E> {
  NGSet(Set<E> value) : super(value);

  @override
  bool add(E value) {
    final result = super.value.add(value);
    if (result == true) super._valueStreamController.sink.add(super.value);
    return result;
  }

  @override
  void addAll(Iterable<E> iterable) {
    super.value.addAll(iterable);
    super._valueStreamController.sink.add(super.value);
  }

  @override
  bool any(bool test(E element)) => super.value.any(test);

  @override
  Set<R> cast<R>() => value.cast();

  @override
  void clear() {
    super.value.clear();
    super._valueStreamController.sink.add(super.value);
  }

  @override
  bool contains(Object element) => super.value.contains(element);

  @override
  bool containsAll(Iterable<Object> other) => super.value.containsAll(other);

  @override
  Set<E> difference(Set<Object> other) => super.value.difference(other);

  @override
  E elementAt(int index) => value.elementAt(index);

  @override
  bool every(bool test(E element)) => super.value.every(test);

  @override
  Iterable<T> expand<T>(Iterable<T> f(E element)) => super.value.expand(f);

  @override
  E get first => super.value.first;

  @override
  E firstWhere(bool test(E element), {E orElse()}) => super.value.firstWhere(test, orElse: orElse);

  @override
  T fold<T>(T initialValue, T Function(T previousValue, E element) combine) =>
      super.value.fold(initialValue, combine);

  @override
  Iterable<E> followedBy(Iterable<E> other) => super.value.followedBy(other);

  @override
  void forEach(void Function(E element) f) => super.value.forEach(f);

  @override
  Set<E> intersection(Set<Object> other) => super.value.intersection(other);

  @override
  bool get isEmpty => super.value.isEmpty;

  @override
  bool get isNotEmpty => super.value.isNotEmpty;

  @override
  Iterator<E> get iterator => super.value.iterator;

  @override
  String join([String separator = ""]) => super.value.join(separator);

  @override
  E get last => super.value.last;

  @override
  E lastWhere(bool Function(E element) test, {E Function() orElse}) =>
      super.value.lastWhere(test, orElse: orElse);

  @override
  int get length => super.value.length;

  @override
  E lookup(Object object) => super.value.lookup(object);

  @override
  Iterable<T> map<T>(T Function(E e) f) => super.value.map(f);

  @override
  E reduce(Function(E value, E element) combine) => super.value.reduce(combine);

  @override
  bool remove(Object value) {
    final result = super.value.remove(value);
    if (result == true) super._valueStreamController.sink.add(super.value);
    return result;
  }

  @override
  void removeAll(Iterable<Object> elements) {
    super.value.removeAll(value);
    super._valueStreamController.sink.add(super.value);
  }

  @override
  void removeWhere(bool Function(E element) test) {
    super.value.removeWhere(test);
    super._valueStreamController.sink.add(super.value);
  }

  @override
  void retainAll(Iterable<Object> elements) {
    super.value.retainAll(elements);
    super._valueStreamController.sink.add(super.value);
  }

  @override
  void retainWhere(bool Function(E element) test) {
    super.value.retainWhere(test);
    super._valueStreamController.sink.add(super.value);
  }

  @override
  E get single => super.value.single;

  @override
  E singleWhere(bool Function(E element) test, {Function() orElse}) =>
      singleWhere(test, orElse: orElse);

  @override
  Iterable<E> skip(int count) => super.value.skip(count);

  @override
  Iterable<E> skipWhile(bool Function(E value) test) => super.value.skipWhile(test);

  @override
  Iterable<E> take(int count) => super.value.take(count);

  @override
  Iterable<E> takeWhile(bool Function(E value) test) => super.value.takeWhile(test);

  @override
  List<E> toList({bool growable = true}) => super.value.toList(growable: growable);

  @override
  Set<E> toSet() => super.value.toSet();

  @override
  Set<E> union(Set other) => super.value.union(other);

  @override
  Iterable<E> where(bool Function(E element) test) => super.value.where(test);

  @override
  Iterable<T> whereType<T>() => super.value.whereType<T>();
}
