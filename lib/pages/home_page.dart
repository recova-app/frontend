import 'package:flutter/material.dart';
import 'package:recova/pages/login_page.dart';
import 'package:recova/services/api_service.dart';
import 'package:recova/models/user_model.dart';
import 'package:recova/models/statistics_model.dart';
import 'package:recova/services/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? _user;
  Statistics? _stats;
  bool _loading = true;
  final AuthService _authService = AuthService();
  final int _totalDays = 32;

  @override
  void initState() {
    super.initState();
    _fetchHomeData();
  }

  Future<void> _fetchHomeData() async {
    setState(() => _loading = true);
    try {
      // Jalankan pemanggilan API secara paralel untuk loading lebih cepat
      final results = await Future.wait([
        ApiService.getUserMe(),
        ApiService.getStatistics(),
      ]);

      if (!mounted) return;
      setState(() {
        _user = results[0] as User;
        _stats = results[1] as Statistics;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _handleLogout() async {
    await _authService.logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        title: Text('Halo, ${_user?.nickname ?? "User"}'),
        backgroundColor: const Color(0xFF2EC4B6),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchHomeData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== HEADER STREAK =====
              Container(
                padding: const EdgeInsets.fromLTRB(20, 40, 20, 30),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFF003E53),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Text(
                          'Streak Kamu',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text('🔥', style: TextStyle(fontSize: 24)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Setelah Melakukan Daily Check-in streak kamu akan terupdate di tengah malam',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Progress: ${_stats?.currentStreak ?? 0} / $_totalDays Days',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: (_stats?.currentStreak ?? 0) / _totalDays,
                        backgroundColor: Colors.white30,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.white),
                        minHeight: 12,
                      ),
                    ),
                  ],
                ),
              ),

              // ===== KONTEN UTAMA =====
              Container(
                transform: Matrix4.translationValues(0, -10, 0),
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ===== DAILY ROUTINE =====
                    const Text(
                      'Daily Routine',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    const RoutineCard(
                      icon: 'assets/images/home/icon_checkin.png',
                      title: 'Check-In Harian Diatur Saat 6pm',
                      subtitle: 'Klik untuk Check-In lebih awal',
                      backgroundColor: const Color(0xFFE3FDFB),
                    ),
                    const SizedBox(height: 12),
                    const RoutineCard(
                      icon: 'assets/images/home/icon_motivation.png',
                      title: 'Motivation',
                      subtitle:
                          'Dapatkan Motivasi Untuk tetap terus di jalan yang benar',
                      backgroundColor: Color(0xFFFFF9C4),
                    ),
                    const SizedBox(height: 12),
                    const RoutineCard(
                      icon: 'assets/images/home/icon_challenge.png',
                      title: 'Daily Activity Challenge',
                      subtitle:
                          'Dapatkan Tantangan harian untuk mengatasi rasa bosanmu',
                      backgroundColor: Color(0xFFF3E5F5),
                    ),
                    const SizedBox(height: 30),

                    // ===== BANTU PEMULIHAN =====
                    const Text(
                      'Bantu Pemulihan',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    const EmergencyButton(),
                    const SizedBox(height: 12),
                    const RoutineCard( // Tambahkan const
                      icon: 'assets/images/home/icon_coach.png',
                      title: 'Smart Personal AI Coach',
                      subtitle:
                          'Dapatkan Insight untuk Keluhan atau Pertanyaanmu',
                      backgroundColor: Color(0xFFE0F7FA),
                    ),
                    const SizedBox(height: 30),

                    // ===== TODAY INSIGHT =====
                    const Row(
                      children: [
                        Text(
                          'Today Insight',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 8),
                        Text('✨', style: TextStyle(fontSize: 18)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const InsightCard(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RoutineCard extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final Color backgroundColor;

  const RoutineCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(icon, width: 28, height: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 4),
                Text(subtitle,
                    style:
                        const TextStyle(fontSize: 13, color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EmergencyButton extends StatelessWidget {
  const EmergencyButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFCDD2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Image.asset('assets/images/home/icon_emergency.png',
              width: 32, height: 32),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Emergency Button',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Color(0xFFC62828))),
                SizedBox(height: 4),
                Text(
                  'Dapatkan Bantuan instan ketika dalam waktu feeling tempted',
                  style: TextStyle(fontSize: 13, color: Color(0xFFD32F2F)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class InsightCard extends StatelessWidget {
  const InsightCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '“Kamu sudah melakukan yang terbaik hari ini, hasil yang memuaskan datang dari hal kecil yang dilakukan secara konsisten.”',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic),
          ),
          SizedBox(height: 16),
          Text(
            'Insight ini dibuat dari journal harian yang kamu tulis dan aktifitas daily check-in kamu',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
