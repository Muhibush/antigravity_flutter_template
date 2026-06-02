import 'package:equatable/equatable.dart';
import 'package:example_blue_print_app/pages/product_list/model/product_model.dart';

/// Status enum for the Product Detail BLoC state.
enum ProductDetailStatus { initial, loading, success, failure }

/// State for the Product Detail BLoC.
class ProductDetailState extends Equatable {
  const ProductDetailState({
    this.status = ProductDetailStatus.initial,
    this.product,
    this.errorMessage = '',
  });

  final ProductDetailStatus status;
  final ProductModel? product;
  final String errorMessage;

  ProductDetailState copyWith({
    ProductDetailStatus? status,
    ProductModel? product,
    String? errorMessage,
  }) {
    return ProductDetailState(
      status: status ?? this.status,
      product: product ?? this.product,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, product, errorMessage];
}
