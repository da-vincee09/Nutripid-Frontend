/// Predefined selectable options used by the profile form.
/// Centralized here so both ProfileSetupScreen and ProfileScreen's edit
/// mode (which share profile_form.dart) stay in sync automatically.
class ProfileOptions {
  ProfileOptions._();

  static const List<String> sexOptions = [
    'Male',
    'Female',
    'Prefer not to say',
  ];

  static const List<String> cookingSkillLevels = [
    'beginner',
    'intermediate',
    'advanced',
  ];

  static String skillLabel(String value) {
    if (value.isEmpty) return value;
    final lower = value.toLowerCase();
    return lower[0].toUpperCase() + lower.substring(1);
  }

  // Descriptions of what each cooking skill level means, shown under the
  // chips so users can tell which level fits them.
  static const Map<String, String> _skillHints = {
    'beginner':
        "I'm new to cooking. I can follow simple recipes with few steps, "
            'like frying an egg, boiling noodles, or cooking rice.',
    'intermediate':
        'I can follow most recipes on my own and handle several steps at '
            'once, like sautéing, simmering, or preparing a dish with a sauce.',
    'advanced':
        "I'm comfortable cooking without a recipe, adjusting flavors, and "
            'preparing multi-step or longer dishes confidently.',
  };

  static String? skillHint(String? value) =>
      value == null ? null : _skillHints[value.toLowerCase()];

  // Common allergens. Extend this list as needed — it's just a checklist,
  // not tied to any backend enum (the API accepts any list[str]).
  static const List<String> foodAllergies = [
    'Peanuts',
    'Tree Nuts',
    'Shellfish',
    'Shrimp',
    'Fish',
    'Eggs',
    'Milk/Dairy',
    'Soy',
    'Wheat/Gluten',
    'Sesame',
  ];

  // Common disliked ingredients in Filipino cooking. Extend as needed.
  static const List<String> dislikedIngredients = [
    'Cilantro',
    'Bitter Melon (Ampalaya)',
    'Okra',
    'Mushroom',
    'Onion',
    'Garlic',
    'Bell Pepper',
    'Liver',
    'Tofu',
    'Eggplant',
  ];

  // API values (match the backend enum). Display labels come from
  // activityLabel() so the UI can say "Moderately Active" while the
  // request sends "moderately_active".
  static const List<String> physicalActivityLevels = [
    'sedentary',
    'moderately_active',
    'active',
  ];

  static const Map<String, String> _activityLabels = {
    'sedentary': 'Sedentary',
    'moderately_active': 'Moderately Active',
    'active': 'Active',
  };

  // Descriptions of what each activity level means. Wording follows the
  // PAL ranges used in the nutrition constants: sedentary (1.40-1.69),
  // moderately active (1.70-1.99), active (2.00-2.40).
  static const Map<String, String> _activityHints = {
    'sedentary':
        'I spend most of the day sitting, like in classes, studying, or '
            'using a phone or computer, with little or no regular exercise.',
    'moderately_active':
        "I'm on my feet or walking for part of the day, like walking to "
            'classes or around campus, and I exercise lightly a few days a week.',
    'active':
        'I exercise or play sports regularly, or my routine keeps me '
            'physically busy for much of the day.',
  };

  static String activityLabel(String value) => _activityLabels[value] ?? value;

  static String? activityHint(String? value) =>
      value == null ? null : _activityHints[value];
}