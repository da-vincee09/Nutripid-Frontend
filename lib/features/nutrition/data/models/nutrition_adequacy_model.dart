// Represents the nutritional adequacy information of a meal.
class NutritionAdequacyModel {
  // Indicates whether the meal's calories are within, below, or above the target.
  final String caloricAdequacy; 

  // Stores the percentage distribution of Go, Grow, and Glow food groups.
  final Map<String, double>? foodGroupProportions;

  // Indicates whether the food group proportions meet the required criteria.
  final bool? foodGroupAdequate;
  
  // Indicates whether the meal is considered nutritionally adequate.
  final bool? nutritionallyAdequate;

  const NutritionAdequacyModel({
    required this.caloricAdequacy,
    this.foodGroupProportions,
    this.foodGroupAdequate,
    this.nutritionallyAdequate,
  });

  // Converts the nutrition adequacy JSON response into a Dart object.
  factory NutritionAdequacyModel.fromJson(Map<String, dynamic> json) {
    return NutritionAdequacyModel(
      caloricAdequacy: json['caloric_adequacy'] as String,
      
      // Converts food group percentage values into double values.
      foodGroupProportions: (json['food_group_proportions'] as Map<String, dynamic>?)
          ?.map((key, value) => MapEntry(key, (value as num).toDouble())),
      foodGroupAdequate: json['food_group_adequate'] as bool?,
      nutritionallyAdequate: json['nutritionally_adequate'] as bool?,
    );
  }

  // Checks the meal's calorie status.
  bool get isWithin => caloricAdequacy == 'within';
  bool get isBelow => caloricAdequacy == 'below';
  bool get isAbove => caloricAdequacy == 'above';
  bool get isUnavailable => caloricAdequacy == 'unavailable';

  // Returns true only when nutritional adequacy is explicitly confirmed.
  bool get isBalanced => nutritionallyAdequate == true;

  // Returns each food group's percentage, or zero if unavailable.
  double get goPercent => foodGroupProportions?['go'] ?? 0;
  double get growPercent => foodGroupProportions?['grow'] ?? 0;
  double get glowPercent => foodGroupProportions?['glow'] ?? 0;

  // Converts the calorie status into a user-friendly message.
  String get caloricAdequacyLabel {
    switch (caloricAdequacy) {
      case 'within':
        return 'Fits your daily calorie needs';
      case 'below':
        return 'Below your per-meal calorie target';
      case 'above':
        return 'Above your per-meal calorie target';
      default:
        return 'Set your activity level to see this';
    }
  }

  // Provides a readable text representation of the model.
  @override
  String toString() =>
      'NutritionAdequacyModel(caloricAdequacy: $caloricAdequacy, '
      'nutritionallyAdequate: $nutritionallyAdequate)';

  // Compares two models based on their selected nutritional fields.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NutritionAdequacyModel &&
        other.caloricAdequacy == caloricAdequacy &&
        other.foodGroupAdequate == foodGroupAdequate &&
        other.nutritionallyAdequate == nutritionallyAdequate;
  }

  // Generates a hash code using the same fields as the equality comparison.
  @override
  int get hashCode =>
      Object.hash(caloricAdequacy, foodGroupAdequate, nutritionallyAdequate);
}