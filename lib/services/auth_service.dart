import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class AuthService {
  // TODO: Pindahkan ke environment variables
  static const String _googleClientId =
      '756280521811-8g4mpvlputn04ltqdcghionnbrebhqbo.apps.googleusercontent.com';

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: _googleClientId,
    scopes: ['email', 'profile'],
  );

  final _storage = const FlutterSecureStorage();

  Future<String?> signInWithGoogle() async {
    // 1. Lakukan sign in dengan Google
    final GoogleSignInAccount? account = await _googleSignIn.signIn();
    if (account == null) {
      // Pengguna membatalkan login
      return null;
    }

    // Simpan nama pengguna untuk ditampilkan di HomePage
    await _storage.write(key: 'user_name', value: account.displayName);

    // 2. Dapatkan Google ID Token
    final GoogleSignInAuthentication auth = await account.authentication;
    final idToken = auth.idToken;
    if (idToken == null) {
      throw Exception("Gagal mendapatkan Google ID Token");
    }

    // 3. Kirim token ke backend
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/v1/auth/google'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'token': idToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final jwtToken = data['data']?['token'];

      if (jwtToken != null) {
        // 4. Simpan token JWT
        await _storage.write(key: 'jwt_token', value: jwtToken);
        return jwtToken;
      } else {
        throw Exception("Respons dari server tidak valid (token tidak ditemukan).");
      }
    } else {
      throw Exception("Login gagal: ${response.body}");
    }
  }

  Future<void> logout() async {
    // Hapus token dari kedua tempat
    await _googleSignIn.signOut();
    await _storage.delete(key: 'user_name');
    await _storage.delete(key: 'jwt_token');
  }

  Future<String?> getToken() => _storage.read(key: 'jwt_token');

  Future<String?> getUserName() => _storage.read(key: 'user_name');
}