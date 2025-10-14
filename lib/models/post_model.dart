class Post {
  final String id;
  final String title;
  final String content;
  final String category;
  final int commentCount;
  final int likeCount;
  final DateTime createdAt;
  final String userId;
  final String? username; // Opsional, jika backend mengirimkannya
  final int? userStreak; // Opsional, jika backend mengirimkannya
  final bool isLiked; // Untuk melacak apakah post ini sudah di-like oleh user

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.commentCount,
    required this.likeCount,
    required this.createdAt,
    required this.userId,
    this.username,
    this.userStreak,
    this.isLiked = false,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      // Asumsi backend mengirim 'category'
      category: json['category'] ?? 'Nasihat',
      commentCount: json['commentCount'] ?? 0,
      likeCount: json['likeCount'] ?? 0,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      userId: json['userId'] ?? '',
      // Jika backend mengirim data user, kita bisa parse di sini
      username: json['user'] != null ? json['user']['nickname'] : 'Anonim',
      userStreak: json['user'] != null ? json['user']['currentStreak'] : 0,
      // Asumsi backend mengirim field 'isLiked'
      isLiked: json['isLiked'] ?? false,
    );
  }

  Post copyWith({
    String? id,
    String? title,
    String? content,
    String? category,
    int? commentCount,
    int? likeCount,
    DateTime? createdAt,
    String? userId,
    String? username,
    int? userStreak,
    bool? isLiked,
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      commentCount: commentCount ?? this.commentCount,
      likeCount: likeCount ?? this.likeCount,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      userStreak: userStreak ?? this.userStreak,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  // Helper untuk mengubah Post menjadi Map yang bisa dipakai di PostCard
  Map<String, dynamic> toPostCardMap() {
    return {'id': id, 'username': username, 'likes': likeCount, 'text': content, 'streak': userStreak, 'category': category, 'isLiked': isLiked};
  }
}