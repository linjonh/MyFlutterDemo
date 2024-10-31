/*
 * 可以实例化，可以被继承，不能被实现, 私有成员，子类都有,base的作用似乎是为了防止外部类库的破坏
 */
base class ExampleBaseClass {
  var _privateFieds = "_privateFieds";
}

/*
 * The type 'Subclass' must be 'base', 'final' or 'sealed'
 * because the supertype 'ExampleBaseClass' is 'base'
 */
final class Subclass extends ExampleBaseClass {

  void printSuperFiled() {
    print("$_privateFieds");
  }
}

base class ThirdClass extends Subclass {
  @override
  var _privateFieds="ThirdClass";

  void toPrintString() {
    print("$_privateFieds");
  }
}
