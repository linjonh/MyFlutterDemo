import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:my_flutter_demo/dart_lang_test/my_html_parser.dart';
import 'package:my_flutter_demo/dart_lang_test/records_test/records.dart';
import 'package:my_flutter_demo/log_print.dart';
import 'package:my_flutter_demo/third_libs/provider_test/provider_test.dart';

bool topLevel = true;

void main() async {
  var insideMain = true;

  void myFunction() {
    var insideFunction = true;

    void nestedFunction() {
      var insideNestedFunction = true;

      assert(topLevel);
      assert(insideMain);
      assert(insideFunction);
      assert(insideNestedFunction);
      print(
          "topLevel=$topLevel insideMain=$insideMain $insideFunction $insideNestedFunction");
    }

    nestedFunction();
  }

  group("test group", () {
    // test("test http", loadHttp);
    test("mixin", () {
      Child("", "", "").show();
    });
  });
  test(" test other mixin", () {
    Child("hh", "ss", "sf").show();
    myFunction();
  });

  test("test provider", () {
    var cart = CartModel();
    cart.addListener(() {
      myLog("cart changed=${cart.items.length}");
    });

    for (var i = 0; i < 10; ++i) {
      cart.add(Item());
    }
  });
  test("test switch", () {
    testSwitch();
    var result = testRecords((1, 2, 4));
    myLog(result);
  });

  test("isolate", () async {
    await runIsolate();
  });

  test("isolate_comunication", () async {
    final worker = Worker();
    await worker.spawn();
    await worker.parseJson('{"key":"value","name":"Worker1"}');
    await worker.parseJson("test data");

    final worker2 = await Worker2.spawn();
    print(await worker2.parseJson('{"key":"value","name":"Worker2"}'));
    print(await worker2.parseJson('"banana"'));
    print(await worker2.parseJson('test banana json'));
    print(await worker2.parseJson('[true, false, null, 1, "string"]'));
    print(await Future.wait(
        [worker2.parseJson('"yes"'), worker2.parseJson('["no","2"]')]));
    worker2.close();
  });
}

class Worker {
  late SendPort _sendPort;
  final Completer<void> _isolateReady = Completer.sync();
  Future<void> spawn() async {
    // Add functionality to spawn a worker isolate.
    final receivePort = ReceivePort("main");
    receivePort.listen(_handleResponsesFromIsolate);
    await Isolate.spawn(_startRemoteIsolate, receivePort.sendPort,
        onError: receivePort.sendPort, onExit: receivePort.sendPort);
  }

  void _handleResponsesFromIsolate(dynamic message) {
    //  Handle messages sent back from the worker isolate.
    if (message is SendPort) {
      _sendPort = message;
      _isolateReady.complete();
    } else if (message is Map<String, dynamic>) {
      print(message);
    } else {
      print("msg:【$message】");
    }
  }

  static void _startRemoteIsolate(SendPort port) {
    //  Define code that should be executed on the worker isolate.
    final receivePort = ReceivePort("spawn");
    port.send(receivePort.sendPort);

    receivePort.listen((dynamic message) async {
      print('spawn receivePort:msg=$message');
      if (message is String) {
        try {
          final transformed = jsonDecode(message);
          print("decode:$transformed");
          port.send(transformed);
        } catch (e) {
          port.send(RemoteError(e.toString(), ""));
          print(e);
        } finally {
          print("transformed=$message");
        }
      }
    });
  }

  Future<void> parseJson(String message) async {
    // Define a public method that can
    // be used to send messages to the worker isolate.
    await _isolateReady.future;
    _sendPort.send(message);
  }
}

///健壮端口示例
///包含关闭断口，错误处理，消息对应
class Worker2 {
  final SendPort _commands;
  final ReceivePort _responses;
  final Map<int, Completer<Object?>> _activeRequests = {};
  int _idCounter = 0;
  bool _closed = false;

  Future<Object?> parseJson(String message) async {
    if (_closed) throw StateError('Closed');
    final completer = Completer<Object?>.sync();
    final id = _idCounter++;
    _activeRequests[id] = completer;
    _commands.send((id, message));
    return await completer.future.catchError((e){
      print(e);
    });
  }

  static Future<Worker2> spawn() async {
    // Create a receive port and add its initial message handler
    final initPort = RawReceivePort();
    final connection = Completer<(ReceivePort, SendPort)>.sync();
    initPort.handler = (initialMessage) {
      final commandPort = initialMessage as SendPort;
      connection.complete((
        ReceivePort.fromRawReceivePort(initPort),
        commandPort,
      ));
    };

    // Spawn the isolate.
    try {
      await Isolate.spawn(_startRemoteIsolate, (initPort.sendPort));
    } on Object {
      initPort.close();
      rethrow;
    }

    final (ReceivePort receivePort, SendPort sendPort) =
        await connection.future;

    return Worker2._(receivePort, sendPort);
  }

  Worker2._(this._responses, this._commands) {
    _responses.listen(_handleResponsesFromIsolate);
  }

  void _handleResponsesFromIsolate(dynamic message) {
    final (int id, Object? response) = message as (int, Object?);
    final completer = _activeRequests.remove(id)!;

    if (response is RemoteError) {
      completer.completeError(response);
    } else {
      completer.complete(response);
    }

    if (_closed && _activeRequests.isEmpty) _responses.close();
  }

  static void _handleCommandsToIsolate(
    ReceivePort receivePort,
    SendPort sendPort,
  ) {
    receivePort.listen((message) {
      if (message == 'shutdown') {
        receivePort.close();
        return;
      }
      final (int id, String jsonText) = message as (int, String);
      try {
        final jsonData = jsonDecode(jsonText);
        sendPort.send((id, jsonData));
      } catch (e) {
        print("error:$e");
        sendPort.send((id, RemoteError(e.toString(), '')));
      }
    });
  }

  static void _startRemoteIsolate(SendPort sendPort) {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    _handleCommandsToIsolate(receivePort, sendPort);
  }

  void close() {
    if (!_closed) {
      _closed = true;
      _commands.send('shutdown');
      if (_activeRequests.isEmpty) _responses.close();
      print('--- port closed --- ');
    }
  }
}

Future<void> runIsolate() async {
  Future<String> computation() async {
    await Future.delayed(const Duration(seconds: 5));
    return "3";
  }

  print("start computation");
  var result = await Isolate.run(computation);
  print("end computation");

  print("result =$result");
}

loadHttp() async {
  try {
    var url = Uri.parse("https://meirentu.cc/");

    var client = http.Client();
    var future = await client.get(url);
    print("statusCode=${future.statusCode} ${future.body}");
  } catch (e) {
    print("出现错误了:$e");
  }
}
