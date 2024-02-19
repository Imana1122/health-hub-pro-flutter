import 'package:fyp_flutter/common/color_extension.dart';
import 'package:fyp_flutter/common_widget/cards/friend_message_card.dart';
import 'package:fyp_flutter/common_widget/cards/my_message_card.dart';
import 'package:fyp_flutter/models/conversation_model.dart';
import 'package:fyp_flutter/models/message_model.dart';
import 'package:fyp_flutter/providers/conversation_provider.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:fyp_flutter/views/chat/size_config.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final ConversationModel conversation;

  const ChatScreen({super.key, required this.conversation});
  @override
  _ChatScreenState createState() => _ChatScreenState(conversation);
}

class _ChatScreenState extends State<ChatScreen> {
  final ConversationModel conversation;
  TextEditingController messageTextController = TextEditingController();
  late MessageModal message;
  late ScrollController _scrollController;

  _ChatScreenState(this.conversation);

  @override
  void initState() {
    super.initState();
    message = MessageModal(
        id: 'kdjfkl',
        body: 'ldjfkdk;lj',
        read: 0,
        userId: 'ldkfjd;lkj',
        conversationId: 'ldkfjd;kl',
        createdAt: '2022-09-09',
        updatedAt: '2022-09-09');
    message.conversationId = conversation.id;
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
        title: Text('${conversation.user?.name}'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
              child: ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.safeBlockHorizontal * 3,
                vertical: SizeConfig.safeBlockHorizontal * 3),
            itemCount: conversation.messages.length,
            itemBuilder: (context, index) =>
                conversation.messages[index].userId == conversation.user!.id
                    ? FriendMessageCard(
                        message: conversation.messages[index],
                        image: conversation.user!.image,
                      )
                    : MyMessageCard(message: conversation.messages[index]),
            // const FriendMessageCard(message: '',image:''),
            // MyMessageCard(),
          )),
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: TColor.gray, borderRadius: BorderRadius.circular(32)),
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
                          if (messageTextController.text.trim().isEmpty) return;
                          message.body = messageTextController.text.trim();
                          var messageStored =
                              await Provider.of<ConversationProvider>(context,
                                      listen: false)
                                  .storeMessage(message);
                          messageTextController.clear();
                          conversation.messages.add(messageStored);
                          _scrollController.jumpTo(
                              _scrollController.position.maxScrollExtent + 30);
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
      ),
    );
  }
}
