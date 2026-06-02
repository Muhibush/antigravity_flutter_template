import 'package:flutter/services.dart';

/// A [TextInputFormatter] that prevents leading zeros in numeric input.
///
/// Use case: phone numbers, quantity fields, etc.
/// Example: `"007"` → `"7"`, `"0"` stays as `"0"`.
class NoLeadingZeroFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;

    // Remove leading zeros but allow a single "0"
    final trimmed = newValue.text.replaceFirst(RegExp(r'^0+(?=\d)'), '');

    return TextEditingValue(
      text: trimmed,
      selection: TextSelection.collapsed(offset: trimmed.length),
    );
  }
}
