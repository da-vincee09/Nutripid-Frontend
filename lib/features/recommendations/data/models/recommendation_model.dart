import 'package:meal_recommendation_app/features/meals/data/models/meal_model.dart';
import 'package:meal_recommendation_app/features/nutrition/data/models/nutrition_adequacy_model.dart';
import 'package:meal_recommendation_app/core/utils/ingredient_display.dart';

// Represents how an individual ingredient is handled during meal adaptation.
class IngredientAdaptationModel {
  final String ingredient;
  final String action; // Specifies whether to retain, substitute, omit, or mark the ingredient unavailable or insufficient.
  final String? replacement;
  final double? availableQuantity;
  final double? requiredQuantity;
  final String? unit;

  // Initializes an ingredient adaptation with its details.
  const IngredientAdaptationModel({
    required this.ingredient,
    required this.action,
    this.replacement,
    this.availableQuantity,
    this.requiredQuantity,
    this.unit,
  });

  // Creates an IngredientAdaptationModel from JSON data.
  factory IngredientAdaptationModel.fromJson(Map<String, dynamic> json) {
    return IngredientAdaptationModel(
      ingredient: json['ingredient'] as String,
      action: json['action'] as String,
      replacement: json['replacement'] as String?,
      availableQuantity: _parseNullableDecimal(json['available_quantity']),
      requiredQuantity: _parseNullableDecimal(json['required_quantity']),
      unit: json['unit'] as String?,
    );
  }

  // Converts nullable numeric values from JSON into doubles.
  static double? _parseNullableDecimal(dynamic value) {
    if (value == null) return null;
    if (value is String) return double.parse(value);
    if (value is num) return value.toDouble();
    throw FormatException('Unexpected quantity type: ${value.runtimeType}');
  }

  // Checks whether the ingredient is retained.
  bool get isRetained => action == 'retain';

  // Checks whether the ingredient quantity is insufficient.
  bool get isInsufficient => action == 'insufficient';
  
  // Checks whether the ingredient is substituted.
  bool get isSubstitute => action == 'substitute';

  // Checks whether the ingredient is omitted.
  bool get isOmitted => action == 'omit';

  // Checks whether the ingredient is unavailable.
  bool get isUnavailable => action == 'unavailable';

  // Converts the ingredient name into a readable display format.
  String get displayName => formatIngredientName(ingredient);

  // Converts the replacement ingredient name into a readable display format.
  String? get displayReplacement =>
      replacement == null ? null : formatIngredientName(replacement!);

  // Returns a readable string representation of the ingredient adaptation.
  @override
  String toString() =>
      'IngredientAdaptationModel(ingredient: $ingredient, action: $action, '
      'replacement: $replacement)';

  // Compares two ingredient adaptation objects based on their properties.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is IngredientAdaptationModel &&
        other.ingredient == ingredient &&
        other.action == action &&
        other.replacement == replacement &&
        other.availableQuantity == availableQuantity &&
        other.requiredQuantity == requiredQuantity &&
        other.unit == unit;
  }

  // Generates a hash code using all ingredient adaptation properties.
  @override
  int get hashCode => Object.hash(
        ingredient,
        action,
        replacement,
        availableQuantity,
        requiredQuantity,
        unit,
      );
}

// Represents the adaptation decision and ingredient changes for a meal.
class MealAdaptationModel {
  final String decision; // Indicates whether the meal is adapted or used as a fallback.
  final List<IngredientAdaptationModel> ingredients;

  // Initializes the meal adaptation with its decision and ingredients.
  const MealAdaptationModel({
    required this.decision,
    required this.ingredients,
  });

  // Creates a MealAdaptationModel from JSON data.
  factory MealAdaptationModel.fromJson(Map<String, dynamic> json) {
    return MealAdaptationModel(
      decision: json['decision'] as String,
      ingredients: (json['ingredients'] as List<dynamic>)
          .map((e) =>
              IngredientAdaptationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  // Checks whether the meal is a fallback recommendation.
  bool get isFallback => decision == 'fallback';

  // Returns all ingredients with insufficient quantities.
  List<IngredientAdaptationModel> get insufficientIngredients =>
      ingredients.where((i) => i.isInsufficient).toList();
  
  // Returns all ingredients that have been substituted.
  List<IngredientAdaptationModel> get substitutedIngredients =>
      ingredients.where((i) => i.isSubstitute).toList();
  
  // Returns all ingredients that have been omitted.
  List<IngredientAdaptationModel> get omittedIngredients =>
      ingredients.where((i) => i.isOmitted).toList();

  // Checks whether the meal contains any ingredient adaptations.
  bool get hasAdaptations =>
      insufficientIngredients.isNotEmpty ||
      substitutedIngredients.isNotEmpty ||
      omittedIngredients.isNotEmpty;

  // Returns a readable string representation of the meal adaptation.
  @override
  String toString() =>
      'MealAdaptationModel(decision: $decision, ingredients: $ingredients)';

  // Compares two meal adaptation objects based on their properties.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MealAdaptationModel &&
        other.decision == decision &&
        _listEquals(other.ingredients, ingredients);
  }

  // Checks whether two ingredient lists contain the same elements in order.
  static bool _listEquals(
    List<IngredientAdaptationModel> a,
    List<IngredientAdaptationModel> b,
  ) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  // Generates a hash code using the decision and ingredient list.
  @override
  int get hashCode => Object.hash(decision, Object.hashAll(ingredients));
}

// Represents a meal recommendation with its scores, adaptations, and nutrition details.
class RecommendationModel {
  final MealModel meal;
  final double coverage;
  final double budgetScore;
  final double skillScore;
  final double allergyScore;
  final double dislikedScore;
  final double hybridScore;
  final MealAdaptationModel adaptation;
  final NutritionAdequacyModel nutrition;

  // Initializes a recommendation with its meal and scoring details.
  const RecommendationModel({
    required this.meal,
    required this.coverage,
    required this.budgetScore,
    required this.skillScore,
    required this.allergyScore,
    required this.dislikedScore,
    required this.hybridScore,
    required this.adaptation,
    required this.nutrition,
  });

  // Creates a RecommendationModel from JSON data.
  factory RecommendationModel.fromJson(Map<String, dynamic> json) {
    return RecommendationModel(
      meal: MealModel.fromJson(json['meal'] as Map<String, dynamic>),
      coverage: _parseDouble(json['coverage']),
      budgetScore: _parseDouble(json['budget_score']),
      skillScore: _parseDouble(json['skill_score']),
      allergyScore: _parseDouble(json['allergy_score']),
      dislikedScore: _parseDouble(json['disliked_score']),
      hybridScore: _parseDouble(json['hybrid_score']),
      adaptation:
          MealAdaptationModel.fromJson(json['adaptation'] as Map<String, dynamic>),
      nutrition: NutritionAdequacyModel.fromJson(
        json['nutrition'] as Map<String, dynamic>,
      ),
    );
  }

  // Converts numeric JSON values into doubles.
  static double _parseDouble(dynamic value) {
    if (value is String) return double.parse(value);
    if (value is num) return value.toDouble();
    throw FormatException('Unexpected numeric type: ${value.runtimeType}');
  }

  // Converts the coverage score into a percentage string for display.
  String get displayCoveragePercent => '${(coverage * 100).round()}%';
  
  // Converts the hybrid score into a whole-number string for display.
  String get displayHybridScore => (hybridScore * 100).round().toString();

  // Returns a readable string representation of the recommendation.
  @override
  String toString() =>
      'RecommendationModel(meal: ${meal.name}, hybridScore: $hybridScore, '
      'decision: ${adaptation.decision})';

  // Compares two recommendation objects based on all their properties.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RecommendationModel &&
        other.meal == meal &&
        other.coverage == coverage &&
        other.budgetScore == budgetScore &&
        other.skillScore == skillScore &&
        other.allergyScore == allergyScore &&
        other.dislikedScore == dislikedScore &&
        other.hybridScore == hybridScore &&
        other.adaptation == adaptation &&
        other.nutrition == nutrition;
  }

  // Generates a hash code using all recommendation properties.
  @override
  int get hashCode => Object.hash(
        meal,
        coverage,
        budgetScore,
        skillScore,
        allergyScore,
        dislikedScore,
        hybridScore,
        adaptation,
        nutrition,
      );
}