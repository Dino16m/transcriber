import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';

import 'common.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsScreen(
      title: 'History',
      subtitle: 'Everything you\u2019ve dictated, stored locally and searchable.',
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              const Expanded(
                child: SearchBox(placeholder: 'Search dictation history'),
              ),
              const SizedBox(width: 8),
              PushButton(
                controlSize: ControlSize.large,
                secondary: true,
                onPressed: () {},
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      CupertinoIcons.delete,
                      size: 13,
                      color: kTextSecondary,
                    ),
                    SizedBox(width: 5),
                    Text('Clear'),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SettingsCard(
          children: [
            _HistoryItem(
              time: 'Today · 9:41 AM',
              clean: 'I think we should meet on Tuesday.',
              raw: 'so, um, I think we should, uh, meet on Tuesday',
            ),
            _HistoryItem(
              time: 'Today · 9:28 AM',
              clean:
                  'Dear Sam,\n\nThanks for your help this week.\nBest,\nAlex',
              raw:
                  'Dear Sam, new paragraph, thanks for your help this week, new line, best, Alex',
            ),
            _HistoryItem(
              time: 'Today · 9:12 AM',
              clean: 'Shopping list:',
              listItems: ['Buy milk', 'Walk the dog', 'Call mum'],
              raw: 'first buy milk, second walk the dog, third call mum',
            ),
            _HistoryItem(
              time: 'Yesterday · 6:03 PM',
              clean: 'Please review the pull request when you get a chance.',
            ),
            _HistoryItem(
              time: 'Yesterday · 4:47 PM',
              clean: 'Ship the onboarding flow by Friday.',
            ),
          ],
        ),
      ],
    );
  }
}

class _HistoryItem extends StatelessWidget {
  const _HistoryItem({
    required this.time,
    required this.clean,
    this.listItems,
    this.raw,
  });

  final String time;
  final String clean;
  final List<String>? listItems;
  final String? raw;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            time,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: kTextSecondary,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            clean,
            style: const TextStyle(
              fontSize: 13,
              height: 1.45,
              color: kTextPrimary,
            ),
          ),
          if (listItems != null) ...[
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final item in listItems!)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1),
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: kTextPrimary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
          if (raw != null) ...[
            const SizedBox(height: 4),
            Text(
              'Raw  ·  $raw',
              style: const TextStyle(
                fontSize: 12,
                height: 1.4,
                color: kTextSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
