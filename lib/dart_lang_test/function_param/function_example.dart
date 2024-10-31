/*
 *函数参数不能同时出现命名参数和可选参数，位置参数都是位于他们俩之前
 */

///可选参数，
void testFunOptionParam(String name, String two, [String? six, int? seven]) {
  print("position_param:$name $two option_params : $six $seven");
}

///命名参数
void testFunNamedParam(String name, String two,
    {required String three, String? four, String five = "default five"}) {
  print("$name $two $three $four $five");
}

void main() {
  testFunNamedParam("named", "two", three: "three");
  testFunOptionParam("option", "two","six");
}
