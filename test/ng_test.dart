import 'package:flutter_test/flutter_test.dart';

import 'package:ng/ng.dart';

void main() {
  test('listen for one value', () async {
    NGValueBase<int> index = NGSimpleValue(4);
    NGIndirectValue1<String, int> label =
        NGIndirectValue1(index, (index) => "Current Index: $index");
    expect(label.value, "Current Index: 4");
    index.value = 3;

    await Future.delayed(Duration.zero);

    expect(label.value, "Current Index: 3");
  });

  test('listen for one value alternative implementation', () async {
    final index = NGValue(4);
    final label = NGDependentValue(index, (index) => "Current Index: $index");
    expect(label.value, "Current Index: 4");
    index.value = 3;

    await Future.delayed(Duration.zero);

    expect(label.value, "Current Index: 3");
  });

  test('listen for two values', () async {
    NGValueBase<int> index = NGSimpleValue(4);
    NGValueBase<int> index2 = NGSimpleValue(100);
    NGIndirectValue2<String, int, int> label = NGIndirectValue2(
        index, index2, (index, index2) => "Current Index: $index but second $index2");
    expect(label.value, "Current Index: 4 but second 100");
    index.value = 3;

    await Future.delayed(Duration.zero);

    expect(label.value, "Current Index: 3 but second 100");

    index2.value = 300;

    await Future.delayed(Duration.zero);

    expect(label.value, "Current Index: 3 but second 300");
  });

  test('listen for two values alternative implementation', () async {
    final index = NGValue(4);
    final index2 = NGValue(100);
    final label = NGDependentValue2(index, index2, (index, index2) => "Current Index: $index but second $index2");
    
    expect(label.value, "Current Index: 4 but second 100");
    index.value = 3;

    await Future.delayed(Duration.zero);

    expect(label.value, "Current Index: 3 but second 100");

    index2.value = 300;

    await Future.delayed(Duration.zero);

    expect(label.value, "Current Index: 3 but second 300");
  });

  test('listen for three values', () async {
    NGValueBase<int> index = NGSimpleValue(4);
    NGValueBase<int> index2 = NGSimpleValue(100);
    NGValueBase<String> name = NGSimpleValue("Peter");
    NGIndirectValue3<String, int, int, String> label = NGIndirectValue3(index, index2, name,
        (index, index2, name) => "Name: $name Current Index: $index but second $index2");
    expect(label.value, "Name: Peter Current Index: 4 but second 100");
    index.value = 3;
    index2.value = 0;
    name.value = "Dan";
    await Future.delayed(Duration.zero);

    expect(label.value, "Name: Dan Current Index: 3 but second 0");
  });
}
