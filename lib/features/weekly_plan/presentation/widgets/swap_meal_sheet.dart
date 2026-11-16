import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meal_recommendation_app/app/colors.dart';
import 'package:meal_recommendation_app/core/utils/currency_utils.dart';
import 'package:meal_recommendation_app/features/weekly_plan/data/models/weekly_plan_draft_model.dart';

// Bottom sheet listing the other suggested meals to swap in.
Future<AlternativeMealModel?> showSwapMealSheet(
  BuildContext context, {
  required List<AlternativeMealModel> alternatives,
  required String currentMealId,
}) {
  final options =
      alternatives.where((a) => a.meal.id != currentMealId).toList();

  return showModalBottomSheet<AlternativeMealModel>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (sheetContext) {
      final theme = Theme.of(sheetContext);
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(sheetContext).size.height * 0.75,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
              child: Text(
                'Swap with another meal',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Text(
                'Best matches for you come first.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.lightSecondaryText,
                ),
              ),
            ),
            if (options.isEmpty)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Text('No other meals available.'),
              )
            else
              Flexible(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: options.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemBuilder: (context, index) => _SwapOptionTile(
                    option: options[index],
                    onTap: () => Navigator.of(sheetContext).pop(options[index]),
                  ),
                ),
              ),
          ],
        ),
      );
    },
  );
}

class _SwapOptionTile extends StatelessWidget {
  final AlternativeMealModel option;
  final VoidCallback onTap;

  const _SwapOptionTile({required this.option, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final meal = option.meal;
    final usesPantry = option.pantryDecision == 'adapt';

    return Material(
      color: AppColors.burntOrange.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: meal.imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: meal.imageUrl!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => _placeholder(),
                          errorWidget: (context, url, error) => _placeholder(),
                        )
                      : _placeholder(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meal.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.payments_outlined,
                          size: 14,
                          color: AppColors.burntOrange,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          formatPeso(meal.estimatedCost),
                          style: const TextStyle(
                            color: AppColors.burntOrange,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (usesPantry) ...[
                          const SizedBox(width: 10),
                          const Icon(
                            Icons.check_circle_outline_rounded,
                            size: 14,
                            color: AppColors.olive,
                          ),
                          const SizedBox(width: 3),
                          const Text(
                            'Pantry-ready',
                            style: TextStyle(
                              color: AppColors.olive,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.burntOrange,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: AppColors.burntOrange.withValues(alpha: 0.1),
      child: const Icon(
        Icons.restaurant_menu_outlined,
        size: 26,
        color: AppColors.burntOrange,
      ),
    );
  }
}