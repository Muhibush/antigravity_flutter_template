import 'package:example_blue_print_app/core/theme/app_colors.dart';
import 'package:example_blue_print_app/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A reusable custom button with loading state support.
///
/// Supports full-width mode, custom colors, and an automatic
/// loading spinner that replaces the label text.
class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.isLoading = false,
    this.isFullWidth = true,
    this.backgroundColor,
    this.foregroundColor,
    this.icon,
  });

  /// The button label text.
  final String label;

  /// Callback when pressed. Disabled when [isLoading] is true.
  final VoidCallback? onPressed;

  /// Whether to show a loading spinner instead of the label.
  final bool isLoading;

  /// Whether the button stretches to fill its parent width.
  final bool isFullWidth;

  /// Override for the background color.
  final Color? backgroundColor;

  /// Override for the text/icon color.
  final Color? foregroundColor;

  /// Optional leading icon.
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.primary,
        foregroundColor: foregroundColor ?? Colors.white,
        disabledBackgroundColor: AppColors.primaryLight,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      child: isLoading
          ? SizedBox(
              width: 20.r,
              height: 20.r,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18.r),
                  SizedBox(width: 8.w),
                ],
                Text(label, style: AppTypography.labelLarge),
              ],
            ),
    );

    if (isFullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }

    return button;
  }
}
