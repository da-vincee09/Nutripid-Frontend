import 'package:meal_recommendation_app/features/recommendations/data/models/recommendation_model.dart';

// Defines the contract for recommendation-related operations.
abstract class RecommendationRepository {
  // Retrieves meal recommendations sorted by the specified field.
  Future<List<RecommendationModel>> getRecommendations({String sortBy = 'score'});
}