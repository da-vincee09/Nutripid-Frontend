import 'dart:io';
import 'package:meal_recommendation_app/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:meal_recommendation_app/features/profile/data/models/profile_create_request.dart';
import 'package:meal_recommendation_app/features/profile/data/models/profile_model.dart';
import 'package:meal_recommendation_app/features/profile/data/models/profile_update_request.dart';
import 'package:meal_recommendation_app/features/profile/domain/repositories/profile_repository.dart';

// Implements the ProfileRepository interface.
class ProfileRepositoryImpl implements ProfileRepository {
  // Remote datasource used to communicate with the API.
  final ProfileRemoteDatasource datasource;

  // Initializes the repository with the required datasource.
  ProfileRepositoryImpl({required this.datasource});

  // Creates a new user profile.
  @override
  Future<ProfileModel> createProfile(ProfileCreateRequest request) {
    return datasource.createProfile(request);
  }

  // Retrieves the current user's profile.
  @override
  Future<ProfileModel> getMyProfile() {
    return datasource.getMyProfile();
  }

  // Updates the current user's profile.
  @override
  Future<ProfileModel> updateProfile(ProfileUpdateRequest request) {
    return datasource.updateProfile(request);
  }

  // Uploads a profile image and returns its URL.
  @override
  Future<String> uploadProfileImage(File imageFile) {
    return datasource.uploadProfileImage(imageFile);
  }
}