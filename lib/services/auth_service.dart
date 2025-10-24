import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // Get static JWT token from environment variables
  static String get _staticJwtToken => dotenv.env['JWT_TOKEN'] ?? '';
  
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  final _storage = const FlutterSecureStorage();

  Future<String?> signInWithGoogle() async {
    try {
      // Try to sign in with Google (for UI purposes)
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in process, but we'll still use the static token
        debugPrint('User canceled Google sign-in, using static token');
      } else {
        debugPrint('Google sign-in successful for: ${googleUser.email}');
      }

      // Always use the static JWT token from environment variables
      if (_staticJwtToken.isNotEmpty) {
        // Save the static JWT token to secure storage
        await _storage.write(key: 'jwt_token', value: _staticJwtToken);
        debugPrint('Using static JWT token from environment');
        return _staticJwtToken;
      } else {
        throw Exception("JWT token tidak ditemukan di environment variables");
      }

    } catch (error) {
      debugPrint('Error during sign-in: $error');
      
      // Even if Google sign-in fails, try to use the static token
      if (_staticJwtToken.isNotEmpty) {
        await _storage.write(key: 'jwt_token', value: _staticJwtToken);
        debugPrint('Using static JWT token despite error');
        return _staticJwtToken;
      }
      
      rethrow; // Re-throw if no static token available
    }
  }

  Future<void> logout() async {
    // Sign out from Google and clear stored token
    await _googleSignIn.signOut();
    await _storage.delete(key: 'jwt_token');
    // Note: The static token from environment will still be available for re-login
  }

  Future<String?> getToken() async {
    try {
      // First try to get token from secure storage
      final storedToken = await _storage.read(key: 'jwt_token');
      if (storedToken != null && storedToken.isNotEmpty) {
        return storedToken;
      }
      
      // If no stored token, use the static token from environment
      if (_staticJwtToken.isNotEmpty) {
        // Store it for next time
        await _storage.write(key: 'jwt_token', value: _staticJwtToken);
        return _staticJwtToken;
      }
      
      return null;
    } catch (error) {
      // If there's an error reading from secure storage, fallback to static token
      debugPrint('Error reading token from secure storage: $error');
      
      if (_staticJwtToken.isNotEmpty) {
        return _staticJwtToken;
      }
      
      return null;
    }
  }

  /// Get current Google Sign-In user information
  GoogleSignInAccount? get currentUser => _googleSignIn.currentUser;

  /// Check if user is currently signed in to Google
  bool get isSignedIn => _googleSignIn.currentUser != null;

  /// Silent sign-in attempt (useful for automatic login)
  Future<GoogleSignInAccount?> signInSilently() async {
    try {
      return await _googleSignIn.signInSilently();
    } catch (error) {
      debugPrint('Silent sign-in failed: $error');
      return null;
    }
  }
}