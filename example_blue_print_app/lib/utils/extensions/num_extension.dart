/// Number extensions for formatting.
extension NumExtension on num {
  /// Formats the number as a currency string.
  /// Example: `99.9.toCurrency()` → `$99.90`
  String toCurrency({String symbol = r'$', int decimals = 2}) {
    return '$symbol${toStringAsFixed(decimals)}';
  }

  /// Formats the number with compact notation.
  /// Example: `1200.toCompact()` → `1.2K`
  String toCompact() {
    if (this >= 1000000) {
      return '${(this / 1000000).toStringAsFixed(1)}M';
    } else if (this >= 1000) {
      return '${(this / 1000).toStringAsFixed(1)}K';
    }
    return toString();
  }
}
