// Formats a DateTime as YYYY-MM-DD to match the backend's date format.
String formatDate(DateTime date) {
  // Ensures the year has at least 4 digits.
  final y = date.year.toString().padLeft(4, '0');

  // Ensures the month has 2 digits (e.g., 3 becomes 03).
  final m = date.month.toString().padLeft(2, '0');

  // Ensures the day has 2 digits (e.g., 5 becomes 05).
  final d = date.day.toString().padLeft(2, '0');

  // Combines the year, month, and day into YYYY-MM-DD format.
  return '$y-$m-$d';
}