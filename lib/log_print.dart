import 'package:flutter/foundation.dart';

void myLog(dynamic log) {  if (kDebugMode) {
    debugPrint(log);
  }
}
