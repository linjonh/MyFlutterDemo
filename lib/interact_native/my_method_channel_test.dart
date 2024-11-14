import 'package:flutter/services.dart';
import 'package:my_flutter_demo/log_print.dart';

class MyTestMethodChannel {
  static const platformChannel =  MethodChannel("com.jaysen/test");

  Future<String?> getPlatformName() async {
    try {
      var name = await platformChannel.invokeMethod<String>("test");
      myLog("name=$name");
      return name;
    } on PlatformException catch (e) {
      myLog(e);
      return "failed,exception:'${e.message}'";
    }
  }
}
