import 'package:freezed_annotation/freezed_annotation.dart';
part 'Person.g.dart';//需要声明part 文件生成路径，然后调用dart run build_runner build 才会生成自动生成文件
@JsonSerializable()
class Person {
  String? firstName;
  String? lastName;
  String? nickName;
  int? age;
  String? sex;
  String? birthDay;
  String? address;
  String? job;
  String? phoneNum;

  Person();

  // Person({required this.firstName, required this.lastName, required this.phoneNum});

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);

  Map<String, dynamic> toJson() => _$PersonToJson(this);
}

@JsonSerializable()
class Sample4 {
  Sample4(this.value);

  factory Sample4.fromJson(Map<String, dynamic> json) => _$Sample4FromJson(json);

  @EpochDateTimeConverter()
  final DateTime value;

  Map<String, dynamic> toJson() => _$Sample4ToJson(this);
}

class EpochDateTimeConverter implements JsonConverter<DateTime, int> {
  const EpochDateTimeConverter();

  @override
  DateTime fromJson(int json) => DateTime.fromMillisecondsSinceEpoch(json);

  @override
  int toJson(DateTime object) => object.millisecondsSinceEpoch;
}
