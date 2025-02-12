import 'package:clipboard_watcher/clipboard_watcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_flutter_demo/dart_lang_test/my_demo.dart';
import 'package:my_flutter_demo/third_libs/provider_test/provider_test.dart';
import 'package:provider/provider.dart' as pd;
import 'package:my_flutter_demo/MyNavi.dart';
import 'package:my_flutter_demo/SecondPage.dart';
import 'package:my_flutter_demo/lifecycle/ui_lifecycle.dart';
import 'package:my_flutter_demo/log_print.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'interact_native/my_method_channel_test.dart';
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
    // child: MyApp(),
    child: MyTestApp(title: "test",),
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

class _MyHomePageState extends ConsumerState<MyHomePage> with ClipboardListener {
  int _counter = 0;
  List<MyRiverData>? dataSet;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();
    myLog("initState");
    getName();
    clipboardWatcher.addListener(this);
    clipboardWatcher.start();
    onClipboardChanged(); //初始化时，先读取一次
  }

  void getName() async {
    var name = await MyTestMethodChannel().getPlatformName();
    myLog("test name=$name");
  }

  @override
  void dispose() {
    super.dispose();
    myLog("dispose");
    clipboardWatcher.removeListener(this);
    clipboardWatcher.stop();
  }

  @override
  void onClipboardChanged() async {
    ClipboardData? newClipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    myLog("newClipboardData=${newClipboardData?.text}");
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(mainAxisAlignment: MainAxisAlignment.center, children: list2),
              ElevatedButton(onPressed: pullDataAction, style: const ButtonStyle(), child: const Text("pullData")),
              ElevatedButton(onPressed: jumpToSecond, child: const Text("Navi to second page")),
              const MyWidget(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(onPressed: _incrementCounter, tooltip: 'Increment', child: const Icon(Icons.add)));
  }

  ///跳转至第二页面
  void jumpToSecond() {
    MyNavi.navigateTo(
        context,
        pd.ChangeNotifierProvider(
          create: (context) => CartModel(),
          child: const SecondPage(),
        ));
  }

  ///
  void pullDataAction() {
    List<MyRiverData> tmp = ref.read(getMyDataListProvider).getDataList();
    print("tmp object=$tmp");
    setState(() {
      dataSet = tmp;
    });
  }
}
