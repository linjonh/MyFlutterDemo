import 'AbsListener.dart';

sealed class BaseNode with MyNode {}

mixin MyNode {
  var vName = "MyNode";
}

class RecordNode extends BaseNode with MyNode implements AbsListener{
  @override
  String? absFields;

  @override
  String nameAbs="RecordNode";

  @override
  void doAction() {
    // TODO: implement doAction
  }

  @override
  void onAction() {
    // TODO: implement onAction
  }
}

class ProcessNode extends BaseNode {}

class UploadNode extends BaseNode with MoreNode {}

//指定在baseNode上的 class
mixin MoreNode on BaseNode {
  void showSubclass() {
    print("MoreNode mixn");
  }
}
// ERROR: Can't be instantiated.
// BaseNode myVehicle = BaseNode();

// Subclasses can be instantiated.
RecordNode recordNode = RecordNode();

String checkNode(BaseNode vehicle) {
  // ERROR: The switch is missing the Bicycle subtype or a default case.
  return switch (vehicle) {
    UploadNode() => 'UploadNOde',
    RecordNode() => 'recordNode',
    ProcessNode() => "ProcessNode",
    MoreNode() => "MoreNode"
  };
}
