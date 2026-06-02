import 'package:example_blue_print_app/core/theme/app_colors.dart';
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
      child: const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      ),
    );
  }
}
