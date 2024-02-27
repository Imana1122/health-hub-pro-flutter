import 'package:flutter/material.dart' hide Badge;
import 'package:fyp_flutter/common/color_extension.dart';
import 'package:fyp_flutter/common_widget/cards/conversation_card.dart';
import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:fyp_flutter/providers/conversation_provider.dart';
import 'package:fyp_flutter/views/chat/chat_screen.dart';
import 'package:fyp_flutter/views/chat/size_config.dart';
import 'package:provider/provider.dart';

class ConversationsScreen extends StatefulWidget {
  const ConversationsScreen({super.key});

  @override
  State<ConversationsScreen> createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> {
  late AuthProvider authProvider;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ConversationProvider>(context, listen: false)
          .getConversations(token: authProvider.getAuthenticatedToken());
    });
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
            Provider.of<AuthProvider>(context, listen: false).logout();
            Navigator.of(context)
                .pushNamedAndRemoveUntil("/", (route) => false);
          },
          icon: const Icon(Icons.logout),
        ),
      ),
      body: Center(
        child: provider.busy
            ? const CircularProgressIndicator()
            : ListView.builder(
                padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
                itemCount: provider.conversations.length,
                itemBuilder: (context, index) => ConversationCard(
                  conversation: provider.conversations[index],
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => ChatScreen(
                            conversation: provider.conversations[index],
                          ))),
                ),
              ),
      ),
    );
  }
}
