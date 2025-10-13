class CheckInResult {
  final String id;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;

  CheckInResult({
    required this.id,
    required this.startDate,
    this.endDate,
    required this.isActive,
  });

  factory CheckInResult.fromJson(Map<String, dynamic> json) {
    return CheckInResult(
      id: json['id'],
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      isActive: json['isActive'],
    );
  }
}