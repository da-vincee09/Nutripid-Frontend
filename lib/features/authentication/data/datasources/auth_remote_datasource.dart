import 'package:supabase_flutter/supabase_flutter.dart';

// Handles authentication operations by communicating with Supabase Auth.
class AuthRemoteDatasource {

  // Stores the Supabase client used to perform authentication operations.
  final SupabaseClient _supabase;

  // Receives the Supabase client through dependency injection.
  AuthRemoteDatasource({
    required this._supabase
  });

  // Registers a new user using their email and password.
  Future<AuthResponse> signUp({
    required String email,
    required String password
  }) {
    return _supabase.auth.signUp(
      email: email,
      password: password
    );
  }

  // Signs in an existing user using their email and password.
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) {
    return _supabase.auth.signInWithPassword(
      email: email,
      password: password
    );
  }

  // Sends a password reset email to the specified email address.
  Future<void> resetPassword({ 
    required String email, 
  }) { 
    return _supabase.auth.resetPasswordForEmail(email); 
  }
  
  // Signs out the currently authenticated user.
  Future<void> signOut() {
    return _supabase.auth.signOut();
  }

  // Returns the currently authenticated user, or null if no user is signed in.
  User? getCurrentUser() {
    return _supabase.auth.currentUser;
  }

  // Returns the current user's access token, or null if no active session exists.
  String? getAccessToken() {
    return _supabase.auth.currentSession?.accessToken;
  }

  // Provides a stream of authentication events, such as sign-in and sign-out.
  Stream<AuthState> get authStateChanges {
    return _supabase.auth.onAuthStateChange;
  }
}