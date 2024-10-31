import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_flutter_demo/MyNavi.dart';

class SecondPage extends ConsumerStatefulWidget {
  const SecondPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _SecondState();
  }
}

class _SecondState extends ConsumerState<ConsumerStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        width: 1460,
        height: 780,
        decoration: const BoxDecoration(
          color: Colors.cyan,
          image: DecorationImage(image: NetworkImage('https://picsum.photos/250?image=9'),
            alignment: Alignment.topCenter,
            fit: BoxFit.fill
          ),
        ),
        child: Column(
          children: [ElevatedButton(onPressed: onPressed, child: const Text("back"))],
        ),
      ),
    );
  }

  void onPressed() {
    MyNavi.backup(context);
  }
}
