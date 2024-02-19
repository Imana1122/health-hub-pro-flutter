import 'package:fyp_flutter/models/user.dart';
import 'message_model.dart';

class ConversationModel {
  String id;
  User? user;
  String createdAt;
  List<MessageModal> messages;

  ConversationModel({
    required this.id,
    required this.user,
    required this.createdAt,
    required this.messages,
  });

  ConversationModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        user = json['user'] != null ? User.fromJson(json['user']) : null,
        createdAt = json['created_at'],
        messages = (json['messages'] as List<dynamic>?)
                ?.map((v) => MessageModal.fromJson(v))
                .toList() ??
            [];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user?.toJson(),
      'created_at': createdAt,
      'messages': messages.map((v) => v.toJson()).toList(),
    };
  }
}
