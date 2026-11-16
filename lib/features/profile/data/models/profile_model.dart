import 'package:meal_recommendation_app/features/profile/data/models/disliked_ingredient_model.dart';
import 'package:meal_recommendation_app/features/profile/data/models/food_allergy_model.dart';

// Represents the complete profile information of a user.
class ProfileModel {
  final String id;
  final String authId;
  final String? profileImageUrl;
  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;
  final String sex;
  final double budgetPerMeal;
  final String cookingSkillLevel;
  final String physicalActivityLevel;
  final List<FoodAllergyModel> foodAllergies;
  final List<DislikedIngredientModel> dislikedIngredients;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Creates an immutable profile model.
  const ProfileModel({
    required this.id,
    required this.authId,
    this.profileImageUrl,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.sex,
    required this.budgetPerMeal,
    required this.cookingSkillLevel,
    required this.physicalActivityLevel,
    required this.foodAllergies,
    required this.dislikedIngredients,
    required this.createdAt,
    required this.updatedAt,
  });

  // Converts backend JSON data into a ProfileModel object,
  // including nested food allergy and disliked ingredient models.
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String,
      authId: json['auth_id'] as String,
      profileImageUrl: json['profile_image_url'] as String?,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      dateOfBirth: DateTime.parse(json['date_of_birth'] as String),
      sex: json['sex'] as String,
      budgetPerMeal: (json['budget_per_meal'] as num).toDouble(),
      cookingSkillLevel: json['cooking_skill_level'] as String,
      physicalActivityLevel: json['physical_activity_level'] as String,
      
      // Converts each allergy JSON object into a FoodAllergyModel.
      foodAllergies: (json['food_allergies'] as List<dynamic>? ?? [])
          .map((e) => FoodAllergyModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      
      // Converts each disliked ingredient JSON object into its model.
      dislikedIngredients:
          (json['disliked_ingredients'] as List<dynamic>? ?? [])
              .map((e) =>
                  DislikedIngredientModel.fromJson(e as Map<String, dynamic>))
              .toList(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  // Converts the profile model and its nested models into JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'auth_id': authId,
      'profile_image_url': profileImageUrl,
      'first_name': firstName,
      'last_name': lastName,
      'date_of_birth': dateOfBirth.toIso8601String().split('T').first,
      'sex': sex,
      'budget_per_meal': budgetPerMeal,
      'cooking_skill_level': cookingSkillLevel,
      'physical_activity_level': physicalActivityLevel,
      'food_allergies': foodAllergies.map((e) => e.toJson()).toList(),
      'disliked_ingredients':
          dislikedIngredients.map((e) => e.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Creates a copy of the profile with selected properties changed.
  ProfileModel copyWith({
    String? id,
    String? authId,
    String? profileImageUrl,
    String? firstName,
    String? lastName,
    DateTime? dateOfBirth,
    String? sex,
    double? budgetPerMeal,
    String? cookingSkillLevel,
    String? physicalActivityLevel,
    List<FoodAllergyModel>? foodAllergies,
    List<DislikedIngredientModel>? dislikedIngredients,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      authId: authId ?? this.authId,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      sex: sex ?? this.sex,
      budgetPerMeal: budgetPerMeal ?? this.budgetPerMeal,
      cookingSkillLevel: cookingSkillLevel ?? this.cookingSkillLevel,
      physicalActivityLevel: physicalActivityLevel ?? this.physicalActivityLevel,
      foodAllergies: foodAllergies ?? this.foodAllergies,
      dislikedIngredients: dislikedIngredients ?? this.dislikedIngredients,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Combines the first and last name into one full name.
  String get fullName => '$firstName $lastName';

  // Returns a readable summary of the profile for debugging.
  @override
  String toString() =>
      'ProfileModel(id: $id, name: $fullName, sex: $sex, '
      'budgetPerMeal: $budgetPerMeal, cookingSkillLevel: $cookingSkillLevel)';

  // Compares profile properties, including the contents of both lists.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProfileModel &&
        other.id == id &&
        other.authId == authId &&
        other.profileImageUrl == profileImageUrl &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.dateOfBirth == dateOfBirth &&
        other.sex == sex &&
        other.budgetPerMeal == budgetPerMeal &&
        other.cookingSkillLevel == cookingSkillLevel &&
        other.physicalActivityLevel == physicalActivityLevel &&
        _listEquals(other.foodAllergies, foodAllergies) &&
        _listEquals(other.dislikedIngredients, dislikedIngredients) &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  // Generates a hash code using the profile fields and list contents.
  @override
  int get hashCode => Object.hash(
        id,
        authId,
        profileImageUrl,
        firstName,
        lastName,
        dateOfBirth,
        sex,
        budgetPerMeal,
        cookingSkillLevel,
        physicalActivityLevel,
        Object.hashAll(foodAllergies),
        Object.hashAll(dislikedIngredients),
        createdAt,
        updatedAt,
      );
}

// Checks whether two lists contain the same elements in the same order.
bool _listEquals<T>(List<T> a, List<T> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}