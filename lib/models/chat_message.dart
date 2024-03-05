class ChatMessage {
  final int id;
  final String senderType;
  final String senderId;
  final String receiverType;
  final String receiverId;
  final String? message;
  final String? file;
  int read;

  final String createdAt;
  final String updatedAt;

  ChatMessage({
    required this.id,
    required this.senderType,
    required this.senderId,
    required this.receiverType,
    required this.receiverId,
    this.message,
    this.file,
    required this.read,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      senderType: json['sender_type'],
      senderId: json['sender_id'],
      receiverType: json['receiver_type'],
      receiverId: json['receiver_id'],
      message: json['message'],
      file: json['file'],
      read: json['read'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
  void setRead(int value) {
    // Add any validation or logic here
    read = value;
  }
}
