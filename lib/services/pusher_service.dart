import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:fyp_flutter/models/chat_message.dart';
import 'package:fyp_flutter/models/dietician_chat_model.dart';
import 'package:fyp_flutter/models/user_chat_model.dart';
import 'package:fyp_flutter/providers/conversation_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fyp_flutter/providers/dietician_conversation_provider.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class PusherService {
  Future<dynamic> getMessages(
      {required String channelName,
      required ConversationProvider convProvider}) async {
    PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
    try {
      await pusher.init(
          apiKey: dotenv.env['PUSHER_APP_KEY'] ?? '',
          cluster: dotenv.env['PUSHER_APP_CLUSTER'] ?? '',
          onConnectionStateChange:
              (dynamic currentState, dynamic previousState) {
            print("Connection: $currentState");
          },
          onError: (String message, int? code, dynamic e) {
            print("onError: $message code: $code exception: $e");
          },
          onSubscriptionSucceeded: (String channelName, dynamic data) {
            print("onSubscriptionSucceeded: $channelName data: $data");
          },
          onEvent: (PusherEvent event) {
            Map<String, dynamic> jsonData = jsonDecode(event.data);

            if (jsonData.containsKey('read')) {
              Map<String, dynamic> read = jsonData['read'];
              convProvider.setMessagesRead(senderId: read['senderId']);
            }
            // Check if 'chatMessage' key exists in jsonData
            if (jsonData.containsKey('chatMessage')) {
              // Access the chatMessage object
              Map<String, dynamic> chatMessage = jsonData['chatMessage'];

              convProvider.saveMessage(
                  chatMessage: ChatMessage.fromJson(chatMessage));

              return true;
            }
          },
          onSubscriptionError: (String message, dynamic e) {
            print("onSubscriptionError: $message Exception: $e");
          },
          onDecryptionFailure: (String event, String reason) {
            print("onDecryptionFailure: $event reason: $reason");
          },
          onMemberAdded: (String channelName, PusherMember member) {
            print("onMemberAdded: $channelName member: $member");
          },
          onMemberRemoved: (String channelName, PusherMember member) {
            print("onMemberRemoved: $channelName member: $member");
          },
          onAuthorizer:
              (String channelName, String socketId, dynamic options) async {
            var digest = sha256;
            var secret = utf8.encode(dotenv.env['PUSHER_APP_SECRET'] ?? '');
            var stringToSign = utf8.encode("$socketId:$channelName");

            var hmac = Hmac(digest, secret);
            var signature = hmac.convert(stringToSign).toString();
            var key = dotenv.env['PUSHER_APP_KEY'];
            var auth = "$key:$signature";
            print(auth);
            print(channelName);
            print(socketId);
            return {
              "auth": auth,
              "shared_secret": dotenv.env['PUSHER_APP_SECRET'] ?? ''
            };
          });
      await pusher.subscribe(channelName: channelName);
      await pusher.connect();
    } catch (e) {
      print("ERROR: $e");
    }
  }

  Future<dynamic> getMessagesForDietician(
      {required String channelName,
      required DieticianConversationProvider convProvider}) async {
    PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
    try {
      await pusher.init(
          apiKey: dotenv.env['PUSHER_APP_KEY'] ?? '',
          cluster: dotenv.env['PUSHER_APP_CLUSTER'] ?? '',
          onConnectionStateChange:
              (dynamic currentState, dynamic previousState) {
            print("Connection: $currentState");
          },
          onError: (String message, int? code, dynamic e) {
            print("onError: $message code: $code exception: $e");
          },
          onSubscriptionSucceeded: (String channelName, dynamic data) {
            print("onSubscriptionSucceeded: $channelName data: $data");
          },
          onEvent: (PusherEvent event) {
            Map<String, dynamic> jsonData = jsonDecode(event.data);

            if (jsonData.containsKey('read')) {
              Map<String, dynamic> read = jsonData['read'];
              print(read['senderId']);
              for (var conversation in convProvider.conversations) {
                if (conversation.id == read['senderId']) {
                  for (var message in conversation.messages) {
                    message.read = 1;
                  }
                }
              }
            }
            // Check if 'chatMessage' key exists in jsonData
            if (jsonData.containsKey('chatMessage')) {
              // Access the chatMessage object
              Map<String, dynamic> chatMessage = jsonData['chatMessage'];

              convProvider.saveMessage(
                  chatMessage: ChatMessage.fromJson(chatMessage));
              return true;
            }
          },
          onSubscriptionError: (String message, dynamic e) {
            print("onSubscriptionError: $message Exception: $e");
          },
          onDecryptionFailure: (String event, String reason) {
            print("onDecryptionFailure: $event reason: $reason");
          },
          onMemberAdded: (String channelName, PusherMember member) {
            print("onMemberAdded: $channelName member: $member");
          },
          onMemberRemoved: (String channelName, PusherMember member) {
            print("onMemberRemoved: $channelName member: $member");
          },
          onAuthorizer:
              (String channelName, String socketId, dynamic options) async {
            var digest = sha256;
            var secret = utf8.encode(dotenv.env['PUSHER_APP_SECRET'] ?? '');
            var stringToSign = utf8.encode("$socketId:$channelName");

            var hmac = Hmac(digest, secret);
            var signature = hmac.convert(stringToSign).toString();
            var key = dotenv.env['PUSHER_APP_KEY'];
            var auth = "$key:$signature";
            print(auth);
            print(channelName);
            print(socketId);
            return {
              "auth": auth,
              "shared_secret": dotenv.env['PUSHER_APP_SECRET'] ?? ''
            };
          });
      await pusher.subscribe(channelName: channelName);
      await pusher.connect();
    } catch (e) {
      print("ERROR: $e");
    }
  }
}
