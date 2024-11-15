import 'package:flutter/material.dart';
import 'package:my_flutter_demo/log_print.dart';

class MyWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyWidgetState();
  }
}

abstract class MyCommonLogWidgetState<T extends StatefulWidget> extends State<T> with WidgetsBindingObserver {
  MyCommonLogWidgetState() {
    myLog("create, mounted=$mounted");
  }

  @override
  void initState() {
    myLog("initState1 mounted=$mounted");
    super.initState();
    myLog("initState2 mounted=$mounted");
    WidgetsBinding.instance.addObserver(this); // Register the observer
  }

  @override
  void didChangeDependencies() {
    myLog("didChangeDependencies mounted=$mounted");
  }

  @override
  void dispose() {
    myLog("dispose1 mounted=$mounted");
    super.dispose();
    myLog("dispose2 mounted=$mounted");
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void activate() {
    myLog("activate mounted=$mounted");
  }

  @override
  void deactivate() {
    myLog("deactivate mounted=$mounted");
  }

  @override
  void reassemble() {
    myLog("reassemble mounted=$mounted");
  }

  @override
  void didUpdateWidget(T oldWidget) {
    myLog("didUpdateWidget mounted=$mounted");
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    myLog("didChangeAppLifecycleState state=$state");

    switch (state) {
      case AppLifecycleState.inactive: // 处于这种状态的应用程序应该假设它们可能在任何时候暂停。
        break;
      case AppLifecycleState.resumed: //从后台切换前台，界面可见
        break;
      case AppLifecycleState.paused: // 界面不可见，后台
        break;
      case AppLifecycleState.detached: // APP结束时调用
        break;
      case AppLifecycleState.hidden:
        // TODO: Handle this case.
        break;
    }
    // paused的过程
    // I/flutter ( 7333): didChangeAppLifecycleState state=AppLifecycleState.inactive
    // I/flutter ( 7333): didChangeAppLifecycleState state=AppLifecycleState.hidden
    // I/flutter ( 7333): didChangeAppLifecycleState state=AppLifecycleState.paused
    // resume的过程
    // I/flutter ( 7333): didChangeAppLifecycleState state=AppLifecycleState.hidden
    // I/flutter ( 7333): didChangeAppLifecycleState state=AppLifecycleState.inactive
    // I/flutter ( 7333): didChangeAppLifecycleState state=AppLifecycleState.resumed
  }
}

class MyWidgetState extends MyCommonLogWidgetState<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Text("demo");
  }
}

interface class HI {
  void print() {
    myLog("test");
  }
// void contract();//error ,must have body {},not like abstract class can have no body.
}

abstract mixin class Hi {
  void contract(); //can have no body

  void print2() {
    myLog("test");
  }
}

class Hello with Hi {
  @override
  void contract() {
    // TODO: implement contract
    print2();
  }
}
// interface class H2 {
//   void print();
//   void contract();
// }
