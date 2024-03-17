import 'package:flutter/material.dart' hide Badge;
import 'package:fyp_flutter/common/color_extension.dart';
import 'package:fyp_flutter/common/size_config.dart';
import 'package:fyp_flutter/common_widget/dietician_chat_cards/dietician_conversation_card.dart';
import 'package:fyp_flutter/providers/dietician_auth_provider.dart';
import 'package:fyp_flutter/providers/dietician_conversation_provider.dart';
import 'package:fyp_flutter/views/dietician/chat/dietician_chat_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class DieticianConversationScreen extends StatefulWidget {
  const DieticianConversationScreen({super.key});

  @override
  State<DieticianConversationScreen> createState() =>
      _DieticianConversationScreenState();
}

class _DieticianConversationScreenState
    extends State<DieticianConversationScreen> {
  late DieticianAuthProvider authProvider;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<DieticianAuthProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DieticianConversationProvider>(context, listen: false)
          .getChatParticipants(token: authProvider.getAuthenticatedToken());
    });
    connectPusher();
  }

  connectPusher() async {
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
            print('Received event: $event');
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
          authEndpoint: "${dotenv.env['BASE_URL']}/api/pusher/auth",
          onAuthorizer:
              (String channelName, String socketId, dynamic options) async {
            print(channelName);
            return {
              "socket_id": socketId,
              "channel_name": channelName,
              "options": options
            };
          });
      await pusher.subscribe(
          channelName:
              "private-dietician.${authProvider.getAuthenticatedDietician().id}");
      await pusher.connect();
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
