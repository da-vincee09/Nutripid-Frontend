// Defines the common parent class for all API-related errors.
// sealed class	restricts which classes can extend or implement it to the same Dart library.
sealed class ApiException implements Exception {
  final String message;
  const ApiException(this.message);

  // Returns the error message when the exception is displayed.
  @override
  String toString() => message;
}

// Represents an expired or unauthorized user session.
class UnauthorizedException extends ApiException {
  const UnauthorizedException([
    super.message = 'Your session has expired. Please log in again.',
  ]);
}

// Represents a user profile that cannot be found.
class ProfileNotFoundException extends ApiException {
  const ProfileNotFoundException([super.message = 'Profile not found']);
}

// Represents a pantry item that cannot be found
class PantryItemNotFoundException extends ApiException {
  const PantryItemNotFoundException([
    super.message = 'Pantry item not found',
  ]);
}

// Represents a meal that cannot be found.
class MealNotFoundException extends ApiException {
  MealNotFoundException() : super('Meal not found');
}

// Represents invalid input or data validation errors.
class ValidationException extends ApiException {
  final List<dynamic> errors;
  const ValidationException(this.errors, [super.message = 'Invalid data']);
}

// Represents an unexpected error from the server.
class ServerException extends ApiException {
  const ServerException([
    super.message = 'Something went wrong on our end. Please try again.',
  ]);
}

// Represents a connection failure when communicating with the server.
class NetworkException extends ApiException {
  const NetworkException([
    super.message = 'Could not reach the server. Check your connection.',
  ]);
}

// Represents a request that contains invalid or unacceptable data.
class BadRequestException extends ApiException {
  const BadRequestException([
    super.message = 'That request could not be completed.',
  ]);
}