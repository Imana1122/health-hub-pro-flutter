import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fyp_flutter/common/color_extension.dart';
import 'package:fyp_flutter/common/size_config.dart';
import 'package:fyp_flutter/common_widget/chat_cards/conversation_card.dart';
import 'package:fyp_flutter/models/chat_message.dart';
import 'package:fyp_flutter/models/dietician_chat_model.dart';
import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:fyp_flutter/providers/conversation_provider.dart';
import 'package:fyp_flutter/services/pusher_service.dart';
import 'package:fyp_flutter/views/account/chat/chat_screen.dart';
import 'package:provider/provider.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class ConversationsScreen extends StatefulWidget {
  const ConversationsScreen({super.key});

  @override
  State<ConversationsScreen> createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> {
  late AuthProvider authProvider;
  List<DieticianChatModel> chatParticipants = [];
  late ConversationProvider convProvider;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    connectPusher();
    convProvider = Provider.of<ConversationProvider>(context, listen: false);
    chatParticipants = convProvider.conversations;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ConversationProvider>(context, listen: false)
          .getChatParticipants(token: authProvider.getAuthenticatedToken());
    });
  }

  // Inside the connectPusher method
  void connectPusher() async {
    PusherService pusherService =
        PusherService(); // Create an instance of PusherService
    await pusherService.getMessagesForUser(
      channelName: "private-user.${authProvider.getAuthenticatedUser().id}",
      convProvider: convProvider,
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var provider = Provider.of<ConversationProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: TColor.white,
      appBar: AppBar(
        backgroundColor: TColor.primaryColor1,
        title: const Text('Conversations'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () async {
            Navigator.of(context)
                .pushNamedAndRemoveUntil("/", (route) => false);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Center(
        child: provider.busy
            ? const CircularProgressIndicator()
            : Consumer<ConversationProvider>(
                builder: (context, conversationProvider, _) {
                return ListView.builder(
                  padding:
                      EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
                  itemCount: conversationProvider.conversations.length,
                  itemBuilder: (context, index) => ConversationCard(
                    conversation: conversationProvider.conversations[index],
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => ChatScreen(
                              conversation:
                                  conversationProvider.conversations[index],
                            ))),
                  ),
                );
              }),
      ),
    );
  }
}
