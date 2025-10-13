import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recova/bloc/checkin_cubit.dart';
import 'package:recova/bloc/home_cubit.dart';
import 'package:recova/models/user_model.dart';
import 'package:recova/models/statistics_model.dart';
import 'package:recova/pages/checkin_page.dart';
import 'package:recova/pages/login_page.dart';
import 'package:recova/services/auth_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    final AuthService authService = AuthService();
    await authService.logout();

    if (!context.mounted) return;

    // Navigasi ke halaman login dan hapus semua rute sebelumnya
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  bool _hasCheckedInToday(Statistics? stats) {
    if (stats == null || stats.streakCalendar.isEmpty) {
      return false;
    }
    // Ambil tanggal terakhir dari kalender streak
    final lastCheckInDate = DateTime.parse(stats.streakCalendar.last);
    final now = DateTime.now();

    // Bandingkan hanya tahun, bulan, dan hari
    return lastCheckInDate.year == now.year &&
        lastCheckInDate.month == now.month &&
        lastCheckInDate.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    // Panggil fetchHomeData jika state masih initial
    final homeState = context.watch<HomeCubit>().state;
    if (homeState is HomeInitial) {
      context.read<HomeCubit>().fetchHomeData();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading || state is HomeInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is HomeLoadFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Gagal memuat data: ${state.error}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<HomeCubit>().fetchHomeData(),
                      child: const Text('Coba Lagi'),
                    )
                  ],
                ),
              );
            }

            if (state is HomeLoadSuccess) {
              final user = state.user;
              final stats = state.statistics;
              final hasCheckedInToday = _hasCheckedInToday(stats);
              const totalDays = 32;

              return RefreshIndicator(
                onRefresh: () => context.read<HomeCubit>().fetchHomeData(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ===== HEADER STREAK =====
                      _buildHeader(context, user, stats, totalDays),

                      // ===== KONTEN UTAMA =====
                      _buildMainContent(context, stats, hasCheckedInToday),
                    ],
                  ),
                ),
              );
            }

            return const SizedBox.shrink(); // Should not happen
          },
        ),
      );
  }

  Widget _buildHeader(
      BuildContext context, User user, Statistics stats, int totalDays) {
    return Container(
                padding: const EdgeInsets.fromLTRB(20, 40, 20, 30),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFF003E53),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        IconButton(
                          icon: const Icon(Icons.logout, color: Colors.white),
                          onPressed: () => _handleLogout(context),
                          tooltip: 'Logout',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Greeting using user nickname (prevents unused-field lint)
                    Text(
                      'Hi, ${user.nickname}',
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
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
                      'Progress: ${stats.currentStreak} / $totalDays Days',
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
                        value: stats.currentStreak / totalDays,
                        backgroundColor: Colors.white30,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.white),
                        minHeight: 12,
                      ),
                    ),
                  ],
                ),
              );
  }

  Widget _buildMainContent(
      BuildContext context, Statistics stats, bool hasCheckedInToday) {
    return Container(
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
                    InkWell(
                      onTap: () async {
                        // Capture objects that depend on the BuildContext before any await
                        final checkinCubit = context.read<CheckinCubit>();
                        final homeCubit = context.read<HomeCubit>();
                        final messenger = ScaffoldMessenger.of(context);

                        // Reset cubit state before navigating so any previous
                        // CheckinFailure/CheckinSuccess doesn't trigger logic prematurely.
                        checkinCubit.resetState();

                        // Navigasi ke CheckInPage dan tunggu hasilnya (saat di-pop).
                        final result = await Navigator.push<CheckinState?>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CheckInPage(
                              streakDays: stats.currentStreak,
                              hasCheckedInToday: hasCheckedInToday,
                            ),
                          ),
                        );

                        // Jika hasilnya bukan null, tangani notifikasi di sini
                        if (result != null) {
                          if (result is CheckinSuccess) {
                            homeCubit.updateStreakAfterCheckin();
                            messenger
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                const SnackBar(
                                  content: Text("Check-in berhasil! ✅"),
                                  backgroundColor: Colors.green,
                                ),
                              );
                          } else if (result is CheckinFailure) {
                            messenger
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content: Text("Gagal check-in: ${result.error}"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                          }

                          // Setelah menampilkan notifikasi, reset state cubit agar bersih
                          checkinCubit.resetState();
                          // Refresh data home untuk memperbarui streak/statistics
                          homeCubit.fetchHomeData();
                        }
                      },
                      child: RoutineCard(
                        icon: 'assets/images/home/icon_checkin.png',
                        title: 'Check-In Harian',
                        subtitle: hasCheckedInToday
                            ? 'Kamu sudah check-in hari ini. Sampai jumpa besok!'
                            : 'Laporkan progres pemulihanmu hari ini',
                        backgroundColor: const Color(0xFFE3FDFB),
                      ),
                    ),
                    const SizedBox(height: 12),
                    RoutineCard(
                      icon: 'assets/images/home/icon_motivation.png',
                      title: 'Motivation',
                      subtitle:
                          'Dapatkan Motivasi Untuk tetap terus di jalan yang benar',
                      backgroundColor: const Color(0xFFFFF9C4),
                    ),
                    const SizedBox(height: 12),
                    RoutineCard(
                      icon: 'assets/images/home/icon_challenge.png',
                      title: 'Daily Activity Challenge',
                      subtitle:
                          'Dapatkan Tantangan harian untuk mengatasi rasa bosanmu',
                      backgroundColor: const Color(0xFFF3E5F5),
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
            color: Colors.grey.withAlpha((0.1 * 255).round()),
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
