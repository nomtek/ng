import 'package:flutter_test/flutter_test.dart';

import 'package:ng/ng.dart';

void main() {
  test('listen for one value', () async {
    final index = NGValue(4);
    final label = NGDependentValue(index, (index) => "Current Index: $index");
    expect(label.value, "Current Index: 4");
    index.value = 3;

    await Future.delayed(Duration.zero);

    expect(label.value, "Current Index: 3");
  });

  test('listen for two values', () async {
    final index = NGValue(4);
    final index2 = NGValue(100);
    final label = NGDependentValue2(
        index, index2, (index, index2) => "Current Index: $index but second $index2");

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
    final label = NGDependentValue3(index, index2, name,
        (index, index2, name) => "Name: $name Current Index: $index but second $index2");

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
        ngList, (List<int> list) => "Sum: ${list.fold(0, (prev, elem) => prev + elem)}");
    expect(label.value, "Sum: 3");

    ngList.add(3);
    await Future.delayed(Duration.zero);

    expect(label.value, "Sum: 6");

    ngList.removeWhere((e) => e % 2 == 0);
    await Future.delayed(Duration.zero);

    expect(label.value, "Sum: 4");
  });
}
