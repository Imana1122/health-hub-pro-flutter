import 'package:fyp_flutter/common/color_extension.dart';
import 'package:fyp_flutter/common/size_config.dart';
import 'package:fyp_flutter/common_widget/chat_cards/friend_message_card.dart';
import 'package:fyp_flutter/common_widget/chat_cards/my_message_card.dart';
import 'package:fyp_flutter/models/chat_message.dart';
import 'package:fyp_flutter/models/user_chat_model.dart';
import 'package:fyp_flutter/providers/conversation_provider.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:fyp_flutter/providers/dietician_auth_provider.dart';
import 'package:fyp_flutter/providers/dietician_conversation_provider.dart';
import 'package:fyp_flutter/services/pusher_service.dart';
import 'package:provider/provider.dart';

class DieticianChatScreen extends StatefulWidget {
  final UserChatModel conversation;

  const DieticianChatScreen({super.key, required this.conversation});
  @override
  State<DieticianChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<DieticianChatScreen> {
  TextEditingController messageTextController = TextEditingController();
  late ChatMessage message;
  late ScrollController _scrollController;

  late DieticianAuthProvider authProvider;
  late DieticianConversationProvider convProvider;
  List<UserChatModel> chatParticipants = [];

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<DieticianAuthProvider>(context, listen: false);
    convProvider =
        Provider.of<DieticianConversationProvider>(context, listen: false);
    chatParticipants = convProvider.conversations;
    loadMore();

    connectPusher();
    _scrollController = ScrollController()..addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  void _scrollListener() {
    print('Scroll offset: ${_scrollController.offset}');
    print('Min scroll extent: ${_scrollController.position.minScrollExtent}');
    print('Max scroll extent: ${_scrollController.position.maxScrollExtent}');

    if (_scrollController.offset <= 0.0) {
      print('Triggering loadMore');
      loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Inside the connectPusher method
  void connectPusher() async {
    PusherService pusherService =
        PusherService(); // Create an instance of PusherService
    var result = await pusherService.getMessagesForDietician(
      channelName:
          "private-user.${authProvider.getAuthenticatedDietician().id}",
      convProvider: convProvider,
    );
    if (result == true) {
      convProvider.readMessages(
          senderId: widget.conversation.id,
          token: authProvider.getAuthenticatedToken());
    }
  }

  void loadMore() {
    if (widget.conversation.currentMessagePage > 1) {
      convProvider.loadMore(
          page: widget.conversation.currentMessagePage - 1,
          token: authProvider.getAuthenticatedToken(),
          userId: widget.conversation.id);
    }
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
      backgroundColor: TColor.mediumGray,
      appBar: AppBar(
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            height: 40,
            width: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: TColor.lightGray,
                borderRadius: BorderRadius.circular(10)),
            child: Image.asset(
              "assets/img/black_btn.png",
              width: 15,
              height: 15,
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
                widget.conversation.image.isNotEmpty
                    ? 'http://10.0.2.2:8000/uploads/users/thumb/${widget.conversation.image}'
                    : 'http://w3schools.fzxgj.top/Static/Picture/img_avatar3.png',
              ),
            ),
            const SizedBox(
                width: 10), // Add spacing between the avatar and title
            Text(
              '${widget.conversation.name} ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: TColor.white,
              ),
            ),
          ],
        ),
      ),
      body: Consumer<ConversationProvider>(
        builder: (context, cartProvider, _) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotification) {
                    if (scrollNotification is ScrollUpdateNotification) {
                      if (_scrollController.hasClients &&
                          _scrollController.offset <=
                              _scrollController.position.minScrollExtent) {
                        loadMore();
                      }
                    }
                    return false;
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.safeBlockHorizontal * 3,
                        vertical: SizeConfig.safeBlockHorizontal * 3),
                    itemCount: widget.conversation.messages.length,
                    itemBuilder: (context, index) {
                      final message = widget.conversation.messages[index];
                      return message.senderId == widget.conversation.id
                          ? FriendMessageCard(
                              message: message,
                              image: widget.conversation.image,
                            )
                          : MyMessageCard(message: message);
                    },
                  ),
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
                              if (messageTextController.text.trim().isEmpty) {
                                return;
                              }
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
                              widget.conversation.messages.add(messageStored);
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
