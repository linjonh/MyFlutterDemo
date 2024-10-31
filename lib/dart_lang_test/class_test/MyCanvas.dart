import 'AbsInterface.dart';
import 'AbsListener.dart';
import 'IOnClick.dart';
import 'MyData.dart';
import 'SealClass.dart';

class Home {
  void showHome() {
    print("show home");
  }
}

class MyCanvas extends MyData
    with Write, Read
    implements Home, AbsListener, IOnClick, AbsInterface, RecordNode, UploadNode, ProcessNode {
  MyCanvas(super.name, super.age) {
    nameWrite = "draw a rectangle";
    nameRead = "circle";
    draw();
    read();
  }

  @override
  void showHome() {
    print("MyCanvas showHome");
  }

  @override
  void onAction() {
    print("MyCanvas onAction");
  }

  @override
  String nameAbs = "Canvas";

  @override
  String nameInterface = "";

  @override
  void doAction() {
    // TODO: implement doAction
  }

  @override
  void doAction2() {
    // TODO: implement doAction2
  }

  @override
  String? absFields;

  @override
  String absInterField = "";

  @override
  String interFields = "";

  @override
  String vName = "mixinName";

  @override
  void showSubclass() {
    // TODO: implement showSubclass
  }
}
