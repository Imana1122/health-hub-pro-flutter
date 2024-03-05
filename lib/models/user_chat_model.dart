import 'package:fyp_flutter/models/chat_message.dart';

class UserChatModel {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String image;
  final int status;
  final String createdAt;
  final String updatedAt;
  final String otherUserId;

  final List<ChatMessage> messages;

  UserChatModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.image,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.otherUserId,
    required this.messages,
  });

  factory UserChatModel.fromJson(Map<String, dynamic> json) {
    List<ChatMessage> messageList = [];
    if (json['messages'] != null) {
      messageList = List<ChatMessage>.from(
          json['messages'].map((message) => ChatMessage.fromJson(message)));
    }
    return UserChatModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      image: json['image'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      otherUserId: json['otherUserId'],
      messages: messageList,
    );
  }
}
