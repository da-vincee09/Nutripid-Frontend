import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_recommendation_app/features/authentication/data/datasources/auth_remote_datasource.dart';
import 'package:meal_recommendation_app/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:meal_recommendation_app/features/authentication/domain/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Provides the Supabase client so other parts of the app can access Supabase.
final supabaseClientProvider = Provider<SupabaseClient>((ref){
  return Supabase.instance.client;
});

// Provides the remote data source and supplies it with the Supabase client.
final authRemoteDatasourceProvider = Provider<AuthRemoteDatasource>((ref){
  return AuthRemoteDatasource(
    supabase: ref.watch(supabaseClientProvider),
  );
});

// Provides the authentication repository and supplies it with the remote data source.
final authRepositoryProvider = Provider<AuthRepository>((ref){
  return AuthRepositoryImpl(
    datasource: ref.watch(authRemoteDatasourceProvider),
  );
});