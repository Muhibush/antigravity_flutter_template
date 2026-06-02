import 'package:example_blue_print_app/core/theme/app_colors.dart';
import 'package:example_blue_print_app/core/theme/app_typography.dart';
import 'package:example_blue_print_app/pages/product_list/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A card widget displaying a product summary in the list.
///
/// This is a feature-specific widget, so it lives inside
/// `pages/product_list/widget/` — NOT in `shared/widgets/`.
class ProductCard extends StatelessWidget {
  const ProductCard({
    required this.product,
    required this.onTap,
    super.key,
  });

  final ProductModel product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Row(
            children: [
              // ── Product Image ──
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.network(
                  product.image,
                  width: 80.w,
                  height: 80.w,
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => Container(
                    width: 80.w,
                    height: 80.w,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundLight,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      size: 32.r,
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),

              // ── Product Info ──
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      product.category.toUpperCase(),
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: AppTypography.price.copyWith(
                            color: AppColors.primaryDark,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.star_rounded,
                              size: 16.r,
                              color: AppColors.warning,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              '${product.rating.rate}',
                              style: AppTypography.caption,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ── Arrow ──
              Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textSecondaryLight,
                  size: 24.r,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
