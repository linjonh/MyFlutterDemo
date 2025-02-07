void testSwitch() {
  List<int> obj = [1, 2];
  // obj.add(3);
  switch (obj) {
    case const [1, 4]:
      print("");
    case const [1, 2]:
      print("const equals");
    case  [1, 2]:
      print("equals ：not const list ");
    default:
      print("not equals");
  }
}

(int,String) testRecords(param){
 print(param.runtimeType);
 return switch (param){
       1=>(1,"1"),
      _=>(-1,"no result")
  };
 
}

late String hello;



