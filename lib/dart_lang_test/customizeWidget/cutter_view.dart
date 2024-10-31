import 'package:flutter/cupertino.dart';

///
/// 创建一个时间轴的自定义控件
///
class CutterView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CutterView();
}

class _CutterView extends State<StatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Placeholder(),
    );
  }
}
