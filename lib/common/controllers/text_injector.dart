import 'package:flutter/services.dart';
import 'package:transcriber/common/controllers/hot_key_controller.dart';

class TextInjector {
  static const MethodChannel _channel = MethodChannel(
    "com.hiz.transcriber/text_injector",
  );
  Future<void> typeText(String text) async {
    try {
      await _channel.invokeMethod('typeText', {'text': text});
    } on PlatformException catch (e) {
      print("Direct typing failed: ${e.message}");
    }
  }

  Future<void> pasteText(String text) async {
    try {
      await _channel.invokeMethod('pasteText', {'text': text});
    } on PlatformException catch (e) {
      print("Direct typing failed: ${e.message}");
    }
  }
}

class TextInjectorController implements DictationController {
  final TextInjector injector = TextInjector();
  @override
  Future<void> start() async {}

  @override
  Future<void> stop() async {
    injector.pasteText("Hello world");
  }
}
