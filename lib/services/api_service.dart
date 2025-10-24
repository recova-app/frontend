import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io'; // Untuk SocketException
import 'dart:async'; // Untuk TimeoutException
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:recova/services/auth_service.dart';
import 'package:recova/models/user_model.dart';
import 'package:recova/models/statistics_model.dart';
import 'package:recova/models/checkin_result_model.dart';
import 'package:recova/models/post_model.dart';
import 'package:recova/models/education_model.dart';

class ApiService {
  // Get base URL from environment variables
  static String get baseUrl => '${dotenv.env['BASE_API_URL'] ?? 'https://recova.salmanabdurrahman.my.id'}/api/v1';
  static final AuthService _authService = AuthService();

  // === Header helper ===
  static Future<Map<String, String>> getHeaders() async {
    final token = 'eyJhbGciOiJSUzI1NiIsImtpZCI6ImZiOWY5MzcxZDU3NTVmM2UzODNhNDBhYjNhMTcyY2Q4YmFjYTUxN2YiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiIxNTczMTU1NTIyMDctdGxwbDhhZHV1Z2RwdGVydXBodHEyNDY3bzhkOGxtcmQuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiIxNTczMTU1NTIyMDctdGxwbDhhZHV1Z2RwdGVydXBodHEyNDY3bzhkOGxtcmQuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMTQ0MDg3NzgwODI5NTc0OTUxODYiLCJlbWFpbCI6InNhbG1hbmFiZHVycmFobWFuMTIzNDVAZ21haWwuY29tIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiJid0ViaktaRWhJOVlnSTNHQXBOSjZnIiwiaWF0IjoxNzYxMjMxMTUzLCJleHAiOjE3NjEyMzQ3NTN9.C_SuKu0LPuPrc30AT7IjyB-wk-RkFuqs6u1Y-YC6P6kmQp13Fsc_4YHhwvhQyksbjd8ZZYbIDGmGZ1VT-d2BGUX9TLp4a9DsABspy3CE4ZzWVGEr-9F8H733pvJZBENuTWfmWMAiYxwUDf0cSO7qqBskhskX7bLU3KywKN2l9ob74q1N4FcISGwLp6zjXEDh4O7mDlx0pnignhvM8XeC8ttva3vz637knu-635MFf4GPAf2qkin2hXcq5D9aMh5hnJxUuOAb8RfPK0svMDNn8GV6rdldTa8I62CiPITyrHH5tIwIZaejQQDMqRT3_lTaGo52o2VbS-fe-SoJ8AlPNA';
    return {
      'Content-Type': 'application/json',
       'Authorization': 'Bearer $token',
    };
  }

  // === Helper untuk parsing error ===
  static String _handleError(dynamic e, http.Response? response) {
    if (e is SocketException) {
      return 'Tidak ada koneksi internet. Periksa jaringan Anda.';
    }
    if (e is TimeoutException) {
      return 'Koneksi ke server terputus. Silakan coba lagi.';
    }
    if (response != null) {
      try {
        final errorData = jsonDecode(response.body);
        return errorData['message'] ?? 'Terjadi error: ${response.statusCode}';
      } catch (_) {
        return 'Gagal memproses respons dari server. Kode: ${response.statusCode}';
      }
    }
    return e.toString().replaceFirst('Exception: ', '');
  }

  // === USER ===
  static Future<User> getUserMe() async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse('$baseUrl/users/me'),
        headers: await getHeaders(),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User.fromJson(data['data'] ?? data);
      } else {
        // Jika otorisasi gagal, paksa logout agar aplikasi tidak tetap berada di state login dengan token tidak valid
        if (response.statusCode == 401 || response.statusCode == 403) {
          await _authService.logout();
          throw Exception('Sesi berakhir. Silakan login kembali.');
        }
        throw Exception(_handleError(null, response));
      }
    } catch (e) {
      throw Exception(_handleError(e, response));
    }
  }

  // === STATISTICS ===
  static Future<Statistics> getStatistics() async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse('$baseUrl/routine/statistics'),
        headers: await getHeaders(),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Statistics.fromJson(data['data'] ?? data);
      } else {
        if (response.statusCode == 401 || response.statusCode == 403) {
          await _authService.logout();
          throw Exception('Sesi berakhir. Silakan login kembali.');
        }
        throw Exception(_handleError(null, response));
      }
    } catch (e) {
      throw Exception(_handleError(e, response));
    }
  }

  // === ROUTINE / CHECK-IN ===
  static Future<CheckInResult> checkIn({required String journal}) async {
    http.Response? response;
    try {
      response = await http.post(
        Uri.parse('$baseUrl/routine/checkin'), // Sesuai dokumentasi backend
        headers: await getHeaders(),
        body: jsonEncode({
          'content': journal,      // Menggunakan 'content' sesuai dokumentasi
          'isSuccessful': true,    // Menggunakan 'isSuccessful' sesuai dokumentasi
          'mood': 'Normal',        // Menggunakan 'mood' sesuai dokumentasi
        }),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return CheckInResult.fromJson(data['data']);
      } else {
        if (response.statusCode == 401 || response.statusCode == 403) {
          await _authService.logout();
          throw Exception('Sesi berakhir. Silakan login kembali.');
        }
        throw Exception(_handleError(null, response));
      }
    } catch (e) {
      throw Exception(_handleError(e, response));
    }
  }

  // === COMMUNITY ===
  static Future<List<Post>> getCommunityPosts() async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse('$baseUrl/community'),
        headers: await getHeaders(),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final list = data['data'] as List;
        return list.map((e) => Post.fromJson(e)).toList();
      } else {
        if (response.statusCode == 401 || response.statusCode == 403) {
          await _authService.logout();
          throw Exception('Sesi berakhir. Silakan login kembali.');
        }
        throw Exception(_handleError(null, response));
      }
    } catch (e) {
      throw Exception(_handleError(e, response));
    }
  }

  static Future<Post> createPost({required String title, required String content, required String category}) async {
    http.Response? response;
    try {
      response = await http.post(
        Uri.parse('$baseUrl/community'),
        headers: await getHeaders(),
        body: jsonEncode({
          'title': title,
          'content': content,
          'category': category, // Mengirim kategori ke backend
        }),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 201) { // 201 Created
        final data = jsonDecode(response.body);
        return Post.fromJson(data['data']);
      } else {
        if (response.statusCode == 401 || response.statusCode == 403) {
          await _authService.logout();
          throw Exception('Sesi berakhir. Silakan login kembali.');
        }
        throw Exception(_handleError(null, response));
      }
    } catch (e) {
      throw Exception(_handleError(e, response));
    }
  }

  static Future<void> likePost(String postId) async {
    http.Response? response;
    try {
      response = await http.post(
        Uri.parse('$baseUrl/community/$postId/like'),
        headers: await getHeaders(),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(_handleError(null, response));
      }
    } catch (e) {
      throw Exception(_handleError(e, response));
    }
  }

  static Future<void> unlikePost(String postId) async {
    http.Response? response;
    try {
      // Umumnya, unlike menggunakan metode DELETE
      response = await http.delete(
        Uri.parse('$baseUrl/community/$postId/like'),
        headers: await getHeaders(),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception(_handleError(null, response));
      }
    } catch (e) {
      throw Exception(_handleError(e, response));
    }
  }


  // === EDUCATION ===
  static Future<List<EducationContent>> getEducationContents() async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse('$baseUrl/education'),
        headers: await getHeaders(),
      ).timeout(const Duration(seconds: 15)); 

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final list = data['data'] as List;
        return list.map((e) => EducationContent.fromJson(e)).toList();
      } else {
        if (response.statusCode == 401 || response.statusCode == 403) {
          await _authService.logout();
          throw Exception('Sesi berakhir. Silakan login kembali.');
        }
        throw Exception(_handleError(null, response));
      }
    } catch (e) {
      throw Exception(_handleError(e, response));
    }
  }
}
