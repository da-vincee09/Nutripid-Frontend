import 'package:flutter/material.dart';
import 'package:meal_recommendation_app/features/meal_planner/data/models/meal_plan_entry_model.dart';
import 'package:meal_recommendation_app/core/utils/currency_utils.dart';

// Displays one scheduled meal in the Meal Planner.
class MealPlanEntryCard extends StatelessWidget {
  final MealPlanEntryModel entry;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const MealPlanEntryCard({
    super.key,
    required this.entry,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        // Calls the parent's callback when the meal card is tapped.
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        
        // Displays the meal image or a placeholder if unavailable.
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: entry.meal.imageUrl != null
              ? Image.network(
                  entry.meal.imageUrl!,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  // ignore: unnecessary_underscores
                  errorBuilder: (_, __, ___) => _placeholderIcon(theme),
                )
              : _placeholderIcon(theme),
        ),

        // Displays the meal name, limited to one line.
        title: Text(
          entry.meal.name,
          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        
        // Displays the meal's estimated cost in Philippine pesos.
        subtitle: Text(
          formatPeso(entry.meal.estimatedCost),
          style: theme.textTheme.bodySmall,
        ),
        
        // Shows a delete button only when an onDelete callback is provided.
        trailing: onDelete != null
            ? IconButton(
                icon: Icon(Icons.close, size: 20, color: theme.colorScheme.error),
                onPressed: onDelete,
              )
            : null,
      ),
    );
  }

  // Provides a default restaurant icon when no meal image is available.
  Widget _placeholderIcon(ThemeData theme) {
    return Container(
      width: 48,
      height: 48,
      color: theme.colorScheme.secondaryContainer,
      child: Icon(
        Icons.restaurant,
        color: theme.colorScheme.secondary,
        size: 24,
      ),
    );
  }
}