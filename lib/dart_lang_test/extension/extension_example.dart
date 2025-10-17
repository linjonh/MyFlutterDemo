/*
 * 1.扩展方法
 * 2.扩展类型
 */

extension Dp on int {
  int dp() {
    var val = this * 2;
    return val;
  }
}

void main() {
  test();
}

void test() {
  print("val=${1.dp()}");
}

class MyFamily<T> {
  T? type;
  MyFamily(this.type);
  void showType() {
    print(type);
  }
}

extension MyClass<T> on MyFamily<T> {

}
