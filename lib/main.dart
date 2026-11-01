import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_whisper_kit/flutter_whisper_kit.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transcriber/common/config/app_config.dart';
import 'package:transcriber/common/controllers/pipeline.dart';
import 'package:transcriber/common/controllers/text_injector.dart';
import 'package:transcriber/common/controllers/whisper_extension.dart';
import 'package:transcriber/common/controllers/hot_key_controller.dart';
import 'package:transcriber/common/exceptions.dart';
import 'package:transcriber/common/logging.dart';
import 'package:transcriber/common/notification.dart';
import 'package:onde_inference/onde_inference.dart';
import 'package:transcriber/common/state/app_config_state.dart';
import 'package:transcriber/components/error_screen.dart';
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
  await OndeInference.init();
  final preferences = await SharedPreferences.getInstance();
  final configStore = AppConfigStore(preferences);
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppConfigState(configStore),
      child: const MyApp(),
    ),
  );
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

enum HomePageState { initialized, error, loading }

class _MyHomePageState extends State<MyHomePage> {
  HomePageState pageState = HomePageState.loading;

  String? error;

  DictationHotKey? _hotKey;
  String? _transcriptionModel;
  String? _cleanupModel;
  double? loadingProgress = 0;
  late final FlutterWhisperKit _whisper;

  @override
  void initState() {
    initialize();
    super.initState();
  }

  Future<void> onChange() async {
    final config = context.read<AppConfigState>();
    if (config.dictationHotKey == null) {
      dictationHotKeyManager.clearHotKey();
    }
    if (config.dictationHotKey != null && config.dictationHotKey != _hotKey) {
      await dictationHotKeyManager.setHotKey(config.dictationHotKey!);
    }
    if (config.transcriptionModel != null &&
        config.transcriptionModel != _transcriptionModel) {
      reloadWhisper(_whisper, config.transcriptionModel);
    }
  }

  Future<void> initialize() async {
    setState(() {
      pageState = HomePageState.loading;
      error = null;
      loadingProgress = 0;
    });
    final config = context.read<AppConfigState>();
    if (config.dictationHotKey != null) {
      await dictationHotKeyManager.setHotKey(config.dictationHotKey!);
    }
    AudioRecorder().hasPermission();

    try {
      final whisper = await initWhisper(
        config.transcriptionModel,
        onProgress: (progress) {
          setState(() {
            loadingProgress = progress;
          });
        },
      );
      final pipeline = DictationPipeline(whisper, TextInjector());
      dictationHotKeyManager.setController(pipeline);
      setState(() {
        _whisper = whisper;
      });
    } on ApplicationError catch (e) {
      logger.i("Failed to initialize transcription model $e");
      setState(() {
        error = "Failed to initialize transcription model";
        pageState = HomePageState.error;
      });
      return;
    }
    setState(() {
      pageState = HomePageState.initialized;
      _cleanupModel = config.cleanupModel;
      _transcriptionModel = config.transcriptionModel;
      _hotKey = config.dictationHotKey;
      error = null;
    });
    config.addListener(onChange);
  }

  Widget get _currentScreen {
    switch (pageState) {
      case HomePageState.initialized:
        return Dashboard();
      case HomePageState.error:
        return ErrorScreen(
          message: error ?? "Unknown error",
          onRetry: initialize,
        );
      case HomePageState.loading:
        return LoadingScreen(
          loadingText: "Initializing...",
          progress: loadingProgress,
        );
    }
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
