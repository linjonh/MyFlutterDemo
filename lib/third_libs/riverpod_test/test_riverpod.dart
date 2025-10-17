
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'test_riverpod.g.dart';

@riverpod
String myName(Ref ref){ 
  return "linjonh";
}