import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

/// Data model for a product from the FakeStore API.
///
/// Uses `json_serializable` + `build_runner` for type-safe
/// JSON deserialization. Never manually write `fromJson`/`toJson`.
@JsonSerializable()
class ProductModel extends Equatable {
  const ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final RatingModel rating;

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);

  @override
  List<Object?> get props => [
        id,
        title,
        price,
        description,
        category,
        image,
        rating,
      ];
}

/// Nested rating model for a product.
@JsonSerializable()
class RatingModel extends Equatable {
  const RatingModel({
    required this.rate,
    required this.count,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) =>
      _$RatingModelFromJson(json);

  final double rate;
  final int count;

  Map<String, dynamic> toJson() => _$RatingModelToJson(this);

  @override
  List<Object?> get props => [rate, count];
}
