// Converts a numeric value or numeric string into double.
double _parseDecimal(dynamic value, String field) {
  if (value is String) return double.parse(value);
  if (value is num) return value.toDouble();
  throw FormatException('Unexpected $field type: ${value.runtimeType}');
}

// The period the savings summary covers.
enum SavingsPeriod {
  week('week'),
  month('month');

  final String apiValue;
  const SavingsPeriod(this.apiValue);

  static SavingsPeriod fromApi(String value) {
    return SavingsPeriod.values.firstWhere(
      (p) => p.apiValue == value,
      orElse: () => SavingsPeriod.week,
    );
  }
}

// Overall result of comparing planned meal costs to the budget.
enum SavingsVerdict {
  saving,
  onBudget,
  overBudget;

  static SavingsVerdict fromApi(String value) {
    switch (value) {
      case 'saving':
        return SavingsVerdict.saving;
      case 'over_budget':
        return SavingsVerdict.overBudget;
      default:
        return SavingsVerdict.onBudget;
    }
  }
}

// Savings for a single calendar day.
class DailySavingsModel {
  final DateTime date;
  final int plannedMeals;
  final double estimatedCost;
  final double budget;
  final double savings;

  const DailySavingsModel({
    required this.date,
    required this.plannedMeals,
    required this.estimatedCost,
    required this.budget,
    required this.savings,
  });

  factory DailySavingsModel.fromJson(Map<String, dynamic> json) {
    return DailySavingsModel(
      date: DateTime.parse(json['date'] as String),
      plannedMeals: json['planned_meals'] as int,
      estimatedCost: _parseDecimal(json['estimated_cost'], 'estimated_cost'),
      budget: _parseDecimal(json['budget'], 'budget'),
      savings: _parseDecimal(json['savings'], 'savings'),
    );
  }
}

// An estimate of savings if the user plans every slot in the period.
class SavingsProjectionModel {
  final int days;
  final int meals;
  final double projectedSavings;

  const SavingsProjectionModel({
    required this.days,
    required this.meals,
    required this.projectedSavings,
  });

  factory SavingsProjectionModel.fromJson(Map<String, dynamic> json) {
    return SavingsProjectionModel(
      days: json['days'] as int,
      meals: json['meals'] as int,
      projectedSavings:
          _parseDecimal(json['projected_savings'], 'projected_savings'),
    );
  }
}

// The full savings summary returned by GET /savings/summary.
class SavingsSummaryModel {
  final SavingsPeriod period;
  final DateTime startDate;
  final DateTime endDate;
  final double budgetPerMeal;
  final int plannedMeals;
  final double estimatedCostTotal;
  final double budgetTotal;
  final double totalSavings;
  final double savingsPercent;
  final SavingsVerdict verdict;
  final List<DailySavingsModel> daily;
  final SavingsProjectionModel? projection;

  const SavingsSummaryModel({
    required this.period,
    required this.startDate,
    required this.endDate,
    required this.budgetPerMeal,
    required this.plannedMeals,
    required this.estimatedCostTotal,
    required this.budgetTotal,
    required this.totalSavings,
    required this.savingsPercent,
    required this.verdict,
    required this.daily,
    this.projection,
  });

  bool get hasPlannedMeals => plannedMeals > 0;

  factory SavingsSummaryModel.fromJson(Map<String, dynamic> json) {
    final projectionJson = json['projection'] as Map<String, dynamic>?;

    return SavingsSummaryModel(
      period: SavingsPeriod.fromApi(json['period'] as String),
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      budgetPerMeal: _parseDecimal(json['budget_per_meal'], 'budget_per_meal'),
      plannedMeals: json['planned_meals'] as int,
      estimatedCostTotal: _parseDecimal(
        json['estimated_cost_total'],
        'estimated_cost_total',
      ),
      budgetTotal: _parseDecimal(json['budget_total'], 'budget_total'),
      totalSavings: _parseDecimal(json['total_savings'], 'total_savings'),
      savingsPercent: (json['savings_percent'] as num).toDouble(),
      verdict: SavingsVerdict.fromApi(json['verdict'] as String),
      daily: (json['daily'] as List<dynamic>)
          .map((e) => DailySavingsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      projection: projectionJson == null
          ? null
          : SavingsProjectionModel.fromJson(projectionJson),
    );
  }
}