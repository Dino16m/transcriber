import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key, required this.loadingText});

  final String loadingText;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ProgressCircle(value: null),
          Padding(
            padding: EdgeInsetsGeometry.only(top: 10),
            child: Text(loadingText),
          ),
        ],
      ),
    );
  }
}
