import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:provider/provider.dart';
import 'package:transcriber/common/controllers/hot_key_controller.dart';
import 'package:transcriber/common/state/app_config_state.dart';

import 'common.dart';

class GeneralScreen extends StatelessWidget {
  const GeneralScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsScreen(
      title: 'General',
      subtitle: 'Choose how you talk to Dictate and how it types your words.',
      children: [
        SettingsGroup(
          title: 'Hold-to-Talk Hotkey',
          chip: '· press & hold to record, release to insert',
          children: const [
            Padding(padding: EdgeInsets.all(14), child: _HotKeyRecorderBox()),
          ],
        ),
        SettingsGroup(
          title: 'Microphone',
          children: [
            SettingRow(
              title: 'Input device',
              description: 'Used to capture your voice',
              trailing: MacosPulldownButton(
                title: 'MacBook Pro Microphone',
                items: const [
                  MacosPulldownMenuItem(title: Text('MacBook Pro Microphone')),
                  MacosPulldownMenuItem(title: Text('AirPods Pro')),
                  MacosPulldownMenuItem(title: Text('External USB Mic')),
                ],
              ),
            ),
            const SettingRow(
              title: 'Input level',
              description: 'Speak to test',
              trailing: _LevelMeter(),
            ),
          ],
        ),
        SettingsGroup(
          title: 'Insertion',
          children: const [
            ToggleRow(
              title: 'Type directly into the focused field',
              description: 'Uses macOS Accessibility to type at your cursor',
            ),
            ToggleRow(
              title: 'Fall back to clipboard if insertion fails',
              description: 'Copies the text and notifies you to paste',
            ),
            ToggleRow(
              title: 'Play a sound when dictation starts',
              description: 'Subtle chime on key-down',
            ),
          ],
        ),
      ],
    );
  }
}

class _HotKeyRecorderBox extends StatefulWidget {
  const _HotKeyRecorderBox();

  @override
  State<_HotKeyRecorderBox> createState() => _HotKeyRecorderBoxState();
}

class _HotKeyRecorderBoxState extends State<_HotKeyRecorderBox> {
  bool _recording = false;
  FocusNode focusNode = FocusNode();

  DrawableKey? modifierKey;
  DrawableKey? keyboardKey;

  @override
  void initState() {
    final config = context.read<AppConfigState>();
    if (config.dictationHotKey != null) {
      final (dictationModifier, dictationKey) = config.dictationHotKey!;
      modifierKey = dictationModifier.key;
      keyboardKey = dictationKey;
    }
    super.initState();
  }

  void resetKeys() {
    final config = context.read<AppConfigState>();
    if (config.dictationHotKey != null) {
      final (dictationModifier, dictationKey) = config.dictationHotKey!;
      setState(() {
        modifierKey = dictationModifier.key;
        keyboardKey = dictationKey;
      });
    }
  }

  void recordingStarted() {
    setState(() {
      modifierKey = null;
      keyboardKey = null;
    });
    focusNode.requestFocus();
  }

  void recordingStopped() {
    focusNode.previousFocus();
    if (_validationError == null &&
        modifierKey != null &&
        keyboardKey != null) {
      final config = context.read<AppConfigState>();
      config.dictationHotKey = (
        DictationHotKeyModifier(modifierKey!),
        keyboardKey!,
      );
    } else {
      setState(() {
        modifierKey = null;
        keyboardKey = null;
      });
      resetKeys();
    }
  }

  void _toggleRecording() {
    setState(() {
      _recording = !_recording;
      if (_recording) {
        recordingStarted();
      } else {
        recordingStopped();
      }
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  static const Map<String, List<PhysicalKeyboardKey>> _symbolToPhysicalKeys = {
    '\u2325': [
      PhysicalKeyboardKey.altLeft,
      PhysicalKeyboardKey.altRight,
    ], // ⌥ Option / Alt
    '\u2318': [
      PhysicalKeyboardKey.metaLeft,
      PhysicalKeyboardKey.metaRight,
    ], // ⌘ Command
    '\u21e7': [
      PhysicalKeyboardKey.shiftLeft,
      PhysicalKeyboardKey.shiftRight,
    ], // ⇧ Shift
    '\u2303': [
      PhysicalKeyboardKey.controlLeft,
      PhysicalKeyboardKey.controlRight,
    ], // ⌃ Control
    '\u232b': [PhysicalKeyboardKey.backspace], // ⌫ Backspace
    '\u21a9': [PhysicalKeyboardKey.enter], // ↩ Return
  };

  Widget get _selectedKeys {
    return Row(
      children: [
        KeyCap(label: modifierKey?.display ?? ""),
        SizedBox(width: 5),
        if (keyboardKey != null) ...[
          Text('+', style: TextStyle(fontSize: 12, color: kTextTertiary)),
          SizedBox(width: 5),
          KeyCap(label: keyboardKey!.display),
        ],
      ],
    );
  }

  DrawableKey makeDrawable(KeyEvent event) {
    final character = _symbolToPhysicalKeys.entries
        .firstWhere(
          (entry) => entry.value.contains(event.physicalKey),
          orElse: () {
            return MapEntry(event.logicalKey.keyLabel, []);
          },
        )
        .key;
    return DrawableKey(display: character, key: event.physicalKey);
  }

  String? get _validationError {
    if (modifierKey != null &&
        !DictationHotKeyModifier.isValid(modifierKey!.key)) {
      return 'Invalid modifier key. Use a modifier like \u2325, \u2318, \u21e7, or \u2303.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final error = _validationError;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: kCardColor,
            border: Border.all(
              color: error != null
                  ? const Color(0xFFFF3B30)
                  : const Color(0xFFC7C7CC),
            ),
            borderRadius: BorderRadius.circular(7),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: KeyboardListener(
            focusNode: focusNode,
            onKeyEvent: (value) {
              final drawable = makeDrawable(value);
              if (value is KeyUpEvent) {
                setState(() {
                  if (modifierKey == null) {
                    modifierKey = drawable;
                  } else {
                    keyboardKey ??= drawable;
                  }
                });
              }
            },
            child: Row(
              children: [
                _selectedKeys,
                Spacer(),
                TextButton(
                  onPressed: _toggleRecording,
                  child: _recording
                      ? const Icon(
                          CupertinoIcons.stop,
                          size: 14,
                          color: Color(0xFFFF3B30),
                        )
                      : Text(
                          'Click to record',
                          style: TextStyle(fontSize: 12, color: kTextTertiary),
                        ),
                ),
              ],
            ),
          ),
        ),
        if (error != null) ...[
          const SizedBox(height: 4),
          Text(
            error,
            style: const TextStyle(fontSize: 11, color: Color(0xFFFF3B30)),
          ),
        ],
      ],
    );
  }
}

class _LevelMeter extends StatelessWidget {
  const _LevelMeter();

  static const List<Color> _colors = [
    Color(0xFFC7C7CC),
    Color(0xFFC7C7CC),
    Color(0xFFC7C7CC),
    Color(0xFFC7C7CC),
    kGreen,
    kGreen,
    kOrange,
    Color(0xFFC7C7CC),
    Color(0xFFC7C7CC),
    Color(0xFFC7C7CC),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 14,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final color in _colors) ...[
            Container(
              width: 3,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            if (color != _colors.last) const SizedBox(width: 2),
          ],
        ],
      ),
    );
  }
}
