import 'package:my_flutter_demo/log_print.dart';

void testSwitch() {
  List<int> obj = [1, 2];
  // obj.add(3);
  switch (obj) {
    case const [1, 4]:
      myLog("");
    case const [1, 2]:
      myLog("const equals");
    case  [1, 2]:
      myLog("equals ：not const list ");
    default:
      myLog("not equals");
  }
}

(int,String) testRecords(param){
 myLog(param.runtimeType);
 return switch (param){
       1=>(1,"1"),
      _=>(-1,"no result")
  };
 
}

late String hello;



