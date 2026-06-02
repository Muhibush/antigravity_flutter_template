import 'package:example_blue_print_app/pages/product_detail/bloc/product_detail_event.dart';
import 'package:example_blue_print_app/pages/product_detail/bloc/product_detail_state.dart';
import 'package:example_blue_print_app/pages/product_list/repository/product_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// BLoC for the Product Detail feature.
class ProductDetailBloc
    extends Bloc<ProductDetailEvent, ProductDetailState> {
  ProductDetailBloc({required ProductRepository productRepository})
      : _productRepository = productRepository,
        super(const ProductDetailState()) {
    on<ProductDetailFetchRequested>(_onFetchRequested);
  }

  final ProductRepository _productRepository;

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
