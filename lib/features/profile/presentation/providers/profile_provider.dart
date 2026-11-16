import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_recommendation_app/core/errors/api_exception.dart';
import 'package:meal_recommendation_app/features/profile/data/models/profile_create_request.dart';
import 'package:meal_recommendation_app/features/profile/data/models/profile_model.dart';
import 'package:meal_recommendation_app/features/profile/data/models/profile_update_request.dart';
import 'package:meal_recommendation_app/features/profile/data/profile_dependencies.dart';

// Provides the profile controller and its asynchronous state.
final profileControllerProvider =
  NotifierProvider<ProfileController, AsyncValue<ProfileModel?>>(
    ProfileController.new,
  );

// Manages profile-related operations and application state.
class ProfileController extends Notifier<AsyncValue<ProfileModel?>> {
  @override
  AsyncValue<ProfileModel?> build() {
    // Returns an idle state without automatically loading the profile.
    return const AsyncData(null);
  }

  // Loads the currently authenticated user's profile.
  Future<void> loadProfile() async {
    state = const AsyncLoading();

    try {
      final repository = ref.read(profileRepositoryProvider);
      final profile = await repository.getMyProfile();
      state = AsyncData(profile);
    } on ProfileNotFoundException {
      // Sets the profile to null when the user has no existing profile.
      state = const AsyncData(null);
    } catch (e, st) {
      // Updates the state when an unexpected error occurs.
      state = AsyncError(e, st);
    }
  }

  // Creates a new user profile and returns whether the operation succeeded.
  Future<bool> createProfile(ProfileCreateRequest request) async {
    state = const AsyncLoading();

    try {
      final repository = ref.read(profileRepositoryProvider);
      final profile = await repository.createProfile(request);
      state = AsyncData(profile);
      return true;
    } catch (e, st) {
      // Stores the error if profile creation fails.
      state = AsyncError(e, st);
      return false;
    }
  }

  // Updates the user's profile and returns whether the operation succeeded.
  Future<bool> updateProfile(ProfileUpdateRequest request) async {
    state = const AsyncLoading();

    try {
      final repository = ref.read(profileRepositoryProvider);
      final profile = await repository.updateProfile(request);
      state = AsyncData(profile);
      return true;
    } catch (e, st) {
      // Stores the error if profile updating fails.
      state = AsyncError(e, st);
      return false;
    }
  }

  // Uploads a profile image and updates the profile with its URL.
  Future<bool> uploadProfileImage(File imageFile) async {
    // Retrieves the current profile from the state if available.
    final currentProfile = state is AsyncData<ProfileModel?>
        ? (state as AsyncData<ProfileModel?>).value
        : null;

    // Stops the upload if no profile is currently available.
    if (currentProfile == null) return false;

    try {
      final repository = ref.read(profileRepositoryProvider);
      final imageUrl = await repository.uploadProfileImage(imageFile);
      state = AsyncData(currentProfile.copyWith(profileImageUrl: imageUrl));
      return true;
    } catch (e) {
      // Returns false if the image upload fails.
      return false;
    }
  }
}