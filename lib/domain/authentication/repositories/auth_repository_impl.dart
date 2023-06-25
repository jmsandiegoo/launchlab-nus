import 'package:supabase_flutter/supabase_flutter.dart';

/// Auth Repository Interface
/// A blueprint to specify the app logic

abstract class AuthRepositoryImpl {
  /// Sign in
  /// throws Failure
  Future<void> signinWithGoogle();

  /// Get the auth current session
  Session? getCurrentAuthSession();

  /// throws failure
  Future<void> getAuthUserProfile();

  /// Sign out
  Future<void> signOut();
}
