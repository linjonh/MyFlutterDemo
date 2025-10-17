import 'package:html/dom.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;
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
      var src = imageEl?.attributes["data-src"];
      var alt = imageEl?.attributes["alt"];
      myLog("src=$src alt=$alt");
      list.add(ImageData(href, src, alt));
    }
    return list;
  } else {
    return null;
  }
}

void parseDetailImageTag(Document doc, List<ImageData> list) {
  var imageTags = doc.querySelectorAll("div.content img");
  for (var tag in imageTags) {
    var src = tag.attributes["src"];
    var alt = tag.attributes["alt"];
    var data = ImageData(null, src, alt);
    list.add(data);
  }
}

Future<List<ImageData>?> parseDetailImage(Document doc) async {
  List<Element> querySelectorAll = doc.querySelectorAll("div.page a");
  myLog("parseImageUrl=${querySelectorAll.length}");
  if (querySelectorAll.isNotEmpty) {
    querySelectorAll = querySelectorAll.sublist(1, querySelectorAll.length - 1);
    List<ImageData> list = <ImageData>[];
    //第一页的先获取一下
    parseDetailImageTag(doc, list);
    for (var item in querySelectorAll) {
      var hrefPath = item.attributes["href"];
      var url = Uri.https("meirentu.cc", hrefPath!);
      try {
        var res = await http.get(url);
        if (res.statusCode == 200) {
          var detailDoc = parseHtml(res.body);
          parseDetailImageTag(detailDoc, list);
        }
      } catch (e) {
        print(e);
      }
    }
    return Future.value(list);
  }
  return null;
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

class Child extends ImageData with Parent {
  Child(super.href, super.src, super.alt);

  void show() {
    super.name = "child changed name";
    print("name=$name");
    printName();
  }
}
