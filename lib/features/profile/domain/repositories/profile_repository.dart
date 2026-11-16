import 'dart:io';
import 'package:meal_recommendation_app/features/profile/data/models/profile_create_request.dart';
import 'package:meal_recommendation_app/features/profile/data/models/profile_model.dart';
import 'package:meal_recommendation_app/features/profile/data/models/profile_update_request.dart';

// Defines the contract for profile-related operations.
abstract class ProfileRepository {
  // Creates a new user profile.
  Future<ProfileModel> createProfile(ProfileCreateRequest request);
  
  // Retrieves the current user's profile.
  Future<ProfileModel> getMyProfile();
  
  // Updates the current user's profile.
  Future<ProfileModel> updateProfile(ProfileUpdateRequest request);
  
  // Uploads a profile image and returns its URL.
  Future<String> uploadProfileImage(File imageFile);
}