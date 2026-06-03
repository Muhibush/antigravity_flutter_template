import 'package:example_blue_print_app/pages/product_list/bloc/product_list_event.dart';
import 'package:example_blue_print_app/pages/product_list/bloc/product_list_state.dart';
import 'package:example_blue_print_app/shared/repositories/product_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// BLoC for the Product List feature.
///
/// Blueprint Rule: Keep UI out of Blocs. Blocs should only
/// receive events, call the Repository, and emit a new state
/// using `copyWith`.
///
/// The repository returns `Either<Failure, List<ProductModel>>`,
/// which is folded into success or failure states.
class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  ProductListBloc({required ProductRepository productRepository})
    : _productRepository = productRepository,
      super(const ProductListState()) {
    on<ProductListFetchRequested>(_onFetchRequested);
    on<ProductListRefreshRequested>(_onRefreshRequested);
  }

  final ProductRepository _productRepository;

  Future<void> _onFetchRequested(
    ProductListFetchRequested event,
    Emitter<ProductListState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));

    final result = await _productRepository.getProducts();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: BlocStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (products) => emit(
        state.copyWith(
          status: BlocStatus.success,
          products: products,
        ),
      ),
    );
  }

  Future<void> _onRefreshRequested(
    ProductListRefreshRequested event,
    Emitter<ProductListState> emit,
  ) async {
    final result = await _productRepository.getProducts();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: BlocStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (products) => emit(
        state.copyWith(
          status: BlocStatus.success,
          products: products,
        ),
      ),
    );
  }
}
