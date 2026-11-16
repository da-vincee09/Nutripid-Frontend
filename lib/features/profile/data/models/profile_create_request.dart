// Holds the information required when creating a user's profile.
class ProfileCreateRequest {
  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;
  final String sex;
  final double budgetPerMeal;
  final String cookingSkillLevel;
  final String physicalActivityLevel;
  final List<String> foodAllergies;
  final List<String> dislikedIngredients;
  final String? profileImageUrl;

  // Creates a profile request with required and optional information.
  const ProfileCreateRequest({
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.sex,
    required this.budgetPerMeal,
    required this.cookingSkillLevel,
    required this.physicalActivityLevel,
    this.foodAllergies = const [],
    this.dislikedIngredients = const [],
    this.profileImageUrl,
  });

  // Converts profile information into a JSON-compatible map for the API.
  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'date_of_birth': dateOfBirth.toIso8601String().split('T').first,
      'sex': sex,
      'budget_per_meal': budgetPerMeal,
      'cooking_skill_level': cookingSkillLevel,
      'physical_activity_level': physicalActivityLevel,
      'food_allergies': foodAllergies,
      'disliked_ingredients': dislikedIngredients,
      if (profileImageUrl != null) 'profile_image_url': profileImageUrl,
    };
  }

  // Creates a copy of the request with selected fields changed.
  ProfileCreateRequest copyWith({
    String? firstName,
    String? lastName,
    DateTime? dateOfBirth,
    String? sex,
    double? budgetPerMeal,
    String? cookingSkillLevel,
    String? physicalActivityLevel,
    List<String>? foodAllergies,
    List<String>? dislikedIngredients,
    String? profileImageUrl,
  }) {
    return ProfileCreateRequest(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      sex: sex ?? this.sex,
      budgetPerMeal: budgetPerMeal ?? this.budgetPerMeal,
      cookingSkillLevel: cookingSkillLevel ?? this.cookingSkillLevel,
      physicalActivityLevel: physicalActivityLevel ?? this.physicalActivityLevel,
      foodAllergies: foodAllergies ?? this.foodAllergies,
      dislikedIngredients: dislikedIngredients ?? this.dislikedIngredients,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }

  // Returns a readable summary of the request for debugging.
  @override
  String toString() =>
      'ProfileCreateRequest(firstName: $firstName, lastName: $lastName, '
      'sex: $sex, budgetPerMeal: $budgetPerMeal)';
}