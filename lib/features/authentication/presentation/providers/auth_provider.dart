import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_recommendation_app/features/authentication/data/auth_dependencies.dart';

// Provides the authentication controller and exposes its asynchronous state through Riverpod.
final authControllerProvider =
    NotifierProvider<AuthController, AsyncValue<void>>(
  AuthController.new,
);

// Handles authentication actions and manages their loading, success, and error states.
class AuthController extends Notifier<AsyncValue<void>> {
  // Initializes the controller with an idle state.
  @override
  AsyncValue<void> build() {
    return const AsyncData(null);
  }

  // Handles user registration and updates the authentication state.
  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();

    try {
      // Retrieves the authentication repository through Riverpod.
      final repository = ref.read(authRepositoryProvider);

      await repository.signUp(
        email: email,
        password: password,
      );

      // Sets the state to success after registration completes.
      state = const AsyncData(null);
    } catch (e, st) {
      // Stores the error and stack trace if registration fails.
      state = AsyncError(e, st);
    }
  }

  // Handles user sign-in and updates the authentication state.
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();

    try {
      final repository = ref.read(authRepositoryProvider);

      await repository.signIn(
        email: email,
        password: password,
      );

      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  // Handles password reset requests and updates the authentication state.
  Future<void> resetPassword({
    required String email,
  }) async {
    state = const AsyncLoading();

    try {
      final repository = ref.read(authRepositoryProvider);

      await repository.resetPassword(
        email: email,
      );

      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  // Handles user sign-out and updates the authentication state.
  Future<void> signOut() async {
    state = const AsyncLoading();

    try {
      final repository = ref.read(authRepositoryProvider);

      await repository.signOut();

      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

