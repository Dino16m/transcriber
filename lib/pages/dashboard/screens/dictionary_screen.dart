import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

import 'common.dart';

class DictionaryScreen extends StatelessWidget {
  const DictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsScreen(
      title: 'Dictionary',
      subtitle:
          'Teach Dictate the words it keeps getting wrong \u2014 names, '
          'products, and jargon.',
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              const Expanded(child: SearchBox(placeholder: 'Search words')),
              const SizedBox(width: 8),
              PushButton(
                controlSize: ControlSize.large,
                color: kAccent,
                onPressed: () {},
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(CupertinoIcons.add, size: 13, color: Colors.white),
                    SizedBox(width: 5),
                    Text('Add word'),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SettingsCard(
          children: [
            _DictionaryHeader(),
            _DictionaryRow(wrong: 'amid', right: 'Amit'),
            _DictionaryRow(wrong: 'sub text', right: 'Subtext'),
            _DictionaryRow(wrong: 'deep seek', right: 'DeepSeek'),
            _DictionaryRow(wrong: 'carrage', right: 'Karaage'),
          ],
        ),
      ],
    );
  }
}

class _DictionaryHeader extends StatelessWidget {
  const _DictionaryHeader();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'You said',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: kTextSecondary,
                letterSpacing: 0.4,
              ),
            ),
          ),
          SizedBox(width: 24),
          Expanded(
            child: Text(
              'Correct to',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: kTextSecondary,
                letterSpacing: 0.4,
              ),
            ),
          ),
          SizedBox(width: 60),
        ],
      ),
    );
  }
}

class _DictionaryRow extends StatelessWidget {
  const _DictionaryRow({required this.wrong, required this.right});

  final String wrong;
  final String right;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              wrong,
              style: const TextStyle(
                fontSize: 13,
                color: kTextSecondary,
                decoration: TextDecoration.lineThrough,
                decorationColor: Color(0x80FF3B30),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Icon(
              CupertinoIcons.chevron_right,
              size: 14,
              color: kTextTertiary,
            ),
          ),
          Expanded(
            child: Text(
              right,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: kTextPrimary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const _RowAction(icon: CupertinoIcons.pencil),
          const _RowAction(icon: CupertinoIcons.delete),
        ],
      ),
    );
  }
}

class _RowAction extends StatelessWidget {
  const _RowAction({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      alignment: Alignment.center,
      child: Icon(icon, size: 14, color: kTextSecondary),
    );
  }
}
