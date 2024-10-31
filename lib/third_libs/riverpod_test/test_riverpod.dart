
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'test_riverpod.g.dart';

@riverpod
String myName(Ref ref){ 
  return "linjonh";
}