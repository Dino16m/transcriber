import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:tray_manager/tray_manager.dart';

class DrawableKey {
  final String display;
  final PhysicalKeyboardKey key;

  new({required this.display, required this.key});
}

typedef DictationHotKey = (DictationHotKeyModifier, DrawableKey);

String serializeDictationHotKey(DictationHotKey hotKey) {
  final (modifier, key) = hotKey;
  final modifierMap = {
    "d": modifier.key.display,
    "k": modifier.key.key.usbHidUsage.toString(),
  };
  final keyMap = {"d": key.display, "k": key.key.usbHidUsage.toString()};
  final map = {"mm": modifierMap, "km": keyMap};
  return jsonEncode(map);
}

DictationHotKey? deserializeDictationHotKey(String encoded) {
  final raw = jsonDecode(encoded);
  final map = raw as Map<String, dynamic>;

  final keyMap = map["km"] as Map<String, dynamic>;

  final key = DrawableKey(
    display: keyMap["d"]! as String,
    key: PhysicalKeyboardKey(int.parse(keyMap["k"]! as String)),
  );

  final modifierMap = map["mm"] as Map<String, dynamic>;

  final modifierKey = DictationHotKeyModifier(
    DrawableKey(
      display: modifierMap["d"]! as String,
      key: PhysicalKeyboardKey(int.parse(modifierMap["k"]! as String)),
    ),
  );
  return (modifierKey, key);
}

class DictationHotKeyModifier {
  late final DrawableKey key;
  late final HotKeyModifier modifierKey;

  DictationHotKeyModifier(DrawableKey key) {
    try {
      modifierKey = HotKeyModifier.values.firstWhere(
        (modifier) => modifier.physicalKeys.contains(key.key),
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

  void clearHotKey() {
    hotKeyManager.unregisterAll();
  }

  Future<void> setHotKey(DictationHotKey dictationHotKey) async {
    hotKeyManager.unregisterAll();
    var hotKey = HotKey(
      key: dictationHotKey.$2.key,
      modifiers: [dictationHotKey.$1.modifierKey],
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
