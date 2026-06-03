import 'package:example_blue_print_app/core/network/failure.dart';
import 'package:example_blue_print_app/shared/models/product_model.dart';
import 'package:example_blue_print_app/shared/repositories/product_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

/// Mock for [ProductRepository].
///
/// Usage: `when(() => mockRepo.getProducts()).thenAnswer(...);`
class MockProductRepository extends Mock implements ProductRepository {}

/// A reusable fake product for testing.
const tRating = RatingModel(rate: 4.5, count: 120);

const tProduct = ProductModel(
  id: 1,
  title: 'Test Product',
  price: 29.99,
  description: 'A great product for testing.',
  category: 'electronics',
  image: 'https://fakestoreapi.com/img/test.jpg',
  rating: tRating,
);

const List<ProductModel> tProductList = [tProduct];

/// Convenience helpers for stubbing repository responses.
extension MockProductRepositoryX on MockProductRepository {
  /// Stubs [getProducts] to return a success with [products].
  void stubGetProductsSuccess([
    List<ProductModel> products = tProductList,
  ]) {
    when(getProducts).thenAnswer(
      (_) async => Right(products),
    );
  }

  /// Stubs [getProducts] to return a failure.
  void stubGetProductsFailure([
    String message = 'Something went wrong.',
  ]) {
    when(getProducts).thenAnswer(
      (_) async => Left(Failure(message: message)),
    );
  }

  /// Stubs [getProductById] to return a success.
  void stubGetProductByIdSuccess([
    ProductModel product = tProduct,
  ]) {
    when(() => getProductById(any())).thenAnswer(
      (_) async => Right(product),
    );
  }

  /// Stubs [getProductById] to return a failure.
  void stubGetProductByIdFailure([
    String message = 'Something went wrong.',
  ]) {
    when(() => getProductById(any())).thenAnswer(
      (_) async => Left(Failure(message: message)),
    );
  }
}
