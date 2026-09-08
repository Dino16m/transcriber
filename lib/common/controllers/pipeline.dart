import 'package:flutter_whisper_kit/flutter_whisper_kit.dart';
import 'package:transcriber/common/controllers/hot_key_controller.dart';
import 'package:transcriber/common/controllers/text_injector.dart';
import 'package:transcriber/common/logging.dart';

class DictationPipeline implements DictationController {
  final FlutterWhisperKit _whisper;
  final TextInjector _textInjector;
  String transcribedText = "";

  DictationPipeline(this._whisper, this._textInjector);

  Future<void> reset() async {
    await _whisper.clearState();
    transcribedText = "";
  }

  @override
  Future<void> start() async {
    await reset();
    _whisper.transcriptionStream.listen((transcription) {
      logger.i('Real-time transcription: ${transcription.text}');
      if (transcription.text.trim().isNotEmpty) {
        transcribedText = transcription.text;
        logger.i("Setting transcribed text to $transcribedText");
      }
    });
    await _whisper.startRecording(
      options: DecodingOptions(task: DecodingTask.transcribe, language: "en"),
      loop: true,
    );
  }

  @override
  Future<void> stop() async {
    logger.i("Stopping recording");
    await _whisper.stopRecording(loop: true);
    if (transcribedText.isEmpty) {
      logger.i("No transcription produced");
      return;
    }
    logger.d("Transcribed Text \n $transcribedText");
    _textInjector.pasteText(transcribedText);
  }
}
