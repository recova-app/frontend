import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recova/bloc/home_cubit.dart';
import 'package:recova/models/statistics_model.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:async';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Timer? _timer;
  Duration _timeSinceLastRelapse = Duration.zero;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final homeState = context.read<HomeCubit>().state;
      if (homeState is HomeLoadSuccess) {
        // Menggunakan tanggal awal streak, bukan tanggal terakhir
        final streakStartDate = _getStreakStartDate(homeState.statistics);
        if (streakStartDate != null && mounted) {
          setState(() {
            _timeSinceLastRelapse = DateTime.now().difference(streakStartDate);
          });
        }
      }
    });
  }

  DateTime? _getStreakStartDate(Statistics stats) {
    if (stats.currentStreak == 0 || stats.streakCalendar.isEmpty) return null;

    try {
      // Ambil tanggal check-in terakhir
      final lastCheckIn = DateTime.parse(stats.streakCalendar.last);
      // Hitung tanggal mulai dengan mengurangi jumlah hari streak
      final startDate = lastCheckIn.subtract(Duration(days: stats.currentStreak - 1));
      // Kembalikan tanggal tanpa informasi jam, menit, detik
      return DateTime(startDate.year, startDate.month, startDate.day);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading || state is HomeInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is HomeLoadFailure) {
            return Center(child: Text('Gagal memuat statistik: ${state.error}'));
          }
          if (state is HomeLoadSuccess) {
            final stats = state.statistics;
            final totalDays = 32;
            final streakEvents =
                stats.streakCalendar.map((date) => DateTime.parse(date)).toSet();

            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Statistik",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const CircleAvatar(
                          backgroundImage:
                              AssetImage("assets/images/logo.png"),
                          radius: 20,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Card 1: Streak
                    _buildStreakCard(stats.currentStreak, stats.longestStreak, totalDays),
                    const SizedBox(height: 16),

                    // Card 2: Durasi
                    _buildDurationCard(),
                    const SizedBox(height: 20),

                    // Kalender
                    const Text(
                      "Kalender Streak",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    TableCalendar(
                      firstDay: DateTime.utc(2020, 1, 1),
                      lastDay: DateTime.utc(2030, 12, 31),
                      focusedDay: _focusedDay,
                      selectedDayPredicate: (day) =>
                          isSameDay(_selectedDay, day),
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                      },
                      headerStyle: const HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                      ),
                      calendarStyle: CalendarStyle(
                        todayDecoration: BoxDecoration(
                          color: Colors.teal.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        selectedDecoration: BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                      ),
                      eventLoader: (day) {
                        if (streakEvents
                            .any((eventDate) => isSameDay(eventDate, day))) {
                          return [Container()];
                        }
                        return [];
                      },
                      calendarBuilders: CalendarBuilders(
                        markerBuilder: (context, day, events) {
                          if (events.isNotEmpty) {
                            return Positioned(
                              bottom: 5,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                                width: 7,
                                height: 7,
                              ),
                            );
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildStreakCard(int currentStreak, int longestStreak, int totalDays) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[400],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$currentStreak Hari Streak 🔥",
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(
            "Streak Terbaik kamu adalah $longestStreak hari",
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 12),
          Text(
            "Progress: $currentStreak / $totalDays Days",
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: totalDays > 0 ? currentStreak / totalDays : 0,
              backgroundColor: Colors.white30,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Bagian yang diperbarui agar mirip dengan gambar contoh
  Widget _buildDurationCard() {
    final days = _timeSinceLastRelapse.inDays;
    final hours = _timeSinceLastRelapse.inHours % 24;
    final minutes = _timeSinceLastRelapse.inMinutes % 60;
    final seconds = _timeSinceLastRelapse.inSeconds % 60;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF52C3BE),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Anda Bebas Pornografi Selama",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          _buildRoundedBar(
            label: "$days Hari",
            progress: days > 0 ? 1.0 : 0.0, // Bar penuh jika sudah lebih dari 0 hari
            color: const Color(0xFF0D3B66),
          ),
          const SizedBox(height: 12),
          _buildRoundedBar(
            label: "$hours Jam",
            progress: hours / 24, // Progres jam dalam sehari
            color: const Color(0xFFFFB703),
          ),
          const SizedBox(height: 12),
          _buildRoundedBar(
            label: "$minutes Menit",
            progress: minutes / 60, // Progres menit dalam satu jam
            color: const Color(0xFF457B9D),
          ),
          const SizedBox(height: 12),
          _buildRoundedBar(
            label: "$seconds Detik",
            progress: seconds / 60, // Progres detik dalam satu menit
            color: const Color.fromARGB(255, 47, 144, 134),
          ),
        ],
      ),
    );
  }

  Widget _buildRoundedBar({
    required String label,
    required double progress,
    required Color color,
  }) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        // Latar belakang bar
        Container(
          height: 28,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        // Bar progres yang memanjang
        FractionallySizedBox(
          widthFactor: progress.clamp(0.0, 1.0),
          child: Container(
            height: 28,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(50),
            ),
          ),
        ),
        // Teks label yang selalu terlihat di atas
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
  