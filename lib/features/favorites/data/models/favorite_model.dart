import 'package:meal_recommendation_app/features/favorites/domain/entities/favorite.dart';

// Extends the domain entity and handles converting meal summary data from JSON.
class FavoriteMealSummaryModel extends FavoriteMealSummary {
  const FavoriteMealSummaryModel({
    required super.id,
    required super.name,
    required super.estimatedCost,
    super.imageUrl,
  });

  // Converts a JSON map from the API into a FavoriteMealSummaryModel object.
  factory FavoriteMealSummaryModel.fromJson(Map<String, dynamic> json) {
    return FavoriteMealSummaryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      estimatedCost: _parseDecimal(json['estimated_cost']),
      imageUrl: json['image_url'] as String?,
    );
  }

  // Converts decimal values from either String or num into a double.
  static double _parseDecimal(dynamic value) {
    if (value is String) return double.parse(value);
    if (value is num) return value.toDouble();
    throw FormatException('Unexpected estimated_cost type: ${value.runtimeType}');
  }
}

// Extends the domain entity and handles converting favorite data from JSON.
class FavoriteModel extends Favorite {
  const FavoriteModel({
    required super.id,
    required FavoriteMealSummaryModel super.meal,
    required super.createdAt,
  });

  // Converts a JSON map from the API into a FavoriteModel object.
  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      id: json['id'] as String,
      meal: FavoriteMealSummaryModel.fromJson(json['meal'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}