import 'package:flutter/cupertino.dart';

import 'common.dart';

class FormattingScreen extends StatelessWidget {
  const FormattingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsScreen(
      title: 'Formatting',
      subtitle:
          'A local cleanup pass polishes your transcript before it\u2019s '
          'inserted. Nothing is sent to a server.',
      children: [
        SettingsGroup(
          title: 'Cleanup',
          children: const [
            ToggleRow(
              title: 'Remove filler words',
              description: 'Strips \u201cum\u201d, \u201cuh\u201d, \u201clike\u201d',
            ),
            ToggleRow(
              title: 'Auto-capitalize & punctuate',
              description: 'Adds sentence casing and periods',
            ),
            ToggleRow(
              title: 'Expand spoken commands',
              description:
                  '\u201cnew line\u201d and \u201cnew paragraph\u201d become real breaks',
            ),
            ToggleRow(
              title: 'Format spoken lists',
              description:
                  '\u201cfirst\u2026 second\u2026 third\u2026\u201d becomes a numbered list',
            ),
          ],
        ),
        SettingsGroup(
          title: 'Custom voice commands',
          children: const [
            _CommandRow(
              command: '\u201cselect all\u201d',
              description: 'Selects everything in the focused field',
            ),
            _CommandRow(
              command: '\u201cdelete that\u201d',
              description: 'Deletes the last inserted dictation',
            ),
            _CommandRow(
              command: '\u201cundo\u201d',
              description: 'Undoes the last insertion',
            ),
            _AddCommandRow(),
          ],
        ),
      ],
    );
  }
}

class _CommandRow extends StatelessWidget {
  const _CommandRow({required this.command, required this.description});

  final String command;
  final String description;

  @override
  Widget build(BuildContext context) {
    return SettingRow(
      title: command,
      description: description,
      trailing: const PillBadge(label: 'Action'),
    );
  }
}

class _AddCommandRow extends StatelessWidget {
  const _AddCommandRow();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(CupertinoIcons.add, size: 16, color: kAccentStrong),
          SizedBox(width: 4),
          Text(
            'Add command',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: kAccentStrong,
            ),
          ),
        ],
      ),
    );
  }
}
