import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({
    super.key,
    required this.message,
    this.onRetry,
  });

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              CupertinoIcons.exclamationmark_triangle_fill,
              size: 40,
              color: Color(0xFFFF9500),
            ),
            const SizedBox(height: 16),
            const Text(
              'Failed to initialize',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF6E6E73),
                height: 1.5,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 20),
              PushButton(
                controlSize: ControlSize.large,
                color: const Color(0xFF0A84FF),
                onPressed: onRetry,
                child: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
