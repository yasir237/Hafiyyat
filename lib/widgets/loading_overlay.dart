// lib/widgets/loading_overlay.dart
import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final String loadingText;
  final Color loadingTextColor;
  final Widget child;
  final String? progressText;

  const LoadingOverlay({
    Key? key,
    required this.isLoading,
    required this.loadingText,
    required this.loadingTextColor,
    required this.child,
    this.progressText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF64FFDA)),
                    strokeWidth: 3,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    progressText ?? loadingText,
                    style: TextStyle(
                      color: loadingTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.6),
                          offset: const Offset(0, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}