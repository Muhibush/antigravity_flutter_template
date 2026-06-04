import 'package:antigravity_app/shared/models/product_model.dart';
import 'package:equatable/equatable.dart';

/// Status enum for the Product Detail BLoC state.
enum ProductDetailStatus { initial, loading, success, failure }

/// State for the Product Detail BLoC.
class ProductDetailState extends Equatable {
  const ProductDetailState({
    this.status = ProductDetailStatus.initial,
    this.product,
    this.errorMessage = '',
    this.counter = 0, // Added counter
  });

  final ProductDetailStatus status;
  final ProductModel? product;
  final String errorMessage;
  final int counter; // Added counter

  ProductDetailState copyWith({
    ProductDetailStatus? status,
    ProductModel? product,
    String? errorMessage,
    int? counter,
  }) {
    return ProductDetailState(
      status: status ?? this.status,
      product: product ?? this.product,
      errorMessage: errorMessage ?? this.errorMessage,
      counter: counter ?? this.counter, // Added counter
    );
  }

  @override
  List<Object?> get props => [status, product, errorMessage, counter];
}
