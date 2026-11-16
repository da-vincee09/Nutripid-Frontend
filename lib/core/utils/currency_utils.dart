// Formats a numeric value as Philippine Peso with two decimal places.
String formatPeso(num? value) {
  final v = value ?? 0;
  return '₱${v.toStringAsFixed(2)}';
}