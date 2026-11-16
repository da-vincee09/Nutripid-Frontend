import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Automatically attaches the user's access token to API requests.
// The main purpose is to prove to the backend which user is making the API request.
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    // Retrieves the current user's Supabase access token.
    final accessToken =
        Supabase.instance.client.auth.currentSession?.accessToken;
 
    // Adds the token to the Authorization header if available.
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
 
    // Continues sending the request.
    handler.next(options);
  }
}