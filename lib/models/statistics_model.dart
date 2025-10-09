class Statistics {
  final int currentStreak;
  final int longestStreak;
  final int totalCheckins;
  final List<String> streakCalendar;

  Statistics({
    required this.currentStreak,
    required this.longestStreak,
    required this.totalCheckins,
    required this.streakCalendar,
  });

  factory Statistics.fromJson(Map<String, dynamic> json) {
    return Statistics(
      currentStreak: json['currentStreak'] ?? 0,
      longestStreak: json['longestStreak'] ?? 0,
      totalCheckins: json['totalCheckins'] ?? 0,
      streakCalendar: List<String>.from(json['streakCalendar'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'totalCheckins': totalCheckins,
      'streakCalendar': streakCalendar,
    };
  }
}
