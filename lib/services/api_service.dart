import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:recova/services/auth_service.dart';
import 'package:recova/models/user_model.dart';
import 'package:recova/models/statistics_model.dart';
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
  // === USER ===
  static Future<User> getUserMe() async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/me'),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User.fromJson(data['data'] ?? data);
    } else {
      throw Exception('Gagal memuat data user');
    }
  }

  // === STATISTICS ===
  static Future<Statistics> getStatistics() async {
    final response = await http.get(
      Uri.parse('$baseUrl/routine/statistics'),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Statistics.fromJson(data['data'] ?? data);
    } else {
      throw Exception('Gagal memuat statistik');
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
