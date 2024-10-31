import 'package:flutter/material.dart';

class MyNavi {
  static void navigateTo(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  static void backup(BuildContext context){
    Navigator.pop(context);
  }

}
