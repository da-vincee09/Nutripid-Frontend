import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_recommendation_app/app/router.dart';
import 'package:meal_recommendation_app/app/theme.dart';
import 'package:meal_recommendation_app/core/providers/theme_mode_provider.dart';

// Root widget of the TipidMeal application.
class TipidMealApp extends ConsumerWidget {
  const TipidMealApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watches the theme provider for light or dark mode changes.
    final themeMode = ref.watch(themeModeControllerProvider);

    // Initializes the app using GoRouter for navigation
    return MaterialApp.router(
      title: 'TipidMeal',
      debugShowCheckedModeBanner: false,

      // Applies the custom light and dark themes.
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode, // From the Riverpod provider.

      // Connects the app to its routing configuration.
      routerConfig: appRouter,
    );
  }
}