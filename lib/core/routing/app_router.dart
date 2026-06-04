import 'package:antigravity_app/core/routing/route_constants.dart';
import 'package:antigravity_app/pages/product_detail/product_detail_page.dart';
import 'package:antigravity_app/pages/product_list/product_list_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Declarative routing configuration using GoRouter.
///
/// GoRouter natively handles Deep Links and Universal Links.
/// Simply define your route paths with parameters (e.g., `/products/:id`).
/// When the OS receives a deep link, GoRouter automatically intercepts it,
/// extracts the ID, and navigates to the correct page.
class AppRouter {
  AppRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RouteConstants.productList,
    routes: [
      GoRoute(
        path: RouteConstants.productList,
        name: RouteConstants.productListName,
        builder: (context, state) => const ProductListPage(),
      ),
      GoRoute(
        path: RouteConstants.productDetail,
        name: RouteConstants.productDetailName,
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return ProductDetailPage(productId: id);
        },
      ),
    ],
  );
}
