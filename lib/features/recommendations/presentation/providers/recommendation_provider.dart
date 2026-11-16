import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_recommendation_app/features/recommendations/data/models/recommendation_model.dart';
import 'package:meal_recommendation_app/features/recommendations/data/recommendation_dependencies.dart';

// Provides the recommendation controller and its asynchronous state.
final recommendationControllerProvider = NotifierProvider<RecommendationController,
    AsyncValue<List<RecommendationModel>>>(
  RecommendationController.new,
);

// Manages fetching, sorting, and displaying meal recommendations.
class RecommendationController extends Notifier<AsyncValue<List<RecommendationModel>>> {
  // Stores the currently selected sorting option.
  String _sortBy = 'score'; 
  
  // Stores the original recommendations fetched from the API.
  List<RecommendationModel> _rawRecommendations = [];

  // Provides access to the currently selected sorting option.
  String get sortBy => _sortBy;

  @override
  AsyncValue<List<RecommendationModel>> build() {
    // Initializes an empty state without automatically fetching recommendations.
    return const AsyncData([]);
  }

  // Fetches recommendations from the API and sorts them locally.
  Future<void> loadRecommendations() async {
    state = const AsyncLoading();
    try {
      final repository = ref.read(recommendationRepositoryProvider);
      // Retrieves recommendations without specifying a sorting option.
      final recommendations = await repository.getRecommendations();
      _rawRecommendations = recommendations;
      // Updates the state using the currently selected sorting option.
      state = AsyncData(_sorted(_rawRecommendations, _sortBy));
    } catch (e, st) {
      // Stores the error if fetching recommendations fails.
      state = AsyncError(e, st);
    }
  }

  // Changes the sorting option and immediately re-sorts the existing recommendations
  void setSortBy(String sortBy) {
    if (_sortBy == sortBy) return;
    _sortBy = sortBy;
    // Updates the state without making another API request.
    state = AsyncData(_sorted(_rawRecommendations, _sortBy));
  }

  // Sorts recommendations based on the selected sorting option.
  List<RecommendationModel> _sorted(
    List<RecommendationModel> recommendations,
    String sortBy,
  ) {
    // Creates a copy to avoid modifying the original recommendations list.
    final sorted = List<RecommendationModel>.from(recommendations);

    if (sortBy == 'cost') {
      // Sorts by ascending meal cost and uses hybrid score to break ties.
      sorted.sort((a, b) {
        final costCompare =
            a.meal.estimatedCost.compareTo(b.meal.estimatedCost);
        if (costCompare != 0) return costCompare;
        return b.hybridScore.compareTo(a.hybridScore);
      });
    } else {
      // Prioritizes adapted meals over fallback meals, then sorts by hybrid score.
      sorted.sort((a, b) {
        final aFallback = a.adaptation.decision != 'adapt';
        final bFallback = b.adaptation.decision != 'adapt';
        if (aFallback != bFallback) {
          return aFallback ? 1 : -1;
        }
        return b.hybridScore.compareTo(a.hybridScore);
      });
    }

    // Returns the sorted recommendations list.
    return sorted;
  }
}