import 'dart:convert';

import 'package:fyp_flutter/models/conversation_model.dart';
import 'package:fyp_flutter/models/message_model.dart';
import 'package:fyp_flutter/models/user.dart';
import 'package:fyp_flutter/models/user_profile.dart';
import 'package:fyp_flutter/providers/base_provider.dart';
import 'package:fyp_flutter/services/conversation_service.dart';

class ConversationProvider extends BaseProvider {
  final ConversationService _conversationService = ConversationService();
  final List<ConversationModel> _conversations = [
    ConversationModel(
      id: '1',
      user: User(
        id: '1',
        name: 'John Doe',
        email: 'john@example.com',
        phoneNumber: '1234567890',
        token: 'abc123',
        profile: UserProfile(
          id: '1',
          userId: '1',
          height: 180,
          weight: 75,
          waist: 32,
          hips: 40,
          bust: 36,
          targetedWeight: 70,
          age: 30,
          gender: 'male',
          weightPlanId: '1',
          createdAt: '2024-02-18',
          updatedAt: '2024-02-18',
        ),
        cuisines: ['Italian', 'Chinese'],
        healthConditions: ['Hypertension', 'Diabetes'],
        allergens: ['Peanuts', 'Gluten'],
      ),
      createdAt: '2024-02-18',
      messages: [
        MessageModal(
          id: '1',
          body: 'Hello!',
          read: 0,
          userId: '1',
          conversationId: '1',
          createdAt: '2024-02-18',
          updatedAt: '2024-02-18',
        ),
        MessageModal(
          id: '2',
          body: 'Hi there!',
          read: 0,
          userId: '2',
          conversationId: '1',
          createdAt: '2024-02-18',
          updatedAt: '2024-02-18',
        ),
      ],
    ),
  ];
  List<ConversationModel> get conversations => _conversations;

  Future<List<ConversationModel>> getConversations() async {
    setBusy(true);
    var response = await _conversationService.getConversation();
    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());
      data['data'].forEach((conversations) =>
          _conversations.add(ConversationModel.fromJson(conversations)));
      print(response.toString());
      notifyListeners();
      setBusy(false);
    } else if (response.statusCode == 404) {
      setMessage(response.toString());
    }
    return _conversations;
  }

  Future<MessageModal> storeMessage(MessageModal message) async {
    setBusy(true);
    var response = await _conversationService.storeMessage(message);
    if (response.statusCode == 201) {
      var data = jsonDecode(response.toString());
      notifyListeners();
      setBusy(false);
      return MessageModal.fromJson(data['data']);
    }
    setBusy(false);
    return MessageModal(
        id: '',
        body: '',
        read: 0,
        userId: '',
        conversationId: '',
        createdAt: '',
        updatedAt: '');
  }
}
