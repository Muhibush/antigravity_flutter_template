import 'package:dio/dio.dart';
import 'package:example_blue_print_app/core/network/api_provider.dart';
import 'package:example_blue_print_app/core/network/failure.dart';
import 'package:example_blue_print_app/shared/models/product_model.dart';
import 'package:fpdart/fpdart.dart';

/// Repository for product-related API calls.
///
/// Wraps all responses in `Either<Failure, T>` so the BLoC
/// never receives raw exceptions — it simply folds the result
/// into success or failure states.
class ProductRepository {
  ProductRepository({required ApiProvider apiProvider})
    : _apiProvider = apiProvider;

  final ApiProvider _apiProvider;

  /// Fetches all products from the API.
  Future<Either<Failure, List<ProductModel>>> getProducts() async {
    try {
      final response = await _apiProvider.dio.get<List<dynamic>>('/products');
      final products = response.data!
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList();
      return Right(products);
    } on DioException catch (e) {
      return Left(Failure.fromDioException(e));
    } on Exception catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  /// Fetches a single product by [id].
  Future<Either<Failure, ProductModel>> getProductById(int id) async {
    try {
      final response = await _apiProvider.dio.get<Map<String, dynamic>>(
        '/products/$id',
      );
      final product = ProductModel.fromJson(response.data!);
      return Right(product);
    } on DioException catch (e) {
      return Left(Failure.fromDioException(e));
    } on Exception catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
