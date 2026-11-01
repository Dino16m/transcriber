import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';

import 'common.dart';

class ModelsScreen extends StatelessWidget {
  const ModelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsScreen(
      title: 'Models',
      subtitle:
          'Speech-to-text and cleanup run entirely on your device. Larger '
          'models are more accurate but slower and need more space.',
      children: [
        SettingsGroup(
          title: 'Transcription',
          children: const [
            SettingsCard(
              children: [
                _ModelRow(
                  selected: true,
                  name: 'Base',
                  tag: 'In use',
                  meta: '142 MB · Fast · Good accuracy for everyday dictation',
                  action: _DownloadedAction(),
                ),
                _ModelRow(
                  name: 'Tiny',
                  meta: '75 MB · Fastest · Best for live preview on older Macs',
                  action: _DownloadedAction(),
                ),
                _ModelRow(
                  name: 'Small',
                  meta: '466 MB · Balanced · Recommended step up from Base',
                  action: _DownloadAction(),
                ),
                _ModelRow(
                  name: 'Medium',
                  meta: '1.5 GB · Accurate · Noticeably better on accents',
                  action: _ProgressAction(percent: 0.62),
                ),
                _ModelRow(
                  name: 'Large v3',
                  meta: '2.9 GB · Most accurate · Needs Apple Silicon',
                  action: _DownloadAction(),
                ),
              ],
            ),
          ],
        ),
        SettingsGroup(
          title: 'Cleanup',
          children: const [
            SettingsCard(
              children: [
                _ModelRow(
                  name: 'Basic',
                  meta: '40 MB · Fastest · Removes fillers and fixes casing',
                  action: _DownloadedAction(),
                ),
                _ModelRow(
                  selected: true,
                  name: 'Standard',
                  tag: 'In use',
                  meta: '120 MB · Balanced · Adds punctuation and formatting',
                  action: _DownloadedAction(),
                ),
                _ModelRow(
                  name: 'Pro',
                  meta: '380 MB · Most thorough · Handles lists and voice commands',
                  action: _DownloadAction(),
                ),
              ],
            ),
          ],
        ),
        const _OfflineBadge(),
      ],
    );
  }
}

class _OfflineBadge extends StatelessWidget {
  const _OfflineBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0x1F0A84FF),
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(CupertinoIcons.lock, size: 14, color: kAccentStrong),
          SizedBox(width: 6),
          Text(
            'Models are downloaded once and run 100% offline',
            style: TextStyle(
              fontSize: 12,
              color: kAccentStrong,
            ),
          ),
        ],
      ),
    );
  }
}

class _ModelRow extends StatelessWidget {
  const _ModelRow({
    required this.name,
    required this.meta,
    required this.action,
    this.tag,
    this.selected = false,
  });

  final String name;
  final String? tag;
  final String meta;
  final Widget action;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          RadioCircle(selected: selected),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: kTextPrimary,
                      ),
                    ),
                    if (tag != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0x0D000000),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          tag!,
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: kTextSecondary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  meta,
                  style: const TextStyle(
                    fontSize: 12,
                    color: kTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          action,
        ],
      ),
    );
  }
}

class _DownloadedAction extends StatelessWidget {
  const _DownloadedAction();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          CupertinoIcons.checkmark_circle_fill,
          size: 15,
          color: kGreen,
        ),
        SizedBox(width: 5),
        Text(
          'Downloaded',
          style: TextStyle(fontSize: 12, color: kTextSecondary),
        ),
      ],
    );
  }
}

class _DownloadAction extends StatelessWidget {
  const _DownloadAction();

  @override
  Widget build(BuildContext context) {
    return PushButton(
      controlSize: ControlSize.regular,
      secondary: true,
      onPressed: () {},
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            CupertinoIcons.arrow_down_to_line,
            size: 13,
            color: kAccentStrong,
          ),
          SizedBox(width: 5),
          Text('Download'),
        ],
      ),
    );
  }
}

class _ProgressAction extends StatelessWidget {
  const _ProgressAction({required this.percent});

  final double percent;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          width: 150,
          height: 5,
          decoration: BoxDecoration(
            color: const Color(0xFFE4E4E6),
            borderRadius: BorderRadius.circular(3),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: percent,
            child: Container(
              decoration: BoxDecoration(
                color: kAccent,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Downloading… ${(percent * 100).round()}%',
          style: const TextStyle(fontSize: 11, color: kTextSecondary),
        ),
      ],
    );
  }
}
