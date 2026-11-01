import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

const Color kTextPrimary = Color(0xFF1D1D1F);
const Color kTextSecondary = Color(0xFF6E6E73);
const Color kTextTertiary = Color(0xFFAEAEB2);
const Color kSeparator = Color(0x14000000);
const Color kCardColor = Color(0xFFFFFFFF);
const Color kAccent = Color(0xFF0A84FF);
const Color kAccentStrong = Color(0xFF0071E3);
const Color kGreen = Color(0xFF34C759);
const Color kRed = Color(0xFFFF3B30);
const Color kOrange = Color(0xFFFF9500);

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 34),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
              color: kTextPrimary,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 13,
              color: kTextSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),
          ...children,
        ],
      ),
    );
  }
}

class SettingsGroup extends StatelessWidget {
  const SettingsGroup({
    super.key,
    required this.title,
    this.chip,
    required this.children,
  });

  final String title;
  final String? chip;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text.rich(
              TextSpan(
                text: title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: kTextPrimary,
                ),
                children: [
                  if (chip != null)
                    TextSpan(
                      text: ' $chip',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: kTextSecondary,
                      ),
                    ),
                ],
              ),
            ),
          ),
          SettingsCard(children: children),
        ],
      ),
    );
  }
}

class SettingsCard extends StatelessWidget {
  const SettingsCard({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final List<Widget> content = [];
    for (int i = 0; i < children.length; i++) {
      content.add(children[i]);
      if (i != children.length - 1) {
        content.add(const Divider(height: 1, thickness: 1, color: kSeparator));
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: kCardColor,
        border: Border.all(color: kSeparator),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: content,
      ),
    );
  }
}

class SettingRow extends StatelessWidget {
  const SettingRow({
    super.key,
    required this.title,
    this.description,
    this.trailing,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
  });

  final String title;
  final String? description;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: kTextPrimary,
                  ),
                ),
                if (description != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    description!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: kTextSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 12),
            trailing!,
          ],
        ],
      ),
    );
  }
}

class ToggleRow extends StatelessWidget {
  const ToggleRow({
    super.key,
    required this.title,
    required this.description,
    this.value = true,
  });

  final String title;
  final String description;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return SettingRow(
      title: title,
      description: description,
      trailing: MacosSwitch(value: value, onChanged: (_) {}),
    );
  }
}

class RadioCircle extends StatelessWidget {
  const RadioCircle({super.key, this.selected = false, this.size = 16});

  final bool selected;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? kAccent : const Color(0xFFC7C7CC),
          width: 1.5,
        ),
      ),
      alignment: Alignment.center,
      child: selected
          ? Container(
              width: size * 0.5,
              height: size * 0.5,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: kAccent,
              ),
            )
          : null,
    );
  }
}

class KeyCap extends StatelessWidget {
  const KeyCap({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0x0D000000),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: kTextSecondary,
        ),
      ),
    );
  }
}

class SearchBox extends StatelessWidget {
  const SearchBox({super.key, required this.placeholder});

  final String placeholder;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      decoration: BoxDecoration(
        color: kCardColor,
        border: Border.all(color: const Color(0xFFC7C7CC)),
        borderRadius: BorderRadius.circular(7),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          const Icon(CupertinoIcons.search, size: 14, color: kTextTertiary),
          const SizedBox(width: 7),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: placeholder,
                hintStyle: const TextStyle(
                  fontSize: 13,
                  color: kTextTertiary,
                ),
              ),
              style: const TextStyle(fontSize: 13, color: kTextPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

class PillBadge extends StatelessWidget {
  const PillBadge({
    super.key,
    required this.label,
    this.color = kAccentStrong,
    this.background = const Color(0x1F0A84FF),
  });

  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
