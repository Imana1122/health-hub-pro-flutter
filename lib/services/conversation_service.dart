import 'package:http/http.dart';

import './base_api.dart';

class ConversationService extends BaseApi {
  Future<dynamic> getChatParticipants({required String token}) async {
    return await api.httpGet('account/chats/participants', token: token);
  }

  Future<dynamic> getConversation(
      {required String token, required String id}) async {
    return await api.httpGet('account/chats/$id', token: token);
  }

  Future<dynamic> storeMessage(String message,
      {required String token, required String dieticianId}) async {
    return await api.httpPost('account/chats/store',
        body: {'message': message, 'dietician_id': dieticianId}, token: token);
  }

  Future<dynamic> readMessage(
      {required String senderId, required String token}) async {
    return await api.httpPost('account/chats/read',
        body: {'sender_id': senderId}, token: token);
  }
}
