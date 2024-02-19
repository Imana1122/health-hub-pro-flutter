import 'package:fyp_flutter/models/message_model.dart';
import 'package:http/http.dart';

import './base_api.dart';

class ConversationService extends BaseApi {
  Future<Response> getConversation() async {
    return await api.httpGet('conversations', query: {});
  }

  Future<Response> storeMessage(MessageModal message) async {
    return await api.httpPost('messages',
        {'body': message.body, 'conversation_id': message.conversationId});
  }
}
