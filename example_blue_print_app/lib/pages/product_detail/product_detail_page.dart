import 'package:example_blue_print_app/core/network/api_provider.dart';
import 'package:example_blue_print_app/core/theme/app_colors.dart';
import 'package:example_blue_print_app/core/theme/app_typography.dart';
import 'package:example_blue_print_app/pages/product_detail/bloc/product_detail_bloc.dart';
import 'package:example_blue_print_app/pages/product_detail/bloc/product_detail_event.dart';
import 'package:example_blue_print_app/pages/product_detail/bloc/product_detail_state.dart';
import 'package:example_blue_print_app/pages/product_list/repository/product_repository.dart';
import 'package:example_blue_print_app/shared/widgets/app_error_widget.dart';
import 'package:example_blue_print_app/shared/widgets/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// The main entry point for the Product Detail feature.
class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({required this.productId, super.key});

  final int productId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductDetailBloc(
        productRepository: ProductRepository(
          apiProvider: ApiProvider(),
        ),
      )..add(ProductDetailFetchRequested(productId: productId)),
      child: const _ProductDetailView(),
    );
  }
}

class _ProductDetailView extends StatelessWidget {
  const _ProductDetailView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Detail'),
      ),
      body: BlocBuilder<ProductDetailBloc, ProductDetailState>(
        builder: (context, state) {
          switch (state.status) {
            case ProductDetailStatus.initial:
            case ProductDetailStatus.loading:
              return const LoadingOverlay();
            case ProductDetailStatus.failure:
              return AppErrorWidget(
                message: state.errorMessage,
                onRetry: () {
                  if (state.product != null) {
                    context.read<ProductDetailBloc>().add(
                          ProductDetailFetchRequested(
                            productId: state.product!.id,
                          ),
                        );
                  }
                },
              );
            case ProductDetailStatus.success:
              final product = state.product!;
              return SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Product Image ──
                    Center(
                      child: Container(
                        height: 250.h,
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Image.network(
                          product.image,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // ── Category Badge ──
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        product.category.toUpperCase(),
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // ── Title ──
                    Text(product.title, style: AppTypography.heading2),
                    SizedBox(height: 16.h),

                    // ── Price & Rating Row ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: AppTypography.heading1.copyWith(
                            color: AppColors.primaryDark,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.star_rounded,
                              size: 20.r,
                              color: AppColors.warning,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              '${product.rating.rate}',
                              style: AppTypography.bodyLarge.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              '(${product.rating.count} reviews)',
                              style: AppTypography.caption.copyWith(
                                color: AppColors.textSecondaryLight,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),

                    // ── Description ──
                    Text('Description', style: AppTypography.heading3),
                    SizedBox(height: 8.h),
                    Text(
                      product.description,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              );
          }
        },
      ),
    );
  }
}
