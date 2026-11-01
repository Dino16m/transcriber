import 'package:shared_preferences/shared_preferences.dart';
import 'package:transcriber/common/controllers/hot_key_controller.dart';

class AppConfigStore {
  final SharedPreferences _preferences;
  new(this._preferences);

  Future<void> setHotKey(DictationHotKey hotKey) async {
    await _preferences.setString(
      "dictation_hot_key",
      serializeDictationHotKey(hotKey),
    );
  }

  DictationHotKey? get dictationHotKey {
    final serialized = _preferences.getString("dictation_hot_key");
    if (serialized == null) {
      return null;
    }
    try {
      return deserializeDictationHotKey(serialized);
    } on FormatException {
      return null;
    }
  }

  Future<void> setTranscriptionModel(String model) async {
    await _preferences.setString("transcription_model", model);
  }

  String? get transcriptionModel =>
      _preferences.getString("transcription_model");

  Future<void> setCleanupModel(String model) async {
    await _preferences.setString("cleanup_model", model);
  }

  String? get cleanupModel => _preferences.getString("cleanup_model");
}
