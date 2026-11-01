# Transcriber

On-device dictation for macOS. Hold down a hotkey, speak, and your words are
transcribed locally and inserted wherever you're typing — either typed directly
into the focused field or copied to the clipboard for you to paste.

Everything runs on your Mac: no audio or text ever leaves the device.

## Features

- **Hold-to-talk dictation** — press and hold a configurable hotkey to record,
  release it to insert the transcription. Real-time transcription streams in as
  you speak.
- **100% offline** — speech-to-text runs through [Whisper](https://github.com/openai/whisper)
  via `flutter_whisper_kit`; a local cleanup pass adds punctuation, casing, and
  removes filler words.
- **Flexible insertion** — type directly into the focused field using macOS
  Accessibility, or fall back to the clipboard (pastes via simulated `⌘V`).
- **Configurable models** — choose from Tiny, Base, Small, Medium, and Large-v3
  transcription models, plus a separate local cleanup model.
- **Personal dictionary** — teach it the names, products, and jargon it keeps
  getting wrong.
- **Searchable history & statistics** — every dictation is stored locally and
  browsable, with usage stats drawn from your own history.
- **Native macOS feel** — `macos_ui` settings window with a sidebar and menu-bar
  tray integration.

## How it works

1. Press and hold your dictation hotkey (configured under **General**).
2. Audio is captured from your microphone and transcribed in real time.
3. On release, a local cleanup pass polishes the text.
4. The result is typed into the focused field, or copied to the clipboard.

## Requirements

- macOS (Apple Silicon recommended for larger models)
- [Flutter](https://flutter.dev) SDK with macOS desktop support enabled
- **Accessibility permission** — required to type text directly into other
  applications. Grant it in *System Settings → Privacy & Security → Accessibility*
  when prompted. Without it, insertion can fall back to the clipboard.
- **Microphone permission** — required to capture audio.

## Getting started

```bash
# Install dependencies
flutter pub get

# Run on macOS
flutter run -d macos

# Build a release bundle
flutter build macos
```

On first launch the app downloads the selected Whisper model to your application
support directory, then prewarms it for low-latency dictation.

## Configuration

All settings are persisted locally via `shared_preferences` and available from
the sidebar:

| Screen       | What it controls                                                          |
| ------------ | ------------------------------------------------------------------------- |
| General      | Hold-to-talk hotkey, microphone input, insertion behavior, start sound     |
| Models       | Transcription model (Tiny → Large-v3) and cleanup model (Basic → Pro)      |
| Formatting   | Filler removal, auto-capitalization, voice commands, list formatting       |
| Dictionary   | "You said → Correct to" word substitutions                                 |
| History      | Searchable, clearable local dictation history                              |
| Statistics   | Words dictated, sessions, model usage, and activity charts                 |

### Whisper model sizes

| Model     | Size   | Notes                                    |
| --------- | ------ | ---------------------------------------- |
| Tiny      | 75 MB  | Fastest, best for older Macs              |
| Base      | 142 MB | Default; good accuracy for everyday use   |
| Small     | 466 MB | Balanced step up from Base                |
| Medium    | 1.5 GB | More accurate, better on accents          |
| Large-v3  | 2.9 GB | Most accurate, needs Apple Silicon        |

## Tech stack

- **Flutter** + `macos_ui` for a native macOS interface
- **`flutter_whisper_kit`** for on-device Whisper transcription
- **`onde_inference`** for the local cleanup pass
- **`hotkey_manager`** / **`flutter_hotkeys`** for the system-wide hotkey
- **`record`** for audio capture, **`tray_manager`** for menu-bar integration
- **`provider`** + **`shared_preferences`** for state and persistence
- Native Swift (`AppDelegate`) for text injection via `CGEvent` and the clipboard

## Project structure

```
lib/
├── main.dart                          # App entry point and initialization
├── common/
│   ├── config/app_config.dart         # Persisted configuration store
│   ├── controllers/
│   │   ├── hot_key_controller.dart    # Hotkey registration & dictation lifecycle
│   │   ├── pipeline.dart              # Record → transcribe → cleanup → insert
│   │   ├── text_injector.dart         # Clipboard / typing method channel
│   │   └── whisper_extension.dart     # Whisper model load & prewarm
│   └── state/app_config_state.dart    # ChangeNotifier over config
├── components/                        # Loading & error screens
└── pages/dashboard/                   # Sidebar + settings screens
macos/Runner/AppDelegate.swift         # Native text injection & paste handling
```

## Privacy

The app is sandboxed and does not require network access for transcription or
cleanup (models are downloaded once and cached). Audio, transcriptions, and
history are all stored locally on your Mac.
