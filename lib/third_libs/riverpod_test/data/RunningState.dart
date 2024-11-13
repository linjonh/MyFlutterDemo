import 'package:json_annotation/json_annotation.dart';

// part 'RunningState.g.dart';
///不好使，不会自动生成
@JsonEnum(valueField: "status", fieldRename: FieldRename.kebab)
enum RunningState {
  @JsonValue("4")
  start(1),
  end(2),
  running(3);

  const RunningState(this.status);

  final int status;
  // final String msg;
}
