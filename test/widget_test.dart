// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_flutter_demo/official_demo.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    try{


   var url= Uri.https("meirentu.cc");
   var future = await http.get(url);
    print("body=${future.statusCode} ${future.reasonPhrase}");
    }catch(e){
      print( e.toString() );
    }
   // This example uses the Google Books API to search for books about http.
   // https://developers.google.cn/books/docs/overview
   var url =
   Uri.https('www.googleapis.com', '/books/v1/volumes', {'q': '{http}'});

   // Await the http get response, then decode the json-formatted response.
   var response = await http.get(url);
   if (response.statusCode == 200) {
     var jsonResponse =
     convert.jsonDecode(response.body) as Map<String, dynamic>;
     var itemCount = jsonResponse['totalItems'];
     print('Number of books about http: $itemCount.');
   } else {
     print('Request failed with status: ${response.statusCode}.');
   }

    /*// Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);*/
  });
}
