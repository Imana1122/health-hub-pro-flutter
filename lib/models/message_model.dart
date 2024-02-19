class MessageModal {
  String id;
  String body;
  int read;
  String userId;
  String conversationId;
  String createdAt;
  String updatedAt;

  MessageModal(
      {required this.id,
      required this.body,
      required this.read,
      required this.userId,
      required this.conversationId,
      required this.createdAt,
      required this.updatedAt});

  MessageModal.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        body = json['body'],
        read = json['read'],
        userId = json['user_id'],
        conversationId = json['conversation_id'],
        createdAt = json['created_at'],
        updatedAt = json['updated_at'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['body'] = body;
    data['read'] = read;
    data['user_id'] = userId;
    data['conversation_id'] = conversationId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
