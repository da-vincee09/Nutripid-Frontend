// Defines a password requirement with a display label and validation function.
class PasswordRule {
  const PasswordRule({required this.label, required this.isMet});

  final String label;
  final bool Function(String password) isMet;
}

// Centralizes the password requirements and validation logic.
class PasswordValidator {
  PasswordValidator._();

  static const int minLength = 8;

  // Defines the accepted symbols and patterns for each character type.
  static final RegExp _symbol =
      RegExp(r'''[!@#$%^&*()_+\-=\[\]{};':"\\|<>?,./`~]''');
  static final RegExp _upper = RegExp(r'[A-Z]');
  static final RegExp _lower = RegExp(r'[a-z]');
  static final RegExp _digit = RegExp(r'[0-9]');

  // Lists all password requirements and how each one is checked.
  static final List<PasswordRule> rules = [
    PasswordRule(
      label: 'At least $minLength characters',
      isMet: (p) => p.length >= minLength,
    ),
    PasswordRule(
      label: 'Uppercase letter',
      isMet: (p) => _upper.hasMatch(p),
    ),
    PasswordRule(
      label: 'Lowercase letter',
      isMet: (p) => _lower.hasMatch(p),
    ),
    PasswordRule(
      label: 'Number',
      isMet: (p) => _digit.hasMatch(p),
    ),
    PasswordRule(
      label: 'Symbol (! @ #)',
      isMet: (p) => _symbol.hasMatch(p),
    ),
  ];

  // Returns true only when all password requirements are satisfied.
  static bool isValid(String password) =>
      rules.every((rule) => rule.isMet(password));

  // Returns the labels of requirements that the password has not satisfied.
  static List<String> unmetLabels(String password) => [
        for (final rule in rules)
          if (!rule.isMet(password)) rule.label,
      ];
}