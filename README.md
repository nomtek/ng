![](https://github.com/nomtek/ng/workflows/Dart%20CI/badge.svg)

# NG

NG is a micro-framework for the UI layer architecture. Opinionated, minimalistic, Dart/Flutter oriented and built from real problems and real projects.

# Key components

In our approach there is a `NGView` and a `NGViewController`. `NGView` is, in most cases, a stateless representation of the screen. It is built from widgets and its responsibility is to define the layout. `NGViewController` owns all the data, both static (which won't be changed during whole screen lifecycle), and dynamic. Regarding the latter we have `NGValue` and `NG` widget (which are wrappers around Dart's `Stream` and `StreamBuilder`) that greatly reduce boilerplated code.

## NGValue + NG

`NGValue` reminds the `BehaviorSubject` from the RX. It holds an initial value, and exposes a stream which outputs all the subsequent updates to it. 
```dart
final counter = NGValue(0);
```

`NG` widget uses `NGValue` and a builder, which is fired each time the inner value of the `NGValue` changes.

```dart
NG(
    controller.counter,
    (int counterValue) => Text(
        '$counterValue',
        style: Theme.of(context).textTheme.headline4,
    ),
),
```

there are few additional types available, that extends `NGValue`:
- `NGDependentValue` - that computes its value based on other(s) `NGValue(s)`.
- `NGList`, `NGMap` and `NGSet` - those also implement the interface of corresponding collection, so all methods are available.

## NGView + NGViewController

`NGView` owns `NGViewController`, which should be injected in the constructor. `NGViewController` has a `BuildContext` property available, so you can use `Navigator`, `showDialog` or other context-dependent methods from your business logic class. There are also two methods available for override:

```dart
void onReady() async {}
void onClose() async {}
```

which allows you to eg. fetch network resources when the screen appears and clean disposable instances when it is removed from stack.

Check Example to see those four types in action!

# Extras

## Other state management solutions

There are obviously other, well written and actively maintained solutions. Due to not being completely satisfied with those we tested, NG was born. Those may suit other kind of projects - different work requires different tools. Biggest problems with the ones we tested were:

- overloaded API and plenty of entities required even for simple screens
- tight coupling in all-in-one solutions
- unstable API between versions
- 'everything is a widget' approach

## our stack

core:

* NG - for UI layer architecture (aka state management)
* DIO (for networking)
* getIt (for Dependency Injection and singleton cases)
* intl (for translations support)

more packages added as needed, eg. to support SVG, Local DB, Opening links, Analytics etc.

all the above doesn't overlap each other and have well-definied responsibilities.
