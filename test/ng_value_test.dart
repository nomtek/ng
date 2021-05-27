import 'package:flutter_test/flutter_test.dart';

import 'package:ng/ng.dart';

void main() {
  test('listen for one value', () async {
    final index = NGValue(4);
    final label = NGDependentValue(index, (dynamic index) => "Current Index: $index");
    expect(label.value, "Current Index: 4");
    index.value = 3;

    await Future.delayed(Duration.zero);

    expect(label.value, "Current Index: 3");
  });

  test('listen for two values', () async {
    final index = NGValue(4);
    final index2 = NGValue(100);
    final label = NGDependentValue2(index, index2,
        (dynamic index, dynamic index2) => "Current Index: $index but second $index2");

    expect(label.value, "Current Index: 4 but second 100");
    index.value = 3;

    await Future.delayed(Duration.zero);

    expect(label.value, "Current Index: 3 but second 100");

    index2.value = 300;

    await Future.delayed(Duration.zero);

    expect(label.value, "Current Index: 3 but second 300");
  });

  test('listen for three values', () async {
    final index = NGValue(4);
    final index2 = NGValue(100);
    final name = NGValue('Peter');
    final label = NGDependentValue3(
        index,
        index2,
        name,
        (dynamic index, dynamic index2, dynamic name) =>
            "Name: $name Current Index: $index but second $index2");

    expect(label.value, "Name: Peter Current Index: 4 but second 100");

    index.value = 3;
    index2.value = 0;
    name.value = "Dan";
    await Future.delayed(Duration.zero);

    expect(label.value, "Name: Dan Current Index: 3 but second 0");
  });

  test('NGList basic', () async {
    final ngList = NGList([1]);

    expect(ngList[0], 1);

    ngList.add(2);
    await Future.delayed(Duration.zero);

    expect(ngList.length, 2);
    expect(ngList[1], 2);

    ngList.removeWhere((e) => e % 2 == 0);
    await Future.delayed(Duration.zero);

    expect(ngList.length, 1);
    expect(ngList[0], 1);
  });

  test('NGList + NGDependentValue', () async {
    final ngList = NGList([1, 2]);
    final label = NGDependentValue(
        ngList, (List<int> list) => "Sum: ${list.fold(0, (dynamic prev, elem) => prev + elem)}");
    expect(label.value, "Sum: 3");

    ngList.add(3);
    await Future.delayed(Duration.zero);

    expect(label.value, "Sum: 6");

    ngList.removeWhere((e) => e % 2 == 0);
    await Future.delayed(Duration.zero);

    expect(label.value, "Sum: 4");
  });

  test('NGList retain where', () async {
    final ngList = NGList([1, 2]);

    ngList.retainWhere((e) => e % 2 == 0);
    await Future.delayed(Duration.zero);

    expect(ngList.length, 1);
    expect(ngList[0], 2);
  });

  test('NGMap basic', () async {
    final ngMap = NGMap({"1": 2});

    expect(ngMap["1"], 2);

    ngMap["3"] = 20;
    await Future.delayed(Duration.zero);

    expect(ngMap.length, 2);
    expect(ngMap["3"], 20);

    ngMap.removeWhere((key, value) => key == "3");
    await Future.delayed(Duration.zero);

    expect(ngMap.length, 1);
    expect(ngMap["1"], 2);
    expect(ngMap["3"], null);
  });

  test('NGMap + NGDependentValue', () async {
    final ngMap = NGMap({"name": "Bob", "surname": "Fox"});
    final label = NGDependentValue(
        ngMap, (Map<String, String> map) => "My name is ${map["name"]} ${map["surname"]}");
    expect(label.value, "My name is Bob Fox");

    ngMap["surname"] = "Chicken";
    await Future.delayed(Duration.zero);

    expect(label.value, "My name is Bob Chicken");

    ngMap.removeWhere((key, value) => key == "surname");
    await Future.delayed(Duration.zero);

    expect(label.value, "My name is Bob null");
  });

  test('NGSet basic', () async {
    final ngSet = NGSet({1});

    expect(ngSet.first, 1);

    ngSet.add(2);
    await Future.delayed(Duration.zero);

    expect(ngSet.length, 2);
    expect(ngSet.last, 2);

    ngSet.removeWhere((e) => e % 2 == 0);
    await Future.delayed(Duration.zero);

    expect(ngSet.length, 1);
    expect(ngSet.first, 1);
  });

  test('NGSet + NGDependentValue', () async {
    final ngSet = NGSet({1, 2});
    final label = NGDependentValue(
        ngSet, (Set<int> set) => "Sum: ${set.fold(0, (dynamic prev, elem) => prev + elem)}");
    expect(label.value, "Sum: 3");

    ngSet.add(3);
    await Future.delayed(Duration.zero);

    expect(label.value, "Sum: 6");

    ngSet.add(3);
    await Future.delayed(Duration.zero);

    expect(label.value, "Sum: 6");

    ngSet.removeWhere((e) => e % 2 == 0);
    await Future.delayed(Duration.zero);

    expect(label.value, "Sum: 4");
  });
}
