import 'package:flutter/foundation.dart';
import 'package:transcriber/common/config/app_config.dart';
import 'package:transcriber/common/controllers/hot_key_controller.dart';

class AppConfigState with ChangeNotifier, DiagnosticableTreeMixin {
  final AppConfigStore _store;
  String? _transcriptionModel;
  String? _cleanupModel;
  DictationHotKey? _dictationHotKey;

  new(this._store) {
    _cleanupModel = _store.cleanupModel;
    _transcriptionModel = _store.transcriptionModel;
    _dictationHotKey = _store.dictationHotKey;
  }

  String? get transcriptionModel => _transcriptionModel;
  set transcriptionModel(String newTranscriptionModel) {
    _transcriptionModel = newTranscriptionModel;
    notifyListeners();
    _store.setTranscriptionModel(newTranscriptionModel);
  }

  String? get cleanupModel => _cleanupModel;
  set cleanupModel(String newModel) {
    _cleanupModel = newModel;
    notifyListeners();
    _store.setCleanupModel(newModel);
  }

  DictationHotKey? get dictationHotKey => _dictationHotKey;
  set dictationHotKey(DictationHotKey hotKey) {
    _dictationHotKey = hotKey;
    notifyListeners();
    _store.setHotKey(hotKey);
  }
}
