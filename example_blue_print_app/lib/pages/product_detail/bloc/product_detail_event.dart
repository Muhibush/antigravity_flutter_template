import 'package:equatable/equatable.dart';

/// Events for the Product Detail BLoC.
sealed class ProductDetailEvent extends Equatable {
  const ProductDetailEvent();

  @override
  List<Object?> get props => [];
}

/// Fired when the product detail page is opened and needs
/// to fetch the product data.
final class ProductDetailFetchRequested extends ProductDetailEvent {
  const ProductDetailFetchRequested({required this.productId});

  final int productId;

  @override
  List<Object?> get props => [productId];
}
