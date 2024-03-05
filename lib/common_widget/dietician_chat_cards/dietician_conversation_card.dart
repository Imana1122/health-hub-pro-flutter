import 'package:flutter/material.dart' hide Badge;
import 'package:fyp_flutter/common/color_extension.dart';
import 'package:fyp_flutter/models/user_chat_model.dart';
import 'package:jiffy/jiffy.dart';

class DieticianConversationCard extends StatelessWidget {
  final UserChatModel conversation;
  final Function()? onTap;
  const DieticianConversationCard({
    super.key,
    required this.onTap,
    required this.conversation,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundImage: NetworkImage(conversation.image != ''
            ? 'http://10.0.2.2:8000/uploads/users/${conversation.image}'
            : 'http://w3schools.fzxgj.top/Static/Picture/img_avatar3.png'),
      ),
      title: Text(
        conversation.name,
        style: TextStyle(color: TColor.primaryColor1, fontSize: 13),
      ),
      subtitle: conversation.messages[0] != null
          ? Text(
              conversation.messages[0]!.message ?? '',
              style: TextStyle(color: TColor.primaryColor1, fontSize: 9),
            )
          : const Text(''),
      trailing: conversation.messages[0] != null
          ? Text(
              Jiffy(conversation.messages[0]!.createdAt).fromNow(),
              style: TextStyle(color: TColor.primaryColor1, fontSize: 9),
            )
          : const Text(''),
    );
  }
}
