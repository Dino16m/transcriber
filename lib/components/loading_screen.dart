import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:transcriber/common/logging.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key, required this.loadingText, this.progress});

  final String loadingText;
  final double? progress;

  Widget get _progressWidget {
    if (progress == null) return ProgressCircle(value: null);
    return ProgressBar(value: progress! * 100);
  }

  @override
  Widget build(BuildContext context) {
    logger.d("Progress bar $progress");
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _progressWidget,
          Padding(
            padding: EdgeInsetsGeometry.only(top: 10),
            child: Text(loadingText),
          ),
        ],
      ),
    );
  }
}
