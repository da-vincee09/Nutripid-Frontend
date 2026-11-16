import 'package:supabase_flutter/supabase_flutter.dart';

// Defines the contract for authentication operations that the repository must provide.
abstract class AuthRepository {

  // Defines the method for registering a new user.
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  });

  // Defines the method for signing in an existing user.
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  });

  // Defines the method for requesting a password reset email.
  Future<void> resetPassword({ 
    required String email, 
  });

  // Defines the method for signing out the current user.
  Future<void> signOut();

  // Defines the method for retrieving the currently authenticated user.
  User? getCurrentUser();

  // Defines the method for retrieving the current user's access token.
  String? getAccessToken();

  // Defines a stream for listening to authentication state changes.
  Stream<AuthState> get authStateChanges;
}