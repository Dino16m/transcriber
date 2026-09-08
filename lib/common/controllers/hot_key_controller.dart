import 'package:flutter/services.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:tray_manager/tray_manager.dart';

class DictationHotKeyModifier {
  late final PhysicalKeyboardKey key;
  late final HotKeyModifier modifierKey;

  DictationHotKeyModifier(PhysicalKeyboardKey key) {
    try {
      modifierKey = HotKeyModifier.values.firstWhere(
        (modifier) => modifier.physicalKeys.contains(key),
      );
    } on StateError {
      rethrow;
    }
    this.key = key;
  }

  static bool isValid(PhysicalKeyboardKey key) {
    try {
      HotKeyModifier.values.firstWhere(
        (modifier) => modifier.physicalKeys.contains(key),
      );
      return true;
    } on StateError {
      return false;
    }
  }
}

abstract class DictationController {
  Future<void> start();
  Future<void> stop();
}

class DictationHotKeyManager {
  DictationController? dictationController;

  DictationHotKeyManager._();

  static final DictationHotKeyManager instance = DictationHotKeyManager._();

  Future<void> _onKeyDown(HotKey key) async {
    await trayManager.setIcon("assets/images/chrysalis_rounded.png");
    dictationController?.start();
  }

  Future<void> _onKeyUp(HotKey key) async {
    await trayManager.destroy();
    dictationController?.stop();
  }

  void setController(DictationController ctrl) {
    dictationController = ctrl;
  }

  Future<void> setHotKey(
    DictationHotKeyModifier modifier,
    PhysicalKeyboardKey key,
  ) async {
    hotKeyManager.unregisterAll();
    var hotKey = HotKey(
      key: key,
      modifiers: [modifier.modifierKey],
      scope: HotKeyScope.system,
    );
    await hotKeyManager.register(
      hotKey,
      keyDownHandler: _onKeyDown,
      keyUpHandler: _onKeyUp,
    );
  }
}

DictationHotKeyManager get dictationHotKeyManager =>
    DictationHotKeyManager.instance;
