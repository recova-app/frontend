import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io'; // Untuk SocketException
import 'dart:async'; // Untuk TimeoutException
import 'package:recova/services/auth_service.dart';
import 'package:recova/models/user_model.dart';
import 'package:recova/models/statistics_model.dart';
import 'package:recova/models/checkin_result_model.dart';
// import 'package:recova/models/education_model.dart';

class ApiService {
  // Ganti ini dengan URL backend kamu
  static const String baseUrl = 'http://10.0.2.2:3000/api/v1';
  static final AuthService _authService = AuthService();

  // === Header helper ===
  static Future<Map<String, String>> getHeaders() async {
    final token = await _authService.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
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

  // === EDUCATION ===
  // static Future<List<Education>> getAllEducation() async {
  //   final response = await http.get(
  //     Uri.parse('$baseUrl/education'),
  //     headers: headers(),
  //   );

  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     final list = data['data'] as List;
  //     return list.map((e) => Education.fromJson(e)).toList();
  //   } else {
  //     throw Exception('Gagal memuat konten edukasi');
  //   }
  // }
}
