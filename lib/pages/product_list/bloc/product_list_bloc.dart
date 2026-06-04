import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:antigravity_app/pages/product_list/bloc/product_list_event.dart';
import 'package:antigravity_app/pages/product_list/bloc/product_list_state.dart';
import 'package:antigravity_app/shared/repositories/product_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// BLoC for the Product List feature.
///
/// Blueprint Rule: Keep UI out of Blocs. Blocs should only
/// receive events, call the Repository, and emit a new state
/// using `copyWith`.
///
/// The repository returns `Either<Failure, List<ProductModel>>`,
/// which is folded into success or failure states.
///
/// Uses `bloc_concurrency` transformers:
/// - `droppable()` on fetch → ignores duplicate taps while loading.
/// - `restartable()` on refresh → cancels stale refresh if
///   the user pulls again.
class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  ProductListBloc({required ProductRepository productRepository})
    : _productRepository = productRepository,
      super(const ProductListState()) {
    on<ProductListFetchRequested>(
      _onFetchRequested,
      transformer: droppable(),
    );
    on<ProductListRefreshRequested>(
      _onRefreshRequested,
      transformer: restartable(),
    );
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
