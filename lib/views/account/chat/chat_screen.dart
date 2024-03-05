import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fyp_flutter/common/color_extension.dart';
import 'package:fyp_flutter/common/size_config.dart';
import 'package:fyp_flutter/common_widget/chat_cards/friend_message_card.dart';
import 'package:fyp_flutter/common_widget/chat_cards/my_message_card.dart';
import 'package:fyp_flutter/models/chat_message.dart';
import 'package:fyp_flutter/models/dietician_chat_model.dart';
import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:fyp_flutter/providers/conversation_provider.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:fyp_flutter/services/pusher_service.dart';
import 'package:provider/provider.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class ChatScreen extends StatefulWidget {
  final DieticianChatModel conversation;

  const ChatScreen({super.key, required this.conversation});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageTextController = TextEditingController();
  late ChatMessage message;
  late ScrollController _scrollController;

  late AuthProvider authProvider;
  late ConversationProvider convProvider;
  List<DieticianChatModel> chatParticipants = [];

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    convProvider = Provider.of<ConversationProvider>(context, listen: false);
    chatParticipants = convProvider.conversations;
    connectPusher();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
    readMessages();
  }

  // Inside the connectPusher method
  void connectPusher() async {
    PusherService pusherService =
        PusherService(); // Create an instance of PusherService
    await pusherService.getMessagesForUser(
        channelName: "private-user.${authProvider.getAuthenticatedUser().id}",
        convProvider: convProvider,
        model: widget.conversation,
        token: authProvider.getAuthenticatedToken());
  }

  void readMessages() {
    convProvider.readMessages(
        senderId: widget.conversation.id,
        token: authProvider.getAuthenticatedToken());
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: TColor.gray,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text(
            '${widget.conversation.firstName} ${widget.conversation.lastName}'),
        centerTitle: true,
      ),
      body: Consumer<ConversationProvider>(
        builder: (context, cartProvider, _) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.safeBlockHorizontal * 3,
                      vertical: SizeConfig.safeBlockHorizontal * 3),
                  itemCount: widget.conversation.messages.length,
                  itemBuilder: (context, index) {
                    final reversedIndex =
                        widget.conversation.messages.length - 1 - index;
                    final message = widget.conversation.messages[reversedIndex];
                    return message.senderId == widget.conversation.id
                        ? FriendMessageCard(
                            message: message,
                            image: widget.conversation.image,
                          )
                        : MyMessageCard(message: message);
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: TColor.lightGray,
                    borderRadius: BorderRadius.circular(32)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: TextField(
                        controller: messageTextController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Type your message...',
                            hintStyle: TextStyle()),
                      ),
                    ),
                    Provider.of<ConversationProvider>(context).busy
                        ? const CircularProgressIndicator()
                        : InkWell(
                            onTap: () async {
                              FocusScope.of(context).requestFocus(FocusNode());
                              if (messageTextController.text.trim().isEmpty)
                                return;
                              String message =
                                  messageTextController.text.trim();
                              var messageStored =
                                  await Provider.of<ConversationProvider>(
                                          context,
                                          listen: false)
                                      .storeMessage(message,
                                          dieticianId: widget.conversation.id,
                                          token: authProvider
                                              .getAuthenticatedToken());
                              messageTextController.clear();
                              widget.conversation.messages
                                  .insert(0, messageStored);
                              _scrollController.jumpTo(
                                  _scrollController.position.maxScrollExtent +
                                      30);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                    colors: [
                                      TColor.primaryColor1,
                                      TColor.secondaryColor1,
                                      TColor.primaryColor2,
                                      TColor.secondaryColor2,
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter),
                              ),
                              child: const Icon(
                                Icons.send,
                                color: Colors.white,
                              ),
                            ),
                          )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
