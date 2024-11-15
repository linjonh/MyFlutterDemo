import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_flutter_demo/third_libs/provider_test/provider_test.dart';
import 'package:provider/provider.dart' as pd;
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
    return pd.Consumer<CartModel>(
        builder: (context, cart, child) => Stack(
              children: [
                if (child != null) child,
                Align(alignment:Alignment(0.5,0.7),child: ElevatedButton(onPressed: () => {cart.add(Item())}, child: const Text("cart add"))),
                Center(
                  child: Text(style: TextStyle().copyWith(fontSize: 20),"stack place holder cart=${cart.items.length}"),
                )
              ],
            ),
        child: Scaffold(
          body: Container(
            padding: const EdgeInsets.all(20),
            width: 1460,
            height: 780,
            // decoration: const BoxDecoration(
            //   color: Colors.cyan,
            //   image: DecorationImage(
            //       image: NetworkImage('https://picsum.photos/250?image=9'), alignment: Alignment.topCenter, fit: BoxFit.fill),
            // ),
            child: Column(
              children: [
                ElevatedButton(onPressed: onPressed, child: const Text("back")),
              ],
            ),
          ),
        ));
  }

  void onPressed() {
    MyNavi.backup(context);
  }
}
