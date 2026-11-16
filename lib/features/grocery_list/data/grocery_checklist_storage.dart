import 'package:shared_preferences/shared_preferences.dart';

// Handles saving, loading, and cleaning up checked grocery checklist items locally.
class GroceryChecklistStorage {
  static const _keyPrefix = 'grocery_checked_';

  // Creates a unique storage key based on the grocery list's start date.
  static String _keyFor(DateTime startDate) {
    final y = startDate.year.toString().padLeft(4, '0');
    final m = startDate.month.toString().padLeft(2, '0');
    final d = startDate.day.toString().padLeft(2, '0');
    return '$_keyPrefix$y-$m-$d';
  }

  // Loads the checked ingredient names for a specific grocery list date.
  static Future<Set<String>> load(DateTime startDate) async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_keyFor(startDate));
    return stored?.toSet() ?? {};
  }

  // Saves the checked ingredient names for a specific grocery list date.
  static Future<void> save(DateTime startDate, Set<String> checked) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyFor(startDate), checked.toList());
  }

  // Removes checklist data belonging to weeks older than the allowed age.
  // Call once per app launch to prevent old storage keys from accumulating.
  static Future<void> cleanupOldWeeks({int maxAgeWeeks = 8}) async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final cutoff = today.subtract(Duration(days: maxAgeWeeks * 7));

    final keysToRemove = <String>[];

    for (final key in prefs.getKeys()) {
      if (!key.startsWith(_keyPrefix)) continue;

      final dateStr = key.substring(_keyPrefix.length);
      final parsed = DateTime.tryParse(dateStr);

      // Removes malformed keys and dates older than the cutoff.
      if (parsed == null || parsed.isBefore(cutoff)) {
        keysToRemove.add(key);
      }
    }

    // Deletes the outdated checklist entries from local storage.
    for (final key in keysToRemove) {
      await prefs.remove(key);
    }
  }
}