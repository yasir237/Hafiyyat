// lib/widgets/loading_overlay.dart
import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final String loadingText;
  final Color? loadingTextColor;
  final Widget child;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.loadingText,
    required this.child,
    this.loadingTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF64FFDA)),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    loadingText,
                    style: TextStyle(
                      color: loadingTextColor ?? Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}