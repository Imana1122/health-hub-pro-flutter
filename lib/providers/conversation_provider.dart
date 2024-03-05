import 'package:fyp_flutter/models/chat_message.dart';
import 'package:fyp_flutter/models/dietician_chat_model.dart';
import 'package:fyp_flutter/providers/base_provider.dart';
import 'package:fyp_flutter/services/conversation_service.dart';

class ConversationProvider extends BaseProvider {
  final ConversationService _conversationService = ConversationService();
  List<DieticianChatModel> _chatParticipants = [];

  List<DieticianChatModel> get conversations => _chatParticipants;

  Future<List<DieticianChatModel>> getChatParticipants(
      {required String token}) async {
    setBusy(true);

    var data = await _conversationService.getChatParticipants(token: token);
    List<DieticianChatModel> chatParticipants = List<DieticianChatModel>.from(
        data['data']
            .map((participant) => DieticianChatModel.fromJson(participant)));

    _chatParticipants = chatParticipants;

    notifyListeners();
    setBusy(false);

    return _chatParticipants;
  }

  Future<dynamic> saveMessage({required ChatMessage chatMessage}) async {
    setBusy(true);
    // Iterate over chatParticipants
    for (var chatParticipant in _chatParticipants) {
      if (chatMessage.senderId == chatParticipant.id) {
        // Add the new message directly to the list without reloading
        chatParticipant.messages.insert(0, chatMessage);
      }
    }

    notifyListeners();
    setBusy(false);
  }

  Future<ChatMessage> storeMessage(String message,
      {required String token, required String dieticianId}) async {
    setBusy(true);
    var data = await _conversationService.storeMessage(message,
        dieticianId: dieticianId, token: token);

    notifyListeners();
    setBusy(false);
    return ChatMessage.fromJson(data);
  }

  Future<dynamic> readMessages(
      {required String senderId, required String token}) async {
    var data = await _conversationService.readMessage(
        senderId: senderId, token: token);
    if (data == true) {
      // Find the conversation with the given senderId
      var conversation = _chatParticipants.firstWhere(
        (conversation) => conversation.id == senderId,
        orElse: () => const DieticianChatModel.empty(),
      );

      // If conversation found, mark its messages as read
      if (conversation != const DieticianChatModel.empty()) {
        for (var message in conversation.messages) {
          if (message.senderId == conversation.id) {
            message.read = 1;
          }
        }
        notifyListeners();
      }
    }

    return true;
  }
}
