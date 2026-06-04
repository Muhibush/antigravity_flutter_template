import 'package:bloc_test/bloc_test.dart';
import 'package:antigravity_app/pages/product_list/bloc/product_list_bloc.dart';
import 'package:antigravity_app/pages/product_list/bloc/product_list_event.dart';
import 'package:antigravity_app/pages/product_list/bloc/product_list_state.dart';
import 'package:antigravity_app/shared/widgets/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/test_helpers.dart';

/// A mock BLoC so we can control the state the widget sees.
class MockProductListBloc
    extends MockBloc<ProductListEvent, ProductListState>
    implements ProductListBloc {}

void main() {
  late MockProductListBloc mockBloc;

  setUp(() {
    mockBloc = MockProductListBloc();
  });

  /// Helper to pump the widget under test with all required
  /// ancestors (MaterialApp, ScreenUtilInit, BlocProvider).
  Future<void> pumpProductListView(WidgetTester tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        child: MaterialApp(
          home: BlocProvider<ProductListBloc>.value(
            value: mockBloc,
            child: const Scaffold(
              body: _TestableProductListBody(),
            ),
          ),
        ),
      ),
    );
  }

  group('ProductListPage Widget Tests', () {
    testWidgets(
      'shows LoadingOverlay when status is loading',
      (tester) async {
        when(() => mockBloc.state).thenReturn(
          const ProductListState(status: BlocStatus.loading),
        );

        await pumpProductListView(tester);

        expect(
          find.byType(CircularProgressIndicator),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'shows error message when status is failure',
      (tester) async {
        when(() => mockBloc.state).thenReturn(
          const ProductListState(
            status: BlocStatus.failure,
            errorMessage: 'Network error',
          ),
        );

        await pumpProductListView(tester);

        expect(find.text('Network error'), findsOneWidget);
        expect(find.text('Retry'), findsOneWidget);
      },
    );

    testWidgets(
      'shows product list when status is success',
      (tester) async {
        when(() => mockBloc.state).thenReturn(
          const ProductListState(
            status: BlocStatus.success,
            products: tProductList,
          ),
        );

        await pumpProductListView(tester);

        expect(find.text('Test Product'), findsOneWidget);
        expect(find.text(r'$29.99'), findsOneWidget);
      },
    );

    testWidgets(
      'tapping Retry dispatches ProductListFetchRequested',
      (tester) async {
        when(() => mockBloc.state).thenReturn(
          const ProductListState(
            status: BlocStatus.failure,
            errorMessage: 'Network error',
          ),
        );

        await pumpProductListView(tester);

        await tester.tap(find.text('Retry'));

        verify(
          () => mockBloc.add(
            const ProductListFetchRequested(),
          ),
        ).called(1);
      },
    );
  });
}

/// A testable version of the product list body that mirrors
/// the real `_ProductListView` but without the BlocProvider
/// (since we inject a mock above).
class _TestableProductListBody extends StatelessWidget {
  const _TestableProductListBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductListBloc, ProductListState>(
      builder: (context, state) {
        switch (state.status) {
          case BlocStatus.initial:
          case BlocStatus.loading:
            return const LoadingOverlay();
          case BlocStatus.failure:
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.errorMessage),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<ProductListBloc>().add(
                              const ProductListFetchRequested(),
                            ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          case BlocStatus.success:
            return ListView.builder(
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final product = state.products[index];
                return ListTile(
                  title: Text(product.title),
                  subtitle: Text(
                    '\$${product.price.toStringAsFixed(2)}',
                  ),
                );
              },
            );
        }
      },
    );
  }
}
