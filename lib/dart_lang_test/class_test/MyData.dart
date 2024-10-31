import 'package:flutter/foundation.dart';

mixin Write {
  String? nameWrite;

// Write(this.name);//mixin can't declare a constructor

  void draw() {
    print("draw a thing:$nameWrite");
  }
}
mixin Read {
  String? nameRead;

  void read() {
    print("read a thing");
  }
}

class MyData with Write {
  String? name;
  int? age;

  MyData(
    this.name,
    this.age,
  ) {
    if (kDebugMode) {
      print("$name $age");
    }
  }

  MyData.user(String name) : this(name, null);

  void helloWorld() {
    if (kDebugMode) {
      print("hellow world");
    }
  }
}
