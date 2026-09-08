import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_whisper_kit/flutter_whisper_kit.dart';
import "package:path_provider/path_provider.dart";
import 'package:transcriber/common/exceptions.dart';
import 'package:transcriber/common/logging.dart';

Future<String> getAssetFileAbsolutePath(String assetPath) async {
  final Directory appSupportDir = await getApplicationSupportDirectory();
  final String filePath = '${appSupportDir.path}/${assetPath.split('/').last}';

  final File file = File(filePath);
  if (await file.exists()) {
    return file.path;
  }

  final ByteData data = await rootBundle.load(assetPath);
  final List<int> bytes = data.buffer.asUint8List(
    data.offsetInBytes,
    data.lengthInBytes,
  );
  await file.writeAsBytes(bytes);
  return file.path;
}

Future<FlutterWhisperKit> initWhisper() async {
  final whisperKit = FlutterWhisperKit();
  try {
    // Load a model
    logger.d("Loading model");
    await whisperKit.loadModel(
      'small', // Model size: tiny, base, small, medium, large-v2, large-v3
      onProgress: (progress) {
        logger.i(
          "Loading model ${(progress.fractionCompleted * 100).toStringAsFixed(1)}%",
        );
      },
    );
    logger.d("Model loaded");
  } on WhisperKitError catch (e) {
    logger.i("Failed to load model ${e.message} ${e.toString()}");
    throw ApplicationError("Failed to download model");
  }

  try {
    await whisperKit.prewarmModels();
  } on WhisperKitError catch (e) {
    logger.i("Failed to prewarm model ${e.message}");
    throw ApplicationError("Failed to download model");
  }

  return whisperKit;
}
