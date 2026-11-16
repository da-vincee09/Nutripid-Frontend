import 'package:meal_recommendation_app/features/authentication/data/datasources/auth_remote_datasource.dart';
import 'package:meal_recommendation_app/features/authentication/domain/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Implements the authentication repository and connects the domain layer to the remote data source.
class AuthRepositoryImpl implements AuthRepository {

  // Holds the data source responsible for communicating with Supabase Auth.
  final AuthRemoteDatasource _datasource;

  // Receives the authentication data source through dependency injection.
  AuthRepositoryImpl({
    required this._datasource
  });

  // Registers a new user by forwarding the credentials to the data source.
  @override
  Future<AuthResponse> signUp({
    required String email, 
    required String password
  }) {
   return _datasource.signUp(
    email: email, 
    password: password
    );
  }

  // Signs in an existing user by forwarding the credentials to the data source.
  @override
  Future<AuthResponse> signIn({
    required String email, 
    required String password
  }) {
    return _datasource.signIn(
      email: email, 
      password: password
    );
  }

  // Requests a password reset through the data source.
  @override Future<void> resetPassword({ 
    required String email, 
  }) async { 
    await _datasource.resetPassword( 
      email: email, 
    ); 
  }

  // Signs out the currently authenticated user.
  @override
  Future<void> signOut() {
    return _datasource.signOut();
  }

  // Retrieves the currently authenticated user's information.
  @override
  User? getCurrentUser() { 
    return _datasource.getCurrentUser();
  }

  // Retrieves the current user's access token.
  @override
  String? getAccessToken() {
    return _datasource.getAccessToken();
  }

  // Exposes authentication events from the data source.
  @override
  Stream<AuthState> get authStateChanges {
    return _datasource.authStateChanges;
  }
}