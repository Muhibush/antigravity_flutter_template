import 'package:equatable/equatable.dart';
import 'package:example_blue_print_app/shared/models/product_model.dart';

/// Status enum for the BLoC state.
///
/// Blueprint Rule: DO NOT use sealed classes or Freezed for state matching.
/// DO use a single State class with an enum for status and a `copyWith`.
/// This allows retaining data (like the product list) while showing
/// a loading spinner — the official bloclibrary.dev recommendation.
enum BlocStatus { initial, loading, success, failure }

/// State for the Product List BLoC.
class ProductListState extends Equatable {
  const ProductListState({
    this.status = BlocStatus.initial,
    this.products = const [],
    this.errorMessage = '',
  });

  /// Current loading/error status.
  final BlocStatus status;

  /// The list of products fetched from the API.
  final List<ProductModel> products;

  /// Error message when [status] is [BlocStatus.failure].
  final String errorMessage;

  /// Creates a copy with the given fields replaced.
  ProductListState copyWith({
    BlocStatus? status,
    List<ProductModel>? products,
    String? errorMessage,
  }) {
    return ProductListState(
      status: status ?? this.status,
      products: products ?? this.products,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, products, errorMessage];
}
