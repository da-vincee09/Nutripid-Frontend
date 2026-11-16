// Converts an ingredient name from underscore format to readable title format.
String formatIngredientName(String raw) {
  return raw
      .split('_')
      .map((word) => word.isEmpty
          ? word
          : '${word[0].toUpperCase()}${word.substring(1)}')
      .join(' ');
}

// Converts a displayed ingredient name into lowercase underscore format.
String toCanonicalIngredientName(String display) {
  return display.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '_');
}