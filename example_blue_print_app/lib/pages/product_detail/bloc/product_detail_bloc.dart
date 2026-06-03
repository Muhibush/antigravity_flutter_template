import 'package:example_blue_print_app/pages/product_detail/bloc/product_detail_event.dart';
import 'package:example_blue_print_app/pages/product_detail/bloc/product_detail_state.dart';
import 'package:example_blue_print_app/shared/repositories/product_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// BLoC for the Product Detail feature.
class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  ProductDetailBloc({required ProductRepository productRepository})
    : _productRepository = productRepository,
      super(const ProductDetailState()) {
    on<ProductDetailFetchRequested>(_onFetchRequested);
    on<ProductDetailCounterIncremented>(_onCounterIncremented);
  }

  final ProductRepository _productRepository;

  void _onCounterIncremented(
    ProductDetailCounterIncremented event,
    Emitter<ProductDetailState> emit,
  ) {
    // This print proves that duplicate events are NOT dropped
    print('🔥 BLoC Event Received: ProductDetailCounterIncremented');
    emit(state.copyWith(counter: state.counter + 1));
  }

  Future<void> _onFetchRequested(
    ProductDetailFetchRequested event,
    Emitter<ProductDetailState> emit,
  ) async {
    emit(state.copyWith(status: ProductDetailStatus.loading));

    final result = await _productRepository.getProductById(event.productId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProductDetailStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (product) => emit(
        state.copyWith(
          status: ProductDetailStatus.success,
          product: product,
        ),
      ),
    );
  }
}
