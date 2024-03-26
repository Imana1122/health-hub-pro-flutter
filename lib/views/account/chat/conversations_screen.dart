import 'package:flutter/material.dart' hide Badge;
import 'package:fyp_flutter/common/color_extension.dart';
import 'package:fyp_flutter/common/size_config.dart';
import 'package:fyp_flutter/common_widget/chat_cards/conversation_card.dart';
import 'package:fyp_flutter/models/dietician_chat_model.dart';
import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:fyp_flutter/providers/conversation_provider.dart';
import 'package:fyp_flutter/providers/notification_provider.dart';
import 'package:fyp_flutter/services/pusher_service.dart';
import 'package:fyp_flutter/views/account/chat/chat_screen.dart';
import 'package:fyp_flutter/views/layouts/authenticated_user_layout.dart';
import 'package:provider/provider.dart';

class ConversationsScreen extends StatefulWidget {
  const ConversationsScreen({super.key});

  @override
  State<ConversationsScreen> createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> {
  late AuthProvider authProvider;
  List<DieticianChatModel> chatParticipants = [];
  late ConversationProvider convProvider;
  late NotificationProvider notiProvider;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    notiProvider = Provider.of<NotificationProvider>(context, listen: false);

    convProvider = Provider.of<ConversationProvider>(context, listen: false);
    chatParticipants = convProvider.conversations;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ConversationProvider>(context, listen: false)
          .getChatParticipants(token: authProvider.getAuthenticatedToken());
    });
    connectPusher();
  }

  // Inside the connectPusher method
  void connectPusher() async {
    PusherService pusherService =
        PusherService(); // Create an instance of PusherService
    await pusherService.getMessages(
        channelName: "private-user.${authProvider.getAuthenticatedUser().id}",
        convProvider: convProvider,
        notiProvider: notiProvider);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var provider = Provider.of<ConversationProvider>(context, listen: false);
    return AuthenticatedLayout(
      child: Scaffold(
        backgroundColor: TColor.white,
        appBar: AppBar(
          backgroundColor: TColor.primaryColor1,
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
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Conversations",
                style: TextStyle(
                    color: TColor.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
            ],
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
      ),
    );
  }
}
