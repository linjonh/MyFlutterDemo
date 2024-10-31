import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:my_flutter_demo/dart_lang_test/my_html_parser.dart';

bool topLevel = true;

void main() async {
  var insideMain = true;

  void myFunction() {
    var insideFunction = true;

    void nestedFunction() {
      var insideNestedFunction = true;

      assert(topLevel);
      assert(insideMain);
      assert(insideFunction);
      assert(insideNestedFunction);
      print("topLevel=$topLevel insideMain=$insideMain $insideFunction $insideNestedFunction");
    }
    nestedFunction();
  }
  group("test group", () {
    // test("test http", loadHttp);
    test("mixin", () {
      Child("", "", "").show();
    });
  });
  test(" test other mixin", () {
    Child("hh", "ss", "sf").show();
    myFunction();
  });

}

loadHttp() async {
  try {
    var url = Uri.parse("https://meirentu.cc/");

    var client = http.Client();
    var future = await client.get(url);
    print("statusCode=${future.statusCode} ${future.body}");
  } catch (e) {
    print("出现错误了:" + e.toString());
  }
}
