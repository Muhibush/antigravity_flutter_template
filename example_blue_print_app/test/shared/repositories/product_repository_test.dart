import 'package:dio/dio.dart';
import 'package:example_blue_print_app/core/network/api_provider.dart';
import 'package:example_blue_print_app/core/network/failure.dart';
import 'package:example_blue_print_app/shared/repositories/product_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

/// Mock for [ApiProvider] so we can control the Dio responses.
class MockApiProvider extends Mock implements ApiProvider {}

/// Mock for [Dio] so we can stub `.get()` calls.
class MockDio extends Mock implements Dio {}

void main() {
  late MockApiProvider mockApiProvider;
  late MockDio mockDio;
  late ProductRepository repository;

  setUp(() {
    mockApiProvider = MockApiProvider();
    mockDio = MockDio();
    when(() => mockApiProvider.dio).thenReturn(mockDio);
    repository = ProductRepository(apiProvider: mockApiProvider);
  });

  group('ProductRepository', () {
    group('getProducts', () {
      test('returns Right(List<ProductModel>) on success', () async {
        // Arrange: stub Dio to return a fake JSON list
        when(
          () => mockDio.get<List<dynamic>>(any()),
        ).thenAnswer(
          (_) async => Response<List<dynamic>>(
            data: [
              {
                'id': 1,
                'title': 'Test',
                'price': 9.99,
                'description': 'Desc',
                'category': 'cat',
                'image': 'https://img.com/1.jpg',
                'rating': {'rate': 4.0, 'count': 10},
              },
            ],
            statusCode: 200,
            requestOptions: RequestOptions(),
          ),
        );

        // Act
        final result = await repository.getProducts();

        // Assert: result should be a Right
        expect(result.isRight(), isTrue);
        result.fold(
          (failure) => fail('Expected Right, got Left: $failure'),
          (products) {
            expect(products.length, 1);
            expect(products.first.title, 'Test');
            expect(products.first.price, 9.99);
          },
        );
      });

      test(
        'returns Left(Failure) on DioException',
        () async {
          // Arrange: stub Dio to throw
          when(
            () => mockDio.get<List<dynamic>>(any()),
          ).thenThrow(
            DioException(
              type: DioExceptionType.connectionTimeout,
              requestOptions: RequestOptions(),
            ),
          );

          // Act
          final result = await repository.getProducts();

          // Assert: result should be a Left with a Failure
          expect(result.isLeft(), isTrue);
          result.fold(
            (failure) {
              expect(failure, isA<Failure>());
              expect(
                failure.message,
                contains('timed out'),
              );
            },
            (_) => fail('Expected Left, got Right'),
          );
        },
      );
    });

    group('getProductById', () {
      test('returns Right(ProductModel) on success', () async {
        when(
          () => mockDio.get<Map<String, dynamic>>(any()),
        ).thenAnswer(
          (_) async => Response<Map<String, dynamic>>(
            data: {
              'id': 1,
              'title': 'Single Product',
              'price': 19.99,
              'description': 'Desc',
              'category': 'cat',
              'image': 'https://img.com/1.jpg',
              'rating': {'rate': 4.5, 'count': 20},
            },
            statusCode: 200,
            requestOptions: RequestOptions(),
          ),
        );

        final result = await repository.getProductById(1);

        expect(result.isRight(), isTrue);
        result.fold(
          (failure) => fail('Expected Right, got Left'),
          (product) {
            expect(product.id, 1);
            expect(product.title, 'Single Product');
          },
        );
      });

      test('returns Left(Failure) on 404', () async {
        when(
          () => mockDio.get<Map<String, dynamic>>(any()),
        ).thenThrow(
          DioException(
            type: DioExceptionType.badResponse,
            response: Response<dynamic>(
              statusCode: 404,
              requestOptions: RequestOptions(),
            ),
            requestOptions: RequestOptions(),
          ),
        );

        final result = await repository.getProductById(999);

        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) {
            expect(failure.statusCode, 404);
            expect(
              failure.message,
              contains('not found'),
            );
          },
          (_) => fail('Expected Left, got Right'),
        );
      });
    });
  });
}
