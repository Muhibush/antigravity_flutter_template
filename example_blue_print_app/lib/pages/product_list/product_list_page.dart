import 'package:example_blue_print_app/core/network/api_provider.dart';
import 'package:example_blue_print_app/core/routing/route_constants.dart';
import 'package:example_blue_print_app/pages/product_list/bloc/product_list_bloc.dart';
import 'package:example_blue_print_app/pages/product_list/bloc/product_list_event.dart';
import 'package:example_blue_print_app/pages/product_list/bloc/product_list_state.dart';
import 'package:example_blue_print_app/pages/product_list/repository/product_repository.dart';
import 'package:example_blue_print_app/pages/product_list/widget/product_card.dart';
import 'package:example_blue_print_app/shared/widgets/app_error_widget.dart';
import 'package:example_blue_print_app/shared/widgets/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// The main entry point for the Product List feature.
///
/// Creates and provides the [ProductListBloc] to the widget tree.
/// The page immediately fires a [ProductListFetchRequested] event
/// to load products on first render.
class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductListBloc(
        productRepository: ProductRepository(
          apiProvider: ApiProvider(),
        ),
      )..add(const ProductListFetchRequested()),
      child: const _ProductListView(),
    );
  }
}

class _ProductListView extends StatelessWidget {
  const _ProductListView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: BlocBuilder<ProductListBloc, ProductListState>(
        builder: (context, state) {
          switch (state.status) {
            case BlocStatus.initial:
            case BlocStatus.loading:
              return const LoadingOverlay();
            case BlocStatus.failure:
              return AppErrorWidget(
                message: state.errorMessage,
                onRetry: () => context
                    .read<ProductListBloc>()
                    .add(const ProductListFetchRequested()),
              );
            case BlocStatus.success:
              return RefreshIndicator(
                onRefresh: () async {
                  context
                      .read<ProductListBloc>()
                      .add(const ProductListRefreshRequested());
                },
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: state.products.length,
                  itemBuilder: (context, index) {
                    final product = state.products[index];
                    return ProductCard(
                      product: product,
                      onTap: () => context.go(
                        RouteConstants.productDetailPath(product.id),
                      ),
                    );
                  },
                ),
              );
          }
        },
      ),
    );
  }
}
