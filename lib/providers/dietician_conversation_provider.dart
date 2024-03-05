import 'package:fyp_flutter/models/chat_message.dart';
import 'package:fyp_flutter/models/user_chat_model.dart';
import 'package:fyp_flutter/providers/base_provider.dart';
import 'package:fyp_flutter/services/dietician/dietician_conversation_service.dart';

class DieticianConversationProvider extends BaseProvider {
  final DieticianConversationService _conversationService =
      DieticianConversationService();
  List<UserChatModel> _chatParticipants = [];

  List<UserChatModel> get conversations => _chatParticipants;

  Future<List<UserChatModel>> getChatParticipants(
      {required String token}) async {
    setBusy(true);

    var data = await _conversationService.getChatParticipants(token: token);
    List<UserChatModel> chatParticipants = List<UserChatModel>.from(
        data['data'].map((participant) => UserChatModel.fromJson(participant)));

    _chatParticipants = chatParticipants;

    notifyListeners();
    setBusy(false);

    return _chatParticipants;
  }

  Future<ChatMessage> storeMessage(String message,
      {required String token, required String userId}) async {
    setBusy(true);
    var data = await _conversationService.storeMessage(message,
        userId: userId, token: token);

    notifyListeners();
    setBusy(false);
    print("data::: $data");
    return ChatMessage.fromJson(data);
  }
}
