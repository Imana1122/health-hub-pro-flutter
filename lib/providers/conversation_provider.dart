import 'dart:io';

import 'package:fyp_flutter/models/chat_message.dart';
import 'package:fyp_flutter/models/dietician_chat_model.dart';
import 'package:fyp_flutter/providers/base_provider.dart';
import 'package:fyp_flutter/services/account/conversation_service.dart';

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
        chatParticipant.messages.add(chatMessage);
      }
    }

    notifyListeners();
    setBusy(false);
  }

  Future<ChatMessage> storeMessage(String message,
      {required String token, required String dieticianId, File? file}) async {
    setBusy(true);
    var data = await _conversationService.storeMessage(message, file,
        dieticianId: dieticianId, token: token);

    notifyListeners();
    setBusy(false);
    return ChatMessage.fromJson(data);
  }

  Future<void> loadMore(
      {required String token,
      required String dieticianId,
      required int page}) async {
    setBusy(true);

    // Load more messages from the conversation service
    var loadedMessages = await _conversationService.loadMoreMessages(
      page: page,
      dieticianId: dieticianId,
      token: token,
    );

    // Find the chat participant with the specified ID (dieticianId)
    var chatParticipant = _chatParticipants.firstWhere(
      (participant) => participant.id == dieticianId,
      orElse: () => DieticianChatModel.empty(),
    );

    // If the chat participant is found, add the loaded messages to their existing messages
    if (chatParticipant != DieticianChatModel.empty()) {
      // Add the loaded messages to the existing messages list
      print(loadedMessages['data']);
      List<dynamic> dynamicList = loadedMessages['data'];
      List<ChatMessage> chatMessagesList = dynamicList.map((data) {
        // Assuming ChatMessage.fromJson() converts dynamic data to ChatMessage
        return ChatMessage.fromJson(data);
      }).toList();
      chatParticipant.currentMessagePage = loadedMessages['current_page'];
      chatParticipant.messages.insertAll(0, chatMessagesList);
      // chatParticipant.currentMessagePage = loadedMessages['current_page'];
    }

    // Notify listeners about the changes
    notifyListeners();

    setBusy(false);
  }

  Future<dynamic> readMessages(
      {required String senderId, required String token}) async {
    var data = await _conversationService.readMessage(
        senderId: senderId, token: token);
    if (data == true) {
      // Find the conversation with the given senderId
      var conversation = _chatParticipants.firstWhere(
        (conversation) => conversation.id == senderId,
        orElse: () => DieticianChatModel.empty(),
      );

      // If conversation found, mark its messages as read
      if (conversation != DieticianChatModel.empty()) {
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

  Future<dynamic> setMessagesRead({required String senderId}) async {
    for (var conversation in conversations) {
      if (conversation.id == senderId) {
        for (var message in conversation.messages) {
          message.read = 1;
        }
        notifyListeners();
      }
    }

    return true;
  }
}
