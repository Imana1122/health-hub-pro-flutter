import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fyp_flutter/models/chat_message.dart';
import 'package:fyp_flutter/models/notification.dart';
import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:fyp_flutter/providers/conversation_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fyp_flutter/providers/dietician_conversation_provider.dart';
import 'package:fyp_flutter/providers/dietician_notification_provider.dart';
import 'package:fyp_flutter/providers/notification_provider.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class PusherService {
  Future<dynamic> getMessages(
      {required String channelName,
      required ConversationProvider convProvider,
      required AuthProvider authProvider,
      required NotificationProvider notiProvider}) async {
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
            print('MESSAGE PUSHER :: $jsonData');

            if (jsonData.containsKey('read')) {
              Map<String, dynamic> read = jsonData['read'];
              convProvider.setMessagesRead(senderId: read['senderId']);
            }
            // Check if 'chatMessage' key exists in jsonData
            if (jsonData.containsKey('chatMessage')) {
              // Access the chatMessage object
              Map<String, dynamic> chatMessage = jsonData['chatMessage'];
              ChatMessage message = ChatMessage.fromJson(chatMessage);
              print('MESSAGE PUSHER :: $message');

              if (authProvider.getAuthenticatedUser().profile.notification ==
                  1) {
                showNotification(message.message ?? '');
              }

              convProvider.saveMessage(chatMessage: message);

              return true;
            }
            if (jsonData.containsKey('notification')) {
              try {
                // Access the notification object
                Map<String, dynamic> notification = jsonData['notification'];

                // Parse the notification object into a NotificationModel
                NotificationModel message =
                    NotificationModel.fromJson(notification);

                // Print the message
                print('MESSAGE PUSHER :: $message');

                if (authProvider.getAuthenticatedUser().profile.notification ==
                    1) {
                  showNotification(message.message ?? '');
                }
                // Save notification
                notiProvider.saveNotification(item: message);

                return true;
              } catch (e) {
                print('Error parsing notification data: $e');
                return false;
              }
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
      required DieticianNotificationProvider notiProvider,
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
              ChatMessage message = ChatMessage.fromJson(chatMessage);

              showNotification(message.message ?? '');

              convProvider.saveMessage(chatMessage: message);

              return true;
            }
            if (jsonData.containsKey('notification')) {
              try {
                // Access the notification object
                Map<String, dynamic> notification = jsonData['notification'];

                // Parse the notification object into a NotificationModel
                NotificationModel message =
                    NotificationModel.fromJson(notification);

                // Print the message
                print(message);              

               

                showNotification(message.message ?? '');

                // Save notification
                notiProvider.saveNotification(item: message);

                return true;
              } catch (e) {
                print('Error parsing notification data: $e');
                return false;
              }
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
            print("auth: - $auth");
            print("channelname :: $channelName");
            print("socket id : $socketId");

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

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> showNotification(message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('1', 'HealthHub Pro',
            importance: Importance.max, priority: Priority.high);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'Health Hub Pro', message, platformChannelSpecifics,
        payload: 'item x');
  }
}
