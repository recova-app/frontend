class User {
  final String id;
  final String email;
  final String nickname;
  final String? userWhy;
  final String? checkinTime;
  final DateTime createdAt;

  User({
    required this.id,
    required this.email,
    required this.nickname,
    this.userWhy,
    this.checkinTime,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      nickname: json['nickname'] ?? '',
      userWhy: json['userWhy'],
      checkinTime: json['checkinTime'],
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'nickname': nickname,
      'userWhy': userWhy,
      'checkinTime': checkinTime,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
