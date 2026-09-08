import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:record/record.dart';
import 'package:transcriber/common/controllers/pipeline.dart';
import 'package:transcriber/common/controllers/text_injector.dart';
import 'package:transcriber/common/controllers/whisper_extension.dart';
import 'package:transcriber/common/controllers/hot_key_controller.dart';
import 'package:transcriber/common/notification.dart';
import 'package:onde_inference/onde_inference.dart';
import 'package:transcriber/components/loading_screen.dart';
import 'package:transcriber/pages/dashboard/dashboard.dart';

Future<void> _configureMacosWindowUtils() async {
  const config = MacosWindowUtilsConfig();
  await config.apply();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isMacOS) {
    await _configureMacosWindowUtils();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Transcriber',
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Application Home Page'),
      scaffoldMessengerKey: rootScaffoldMessengerKey,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool initialized = false;
  @override
  void initState() {
    initialize();
    super.initState();
  }

  Future<void> initialize() async {
    dictationHotKeyManager.setHotKey(
      DictationHotKeyModifier(PhysicalKeyboardKey.altLeft),
      PhysicalKeyboardKey.keyQ,
    );

    final whisper = await initWhisper();
    AudioRecorder().hasPermission();
    final pipeline = DictationPipeline(whisper, TextInjector());
    dictationHotKeyManager.setController(pipeline);
    setState(() {
      initialized = true;
    });
  }

  Widget get _currentScreen {
    if (initialized) {
      return Dashboard();
    }
    return LoadingScreen(loadingText: "Initializing...");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MacosApp(
        home: _currentScreen,
        color: Color.from(alpha: 0.5, red: 217, green: 210, blue: 241),
      ),
    );
  }
}
