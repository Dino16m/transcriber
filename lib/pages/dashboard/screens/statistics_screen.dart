import 'package:flutter/material.dart';

import 'common.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsScreen(
      title: 'Statistics',
      subtitle: 'Drawn from your local dictation history.',
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: Row(
            children: [
              Expanded(child: _Stat(number: '1,284', label: 'Total words dictated')),
              SizedBox(width: 12),
              Expanded(child: _Stat(number: '96', label: 'Dictation sessions')),
              SizedBox(width: 12),
              Expanded(child: _Stat(number: '13.4', label: 'Words per session')),
              SizedBox(width: 12),
              Expanded(child: _Stat(number: '14', label: 'Days active')),
            ],
          ),
        ),
        const _SessionsChart(),
        const SizedBox(height: 20),
        SettingsGroup(
          title: 'Model usage',
          children: const [
            _UsageRow(
              name: 'Base',
              description: 'Fast · everyday dictation',
              sessions: '71 sessions',
              ok: true,
            ),
            _UsageRow(
              name: 'Medium',
              description: 'Accurate · formal writing',
              sessions: '19 sessions',
              ok: false,
            ),
            _UsageRow(
              name: 'Tiny',
              description: 'Fastest · quick notes',
              sessions: '6 sessions',
              ok: true,
            ),
          ],
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.number, required this.label});

  final String number;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCardColor,
        border: Border.all(color: kSeparator),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            number,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              letterSpacing: -1,
              color: kTextPrimary,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: kTextSecondary),
          ),
        ],
      ),
    );
  }
}

class _SessionsChart extends StatelessWidget {
  const _SessionsChart();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: kCardColor,
        border: Border.all(color: kSeparator),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sessions · last 7 days',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: kTextPrimary,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 130,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                _BarColumn(label: 'Sun', height: 39),
                _BarColumn(label: 'Mon', height: 71),
                _BarColumn(label: 'Tue', height: 52),
                _BarColumn(label: 'Wed', height: 91),
                _BarColumn(label: 'Thu', height: 110),
                _BarColumn(label: 'Fri', height: 78),
                _BarColumn(label: 'Sat', height: 58, dim: true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BarColumn extends StatelessWidget {
  const _BarColumn({
    required this.label,
    required this.height,
    this.dim = false,
  });

  final String label;
  final double height;
  final bool dim;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: height,
            width: 26,
            decoration: BoxDecoration(
              color: dim ? const Color(0xFFD7D7DC) : kAccent,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(5),
                bottom: Radius.circular(3),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: kTextSecondary),
          ),
        ],
      ),
    );
  }
}

class _UsageRow extends StatelessWidget {
  const _UsageRow({
    required this.name,
    required this.description,
    required this.sessions,
    required this.ok,
  });

  final String name;
  final String description;
  final String sessions;
  final bool ok;

  @override
  Widget build(BuildContext context) {
    return SettingRow(
      title: name,
      description: description,
      trailing: PillBadge(
        label: sessions,
        color: ok ? const Color(0xFF1E8A3D) : const Color(0xFFC26A00),
        background: ok
            ? const Color(0x2434C759)
            : const Color(0x26FF9500),
      ),
    );
  }
}
