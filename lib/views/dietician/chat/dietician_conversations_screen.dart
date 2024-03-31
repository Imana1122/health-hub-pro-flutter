import 'package:flutter/material.dart' hide Badge;
import 'package:fyp_flutter/common/color_extension.dart';
import 'package:fyp_flutter/common/size_config.dart';
import 'package:fyp_flutter/common_widget/dietician_chat_cards/dietician_conversation_card.dart';
import 'package:fyp_flutter/providers/dietician_auth_provider.dart';
import 'package:fyp_flutter/providers/dietician_conversation_provider.dart';
import 'package:fyp_flutter/providers/dietician_notification_provider.dart';
import 'package:fyp_flutter/services/pusher_service.dart';
import 'package:fyp_flutter/views/dietician/chat/dietician_chat_screen.dart';
import 'package:provider/provider.dart';

class DieticianConversationScreen extends StatefulWidget {
  const DieticianConversationScreen({super.key});

  @override
  State<DieticianConversationScreen> createState() =>
      _DieticianConversationScreenState();
}

class _DieticianConversationScreenState
    extends State<DieticianConversationScreen> {
  late DieticianAuthProvider authProvider;
  late DieticianConversationProvider convProvider;
  late DieticianNotificationProvider notiProvider;
  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<DieticianAuthProvider>(context, listen: false);
    notiProvider =
        Provider.of<DieticianNotificationProvider>(context, listen: false);

    convProvider =
        Provider.of<DieticianConversationProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DieticianConversationProvider>(context, listen: false)
          .getChatParticipants(token: authProvider.getAuthenticatedToken());
    });
    connectPusher();
  }

  connectPusher() async {
    try {
      PusherService().getMessagesForDietician(
          channelName:
              "dietician.${authProvider.getAuthenticatedDietician().id}",
          notiProvider: notiProvider,
          convProvider: convProvider);
    } catch (e) {
      print("ERROR: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var provider =
        Provider.of<DieticianConversationProvider>(context, listen: false);
    return Scaffold(
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
            : Consumer<DieticianConversationProvider>(
                builder: (context, cartProvider, _) {
                return ListView.builder(
                  padding:
                      EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
                  itemCount: provider.conversations.length,
                  itemBuilder: (context, index) => DieticianConversationCard(
                    conversation: provider.conversations[index],
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => DieticianChatScreen(
                              conversation: provider.conversations[index],
                            ))),
                  ),
                );
              }),
      ),
    );
  }
}
