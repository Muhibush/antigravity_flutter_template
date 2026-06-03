import 'package:flutter/material.dart';

/// A reusable loading overlay that displays a centered spinner
/// with a semi-transparent background.
///
/// Usage:
/// ```dart
/// Stack(
///   children: [
///     YourContent(),
///     if (isLoading) const LoadingOverlay(),
///   ],
/// )
/// ```
class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black.withValues(alpha: 0.3),
      child: Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
