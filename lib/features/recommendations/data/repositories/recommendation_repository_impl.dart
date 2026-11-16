import 'package:meal_recommendation_app/features/recommendations/data/datasources/recommendation_remote_datasource.dart';
import 'package:meal_recommendation_app/features/recommendations/data/models/recommendation_model.dart';
import 'package:meal_recommendation_app/features/recommendations/domain/repositories/recommendation_repository.dart';

// Implements the RecommendationRepository interface.
class RecommendationRepositoryImpl implements RecommendationRepository {
  // Remote datasource used to fetch meal recommendations.
  final RecommendationsRemoteDatasource datasource;

  // Initializes the repository with the required datasource.
  RecommendationRepositoryImpl({required this.datasource});

  // Retrieves meal recommendations sorted by the specified field.
  @override
  Future<List<RecommendationModel>> getRecommendations({String sortBy = 'score'}) {
    return datasource.getRecommendations(sortBy: sortBy);
  }
}