import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_flutter_demo/MyNavi.dart';
import 'package:my_flutter_demo/SecondPage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'third_libs/riverpod_test/data_repository/data_from_net.dart';

part 'main.g.dart';

@riverpod
String hellWorld(Ref ref) {
  return "hello world";
}

@riverpod
DataRepository getMyDataList(Ref ref) {
  return DataRepository();
}

void main() {
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String value = ref.watch(hellWorldProvider);
    return MaterialApp(
        title: value,
        theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true),
        home: const MyHomePage(title: 'Flutter Demo Home Page'));
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  int _counter = 0;
  List<MyRiverData>? dataSet;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void onPressed() {
    List<MyRiverData> tmp = ref.read(getMyDataListProvider).getDataList();
    print("tmp object=$tmp");
    setState(() {
      dataSet = tmp;
    });
  }

  @override
  Widget build(BuildContext context) {
    var list2 = <Widget>[
      const Text('You have pushed the button this many times:'),
      Text('$_counter', style: Theme.of(context).textTheme.headlineMedium),
    ];
    var list = dataSet?.map((item) => Text("${item.name} ${item.address} ${item.sex}")).toList();
    list2.addAll(list ?? []);
    return Scaffold(
        appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: Text(widget.title)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(mainAxisAlignment: MainAxisAlignment.center, children: list2),
              ElevatedButton(
                onPressed: onPressed,
                style: const ButtonStyle(),
                child: const Text("pullData"),
              ),
              ElevatedButton(onPressed: jumpToSecond, child: const Text("Navi to second page"))

            ],
          ),
        ),
        floatingActionButton:
            FloatingActionButton(onPressed: _incrementCounter, tooltip: 'Increment', child: const Icon(Icons.add)));
  }

  void jumpToSecond() {
    MyNavi.navigateTo(context, const SecondPage());
  }
}
