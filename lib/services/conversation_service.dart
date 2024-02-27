import 'package:fyp_flutter/models/message_model.dart';
import 'package:http/http.dart';

import './base_api.dart';

class ConversationService extends BaseApi {
  Future<Response> getConversation({required String token}) async {
    return await api.conversationGet('conversations', query: {}, token: token);
  }

  Future<Response> storeMessage(MessageModal message,
      {required String token}) async {
    return await api.conversationPost(
        'messages',
        {
          'body': message.body,
          'conversation_id': message.conversationId,
        },
        token: token);
  }
}
