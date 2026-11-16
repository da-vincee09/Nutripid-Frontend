import 'package:flutter/material.dart';

// Defines the cutoff times for breakfast, lunch, and dinner.
const Map<String, TimeOfDay> mealSlotCutoffs = {
  'breakfast': TimeOfDay(hour: 10, minute: 0), // 10:00 AM
  'lunch': TimeOfDay(hour: 14, minute: 0), // 2: 00 PM
  'dinner': TimeOfDay(hour: 21, minute: 0), // 11:00 PM
};

// Checks whether the selected meaal slot has already passed its cutoff time today.
bool isSlotPastToday(String slot, {DateTime? now}) {
  // Uses the provided time or the device's current time.
  final n = now ?? DateTime.now();

  // Retrieves the cutoff time for the selected meal slot.
  final cutoff = mealSlotCutoffs[slot.toLowerCase()];

  if(cutoff == null) return false;

  // Converts the cutoff time into minutes for easier comparison.
  final cutoffMinutes = cutoff.hour * 60 + cutoff.minute;
  final nowMinutes = n.hour * 60 + n.minute;

  // Returns true if the current time has reached or passed the cutoff.
  return nowMinutes >= cutoffMinutes;
}

// Checks whether a selecte date is ealier than today's date.
bool isDateBeforeToday(DateTime date, {DateTime? today}) {
  // Uses the provided date  or the device's current date.
  final t = today ?? DateTime.now();

  // Removes the time portion so only the date is compared.
  final d = DateTime(date.year, date.month, date.day);
  final todayOnly = DateTime(t.year, t.month, t.day);

  // Returns true if the selected date is before today.
  return d.isBefore(todayOnly);
}