import 'package:fyp_flutter/common/color_extension.dart';
import 'package:fyp_flutter/common/size_config.dart';
import 'package:fyp_flutter/common_widget/dietician_chat_cards/dietician_friend_message_card.dart';
import 'package:fyp_flutter/common_widget/dietician_chat_cards/dietician_my_message_card.dart';
import 'package:fyp_flutter/models/chat_message.dart';
import 'package:fyp_flutter/models/user_chat_model.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:fyp_flutter/providers/dietician_auth_provider.dart';
import 'package:fyp_flutter/providers/dietician_conversation_provider.dart';
import 'package:provider/provider.dart';

class DieticianChatScreen extends StatefulWidget {
  final UserChatModel conversation;

  const DieticianChatScreen({super.key, required this.conversation});
  @override
  State<DieticianChatScreen> createState() => _DieticianChatScreenState();
}

class _DieticianChatScreenState extends State<DieticianChatScreen> {
  TextEditingController messageTextController = TextEditingController();
  late ChatMessage message;
  late ScrollController _scrollController;

  late DieticianAuthProvider authProvider;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<DieticianAuthProvider>(context, listen: false);
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
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
        title: Text(widget.conversation.name),
        centerTitle: true,
      ),
      body: Consumer<DieticianConversationProvider>(
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
                        ? DieticianFriendMessageCard(
                            message: message,
                            image: widget.conversation.image,
                          )
                        : DieticianMyMessageCard(message: message);
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
                    Provider.of<DieticianConversationProvider>(context).busy
                        ? const CircularProgressIndicator()
                        : InkWell(
                            onTap: () async {
                              FocusScope.of(context).requestFocus(FocusNode());
                              if (messageTextController.text.trim().isEmpty) {
                                return;
                              }
                              String message =
                                  messageTextController.text.trim();
                              var messageStored = await Provider.of<
                                          DieticianConversationProvider>(
                                      context,
                                      listen: false)
                                  .storeMessage(message,
                                      userId: widget.conversation.id,
                                      token:
                                          authProvider.getAuthenticatedToken());
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
