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

/// Fired when the user taps the counter button to increment it.
/// Takes no parameters to prove Equatable does not drop duplicate events.
final class ProductDetailCounterIncremented extends ProductDetailEvent {
  const ProductDetailCounterIncremented();
}
