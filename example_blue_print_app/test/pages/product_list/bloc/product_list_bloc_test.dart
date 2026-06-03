import 'package:bloc_test/bloc_test.dart';
import 'package:example_blue_print_app/pages/product_list/bloc/product_list_bloc.dart';
import 'package:example_blue_print_app/pages/product_list/bloc/product_list_event.dart';
import 'package:example_blue_print_app/pages/product_list/bloc/product_list_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_helpers.dart';

void main() {
  late MockProductRepository mockProductRepository;

  setUp(() {
    mockProductRepository = MockProductRepository();
  });

  group('ProductListBloc', () {
    test('initial state is ProductListState()', () async {
      final bloc = ProductListBloc(
        productRepository: mockProductRepository,
      );
      expect(bloc.state, const ProductListState());
      await bloc.close();
    });

    group('ProductListFetchRequested', () {
      blocTest<ProductListBloc, ProductListState>(
        'emits [loading, success] when getProducts succeeds',
        setUp: () =>
            mockProductRepository.stubGetProductsSuccess(),
        build: () => ProductListBloc(
          productRepository: mockProductRepository,
        ),
        act: (bloc) => bloc.add(
          const ProductListFetchRequested(),
        ),
        expect: () => [
          const ProductListState(
            status: BlocStatus.loading,
          ),
          const ProductListState(
            status: BlocStatus.success,
            products: tProductList,
          ),
        ],
      );

      blocTest<ProductListBloc, ProductListState>(
        'emits [loading, failure] when getProducts fails',
        setUp: () =>
            mockProductRepository.stubGetProductsFailure(
          'Network error',
        ),
        build: () => ProductListBloc(
          productRepository: mockProductRepository,
        ),
        act: (bloc) => bloc.add(
          const ProductListFetchRequested(),
        ),
        expect: () => [
          const ProductListState(
            status: BlocStatus.loading,
          ),
          const ProductListState(
            status: BlocStatus.failure,
            errorMessage: 'Network error',
          ),
        ],
      );
    });

    group('ProductListRefreshRequested', () {
      blocTest<ProductListBloc, ProductListState>(
        'emits [success] when refresh succeeds '
        '(no loading state for refresh)',
        setUp: () =>
            mockProductRepository.stubGetProductsSuccess(),
        build: () => ProductListBloc(
          productRepository: mockProductRepository,
        ),
        act: (bloc) => bloc.add(
          const ProductListRefreshRequested(),
        ),
        expect: () => [
          const ProductListState(
            status: BlocStatus.success,
            products: tProductList,
          ),
        ],
      );
    });
  });
}
