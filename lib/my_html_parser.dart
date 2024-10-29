import 'dart:ui';

import 'package:html/dom.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:my_flutter_demo/log_print.dart';

Document parseHtml(dynamic input) {
  var parse = html_parser.parse(input);
  return parse;
}

List<ImageData>? parseImageUrl(Document doc) {
  List<Element> querySelectorAll = doc.querySelectorAll(".update_area .list_n2");
  myLog("parseImageUrl=${querySelectorAll.length}");
  if (querySelectorAll.isNotEmpty) {
    List<ImageData> list = <ImageData>[];
    for (var item in querySelectorAll) {
      var href = item.querySelector("a")?.attributes["href"];
      myLog("href=$href");
      var imageEl = item.querySelector("img");
      var src = imageEl?.attributes["src"];
      var alt = imageEl?.attributes["alt"];
      myLog("src=$src alt=$alt");
      list.add(ImageData(href, src, alt));
    }
    return list;
  } else {
    return null;
  }
}

class ImageData {
  String? href = "";
  String? src = "";
  String? alt = "";

  ImageData(this.href, this.src, this.alt);
}

mixin Parent on ImageData {
  String name = "Parent";
  void printName() {
    myLog(name);
  }
}

class Child extends ImageData  with Parent {
  Child(super.href, super.src, super.alt);

  void show() {
    super.name = "child changed name";
    print("name=$name");
    printName();
  }
}
