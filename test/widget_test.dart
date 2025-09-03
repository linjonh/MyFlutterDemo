// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert' as convert;

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:my_flutter_demo/dart_lang_test/class_test/ion_click.dart';
import 'package:my_flutter_demo/dart_lang_test/class_test/my_canvas.dart';
import 'package:my_flutter_demo/dart_lang_test/class_test/seal_class.dart';

//basic enum
enum MyState { start, working, end, trans }

//enhanced enum
enum MyWorkState {
  boring(name: "boring", state: MyState.working),
  happy(name: "happy", state: MyState.end),
  crazy(name: "crazy", state: MyState.trans),
  mad(name: "mad", state: MyState.start);

  const MyWorkState({required this.name, required this.state});

  final MyState state;
  final String name;

  //还能增加函数
  bool isHappy() => state == MyState.end;
}

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    try {
      var url = Uri.https("meirentu.cc");
      var future = await http.get(url);
      print("body=${future.statusCode} ${future.reasonPhrase}");
    } catch (e) {
      print(e.toString());
    }
    // This example uses the Google Books API to search for books about http.
    // https://developers.google.cn/books/docs/overview
    var url = Uri.https('www.googleapis.com', '/books/v1/volumes', {'q': '{http}'});

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      var itemCount = jsonResponse['totalItems'];
      print('Number of books about http: $itemCount.');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  });

  /*// Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
  void testClass() {
    var data = MyData("lin", 22);
    MyData.user("jonh");
    data.helloWorld();
    }
    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
    testClass();
  */


  var aCanvas = MyCanvas("canvas", 20);

  aCanvas.read();
  aCanvas.draw();
  aCanvas.helloWorld();
  aCanvas.showHome();
  aCanvas.onAction();
  // 抽象类不能被实例化
  // AbsInterface();
  // AbsListener();
  //接口类可以实例化
  var anInterfaceInstance = IOnClick();
  anInterfaceInstance.doAction2();
  var nodeName = checkNode(aCanvas);
  print("nodeName=$nodeName");

  // testWidgets('Counter increments smoke test', (WidgetTester tester) async {
  //   // Build our app and trigger a frame.
  //   await tester.pumpWidget(const MyApp());
  //
  //   // Verify that our counter starts at 0.
  //   expect(find.text('0'), findsOneWidget);
  //   expect(find.text('1'), findsNothing);
  //
  //   // Tap the '+' icon and trigger a frame.
  //   await tester.tap(find.byIcon(Icons.add));
  //   await tester.pump();
  //
  //   // Verify that our counter has incremented.
  //   expect(find.text('0'), findsNothing);
  //   expect(find.text('1'), findsOneWidget);
  // });
}
