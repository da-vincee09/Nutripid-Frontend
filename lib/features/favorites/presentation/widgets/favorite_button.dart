import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_recommendation_app/core/extensions/context_extension.dart';
import 'package:meal_recommendation_app/features/favorites/presentation/providers/favorites_provider.dart';

// Displays a favorite button that allows users to add or remove a meal from their favorites.
class FavoriteButton extends ConsumerWidget {
  final String mealId;
  final String mealName;
  final double estimatedCost;
  final String? imageUrl;
  final Color? activeColor;
  final Color? inactiveColor;
  final double size;

  // Receives the meal details and optional button styling.
  const FavoriteButton({
    super.key,
    required this.mealId,
    required this.mealName,
    required this.estimatedCost,
    this.imageUrl,
    this.activeColor,
    this.inactiveColor,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watches the favorites state so the button updates when favorites change.
    ref.watch(favoritesControllerProvider);

    // Gets the controller to perform favorite operations.
    final controller = ref.read(favoritesControllerProvider.notifier);
    
    // Checks whether the current meal is already favorited.
    final isFavorited = controller.isFavorite(mealId);
    final theme = Theme.of(context);

    return IconButton(
      // Displays a filled or outlined heart depending on favorite status.
      icon: Icon(
        isFavorited ? Icons.favorite : Icons.favorite_border,
        color: isFavorited
            ? (activeColor ?? theme.colorScheme.error)
            : inactiveColor,
        size: size,
      ),
      // Adds or removes the meal when the button is pressed.
      onPressed: () async {
        try {
          if (isFavorited) {
            await controller.removeFavorite(mealId);
          } else {
            await controller.addFavorite(
              mealId: mealId,
              mealName: mealName,
              estimatedCost: estimatedCost,
              imageUrl: imageUrl,
            );
          }
        } catch (e) {
          // Displays an error message if the operation fails.
          if (context.mounted) {
            context.showErrorSnackBar('Something went wrong. Please try again.');
          }
        }
      },
    );
  }
}