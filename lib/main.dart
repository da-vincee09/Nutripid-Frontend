import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_recommendation_app/app/app.dart';
import 'package:meal_recommendation_app/features/grocery_list/data/grocery_checklist_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Main entry point of the TipidMeal application.
Future<void> main() async {
  // Ensures Flutter is initialized before performing asynchronous setup.
  WidgetsFlutterBinding.ensureInitialized();

  // Loads environment variables containing configuration values.
  await dotenv.load(
    fileName: 'assets/.env',
  );

  // Initializes Supabase using the URL and publishable key from the environment file.
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    publishableKey: dotenv.env['SUPABASE_PUBLISHABLE_KEY']!,
  );

  // Starts the application and makes Riverpod available throughout the widget tree.
  runApp(
    const ProviderScope(
      child: TipidMealApp(),
    ),
  );

  // Cleans up old grocery checklist data without delaying the first screen.
  GroceryChecklistStorage.cleanupOldWeeks();
}