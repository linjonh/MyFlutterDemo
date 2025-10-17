import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:my_flutter_demo/dart_lang_test/my_html_parser.dart';
import 'package:my_flutter_demo/log_print.dart';

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
    return SafeArea(
      child: MaterialApp(title: "我的一个Flutter demo，是一个无状态的widget:$title", home: const MyTestHomePage(), theme: ThemeData(useMaterial3: true)),
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

  void loadHttp() async {
    try {
      var url = Uri.https("meirentu.cc");
      var future = await http.get(url);
      myLog("body=${future.statusCode}");
      if (future.statusCode == 200) {
        var doc = parseHtml(future.body);
        setState(() {
          imageDatas = parseImageUrl(doc);
          var str = doc.querySelector("title")?.text;
          content = str ?? "empty";
        });
      }
    } catch (e) {
      myLog("出现错误了:$e");
      setState(() {
        content = e.toString();
      });
    }
  }

  Widget getList() {
    if (imageDatas != null) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return GridView.builder(
            shrinkWrap: true,
            gridDelegate: constraints.maxWidth < 400
                ? const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 0.7, mainAxisSpacing: 0, crossAxisSpacing: 0)
                : const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 300, childAspectRatio: 0.7, mainAxisSpacing: 0, crossAxisSpacing: 0),
            itemBuilder: (context, index) {
              var imageData = imageDatas?[index];
              var src2 = imageData?.src ?? "";
              return Card(
                clipBehavior: Clip.antiAlias, // ✅ 确保圆角裁剪生效
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: InkWell(
                  onTap: () {
                    //click
                    print("click ${imageData?.href}");
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(imageUrl: imageData!.href!)));
                  },
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      loadImage(src2),
                      Container(
                        color: Colors.black45,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(4),
                        height: 30,
                        child: Text(
                          imageData?.alt ?? "",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            itemCount: imageDatas!.length,
          );
        },
      );
    }
    return const Text("empty");
  }

  void loadImageNet(String src2) async {
    var parse = Uri.parse(src2);
    var future = await http.get(parse, headers: httpHeaders());
    if (future.statusCode == 200) {
      myLog(" load success");
    } else {
      myLog(" load error :${future.statusCode} ${future.reasonPhrase}");
    }
  }

  @override
  void initState() {
    super.initState();
    loadHttp();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Text("图片列表", style: Theme.of(context).textTheme.titleLarge),
          Expanded(child: getList()),
        ],
      ),
    );
  }
}

Map<String, String> httpHeaders() {
  return const {
    "dnt": "1",
    "method": "GET",
    "pragma": "no-cache",
    "cache-control": "no-cache",
    "priority": "u=1, i",
    "referer": "https://meirentu.cc/",
    "user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36",
    "accept-language": "zh-CN,zh;q=0.9,en;q=0.8,zh-TW;q=0.7",
    "accept": "image/avif,image/webp,image/apng,image/svg+xml,image/*,*/*;q=0.8",
    "accept-encoding": "gzip, deflate, br, zstd",
    // "sec-fetch-dest": "image",
    // "sec-fetch-mode": "no-cors",
    // "sec-fetch-site": "cross-site",
    // "sec-ch-ua":
    //     "\"Chromium\";v=\"128\", \"Not;A=Brand\";v=\"24\", \"Google Chrome\";v=\"128\"",
    // "sec-ch-ua-mobile": "?0",
    // "sec-ch-ua-platform": "\"Windows\"",
  };
}

Widget loadImage(String src2) {
  // loadImageNet(src2);
  return CachedNetworkImage(
    // imageUrl: "https://img-s-msn-com.akamaized.net/tenant/amp/entityid/AA1qfLPZ.img?w=584&h=328&m=6",
    imageUrl: src2,
    // width: 300,
    // height: 400,
    httpHeaders: httpHeaders(),
  );
}

class DetailPage extends ConsumerStatefulWidget {
  final String imageUrl;
  const DetailPage({super.key, required this.imageUrl});

  @override
  ConsumerState<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends ConsumerState<DetailPage> {
  Future<void> _loadData() async {
    var res = await http.get(Uri.parse("https://meirentu.cc${widget.imageUrl}"));
    print("res ${res.statusCode} ${res.toString()}");
    if (res.statusCode == 200) {
      var doc = parseHtml(res.body);
      var detailImages = await parseDetailImage(doc);
      if (!mounted) return;
      setState(() {
        dataSet = detailImages;
      });
    } else {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => const AlertDialog(content: Text("load data not success")),
        );
      }
    }
  }

  List<ImageData>? dataSet;
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    if (dataSet != null) {
      return LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 400) {
            return ListView.builder(
              itemCount: dataSet?.length,
              itemBuilder: (context, idx) {
                return loadImage(dataSet![idx].src!);
              },
            );
          } else {
            return GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 300, childAspectRatio: 0.7, mainAxisSpacing: 0, crossAxisSpacing: 0),
              itemBuilder: (context, idx) {
                return loadImage(dataSet![idx].src!);
              },
            );
          }
        },
      );
    } else {
      return Text("Loading", style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white));
    }
  }
}
