import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_flutter_demo/dart_lang_test/my_html_parser.dart';

/// 1.Flutter为什么要区分StatelessWidget和StatefulWidget
/// 答：通过区分这两种类型的Widget，Flutter能够更高效地管理UI的构建和更新，从而提升应用的性能和响应速度
/// todo: 1.解析网站爬虫获取图片地址，增加网络加载数据，缓存持图片
///
///
class MyTestApp extends StatelessWidget {
  const MyTestApp({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "我的一个Flutter demo，是一个无状态的widget:$title",
      home: const MyTestHomePage(),
      theme: ThemeData(useMaterial3: true),
    );
  }
}

///
/// 首页state组件
///
class MyTestHomePage extends StatefulWidget {
  const MyTestHomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MyTestHomePageState();
  }
}

///
/// 首页state状态组件实现
///
class _MyTestHomePageState extends State<StatefulWidget> {
  var demoText = "demo text";
  var checked = false;
  var content = "empty";
  List<ImageData>? imageDatas;

  void changeData(String str, bool checked) {
    setState(() {
      demoText = str;
      this.checked = checked;
    });
  }

  loadHttp() async {
    try {
      var url = Uri.https("meirentu.cc");
      var future = await http.get(url);
      print("body=${future.statusCode}");
      if (future.statusCode == 200) {
        setState(() {
          var doc = parseHtml(future.body);
          imageDatas = parseImageUrl(doc);
          var str = doc.querySelector("title")?.text;
          content = str ?? "empty";
        });
      }
    } catch (e) {
      print("出现错误了:$e");
      setState(() {
        content = e.toString();
      });
    }
  }

  Widget getList() {
    if (imageDatas != null) {
      return ListView.builder(
          itemBuilder: (context, index) {
            var imageData = imageDatas?[index];
            var src2 = imageData?.src ?? "";
            return Center(
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  imageData?.alt ?? "",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                loadImage(src2),
              ]),
            );
          },
          itemCount: imageDatas!.length);
    }
    return const Text("empty");
  }

  loadImageNet(String src2) async {
    var parse = Uri.parse(src2);
    var future = await http.get(parse, headers: httpHeaders());
    if (future.statusCode == 200) {
      print(" load success");
    }else{
      print(" load error :${future.statusCode} ${future.reasonPhrase}");
    }

  }

  CachedNetworkImage loadImage(String src2) {
    loadImageNet(src2);
    return CachedNetworkImage(
      // imageUrl: "https://img-s-msn-com.akamaized.net/tenant/amp/entityid/AA1qfLPZ.img?w=584&h=328&m=6",
      imageUrl: src2,
      httpHeaders: httpHeaders(),
      width: 100,
      height: 100,
    );
  }

  Map<String, String> httpHeaders() {
    return const {
      "dnt": "1",
      "method": "GET",
      "pragma": "no-cache",
      "cache-control": "no-cache",
      "priority": "u=1, i",
      "referer": "https://meirentu.cc/",
      "user-agent":
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36",
      "accept-language": "zh-CN,zh;q=0.9,en;q=0.8,zh-TW;q=0.7",
      "accept": "image/avif,image/webp,image/apng,image/svg+xml,image/*,*/*;q=0.8",
      "accept-encoding": "gzip, deflate, br, zstd",
      "sec-fetch-dest": "image",
      "sec-fetch-mode": "no-cors",
      "sec-fetch-site": "cross-site",
      "sec-ch-ua": "\"Chromium\";v=\"128\", \"Not;A=Brand\";v=\"24\", \"Google Chrome\";v=\"128\"",
      "sec-ch-ua-mobile": "?0",
      "sec-ch-ua-platform": "\"Windows\"",
    };
  }

  @override
  void initState() {
    super.initState();
    loadHttp();
  }

  @override
  Widget build(BuildContext context) {
    // implement build component
    // return ListView(
    //   children: [
    //     Center(
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           ElevatedButton(
    //               onPressed: () {
    //                 // changeData(!checked ? "checked" : "uncheck", !checked);
    //                 loadHttp();
    //               },
    //               child: Text(
    //                 "text=$demoText checked=$checked",
    //               )),
    //           CutterView(),
    //           Text("$content")
    //         ],
    //       ),
    //     ),
    //   ],
    // );

    return getList();
  }
}
