class NotificationModel {
  final String id;
  final String userId;
  final String userType;
  final String message;
  final String? image;
  int read;
  final DateTime? scheduledAt;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.userType,
    required this.message,
    this.image,
    required this.read,
    this.scheduledAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      userId: json['user_id'],
      userType: json['user_type'],
      message: json['message'],
      image: json['image'],
      read: json['read'],
      scheduledAt: json['scheduled_at'] != null
          ? DateTime.parse(json['scheduled_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'user_type': userType,
      'message': message,
      'image': image,
      'read': read,
      'scheduled_at': scheduledAt?.toIso8601String(),
    };
  }
}
