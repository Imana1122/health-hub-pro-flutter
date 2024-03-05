import 'package:fyp_flutter/services/base_api.dart';

class DieticianConversationService extends BaseApi {
  Future<dynamic> getChatParticipants({required String token}) async {
    return await api.httpGet('dietician/chats/participants', token: token);
  }

  Future<dynamic> getConversation(
      {required String token, required String id}) async {
    return await api.httpGet('dietician/chats/$id', token: token);
  }

  Future<dynamic> storeMessage(String message,
      {required String token, required String userId}) async {
    return await api.httpPost('dietician/chats/store',
        body: {'message': message, 'user_id': userId}, token: token);
  }
}
