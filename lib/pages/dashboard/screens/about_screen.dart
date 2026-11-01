import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'common.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsScreen(
      title: 'About',
      subtitle: '',
      children: [
        Container(
          decoration: BoxDecoration(
            color: kCardColor,
            border: Border.all(color: kSeparator),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          child: Column(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF3A7DFF), Color(0xFF5A4BFF)],
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x593A7DFF),
                      blurRadius: 24,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  CupertinoIcons.mic,
                  size: 34,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Dictate',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: kTextPrimary,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Version 1.0 · Local-first dictation',
                style: TextStyle(fontSize: 12, color: kTextSecondary),
              ),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0x1434C759),
                  border: Border.all(color: const Color(0x4034C759)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          CupertinoIcons.lock,
                          size: 16,
                          color: Color(0xFF1E8A3D),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Everything happens on your device',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E8A3D),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Your audio is transcribed locally, cleaned up locally, '
                      'and stored locally. No audio or text ever leaves your Mac.',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: kTextSecondary,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Column(
                children: [
                  _Fact(label: 'Speech-to-text', value: 'Whisper · offline'),
                  _Fact(label: 'Cleanup pass', value: 'Local grammar engine'),
                  _Fact(label: 'History storage', value: 'On-device database'),
                  _Fact(label: 'Text insertion', value: 'macOS Accessibility'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: kSeparator)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: kTextSecondary),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: kTextPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
