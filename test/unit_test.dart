import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:my_flutter_demo/dart_lang_test/my_html_parser.dart';
import 'package:my_flutter_demo/log_print.dart';
import 'package:my_flutter_demo/third_libs/provider_test/provider_test.dart';

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

  test("test provider",(){
    var cart = CartModel();
    cart.addListener(() {
      myLog("cart changed=${cart.items.length}");
    });

    for (var i = 0; i < 10; ++i) {
      cart.add(Item());
    }
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
