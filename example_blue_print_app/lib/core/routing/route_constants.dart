/// All route path constants in one place.
///
/// Centralizes route definitions so paths are never hardcoded
/// throughout the codebase. Use these with `context.go()` or
/// `context.goNamed()`.
abstract class RouteConstants {
  // ── Product List ──
  static const String productList = '/products';
  static const String productListName = 'product-list';

  // ── Product Detail ──
  static const String productDetail = '/products/:id';
  static const String productDetailName = 'product-detail';

  /// Helper to build a product detail path for a given [id].
  static String productDetailPath(int id) => '/products/$id';
}
