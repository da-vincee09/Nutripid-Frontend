import 'package:flutter/material.dart';
import 'package:meal_recommendation_app/features/favorites/domain/entities/favorite.dart';
import 'package:meal_recommendation_app/core/utils/currency_utils.dart';

// Displays a meal saved in the user's favorites as a reusable card.
class FavoriteMealCard extends StatelessWidget {
  final Favorite favorite;
  final VoidCallback? onTap;

  // Receives the favorite meal data and an optional tap callback.
  const FavoriteMealCard({
    super.key, 
    required this.favorite, 
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final meal = favorite.meal;

    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        // Handles taps on the favorite meal card.
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        // Displays the meal image or a placeholder if no image is available.
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: meal.imageUrl != null
              ? Image.network(
                  meal.imageUrl!,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  // Displays a placeholder if the image fails to load.
                  // ignore: unnecessary_underscores
                  errorBuilder: (_, __, ___) => _placeholder(theme),
                )
              : _placeholder(theme),
        ),
        // Displays the meal name and estimated cost.
        title: Text(meal.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(formatPeso((meal.estimatedCost))),
        // Displays a heart icon to indicate that the meal is favorited.
        trailing: Icon(Icons.favorite, color: theme.colorScheme.error, size: 20),
      ),
    );
  }

  // Provides a default restaurant icon when the meal image is unavailable.
  Widget _placeholder(ThemeData theme) => Container(
        width: 48,
        height: 48,
        color: theme.colorScheme.secondaryContainer,
        child: Icon(Icons.restaurant, color: theme.colorScheme.secondary
        ),
      );
}