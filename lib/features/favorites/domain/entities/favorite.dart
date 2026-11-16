// Domain entities define what the data looks like and what information the application needs, without depending on where that data comes from or how it is retrieved.
// Represents the essential information about a meal saved in the user's favorites.
class FavoriteMealSummary {
  final String id;
  final String name;
  final double estimatedCost;
  final String? imageUrl;

  // Creates a favorite meal summary with the required meal details.
  const FavoriteMealSummary({
    required this.id,
    required this.name,
    required this.estimatedCost,
    this.imageUrl,
  });
}

// Represents a user's favorite meal, including its details and date added.
class Favorite {
  final String id;
  final FavoriteMealSummary meal;
  final DateTime createdAt;

  // Creates a favorite record with its ID, meal information, and creation date.
  const Favorite({
    required this.id,
    required this.meal,
    required this.createdAt,
  });
}