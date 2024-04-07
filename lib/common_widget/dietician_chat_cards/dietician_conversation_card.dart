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
    final unreadMessagesCount = conversation.messages.where((message) {
      // Filter messages where senderId matches conversation id and message is unread
      return message.senderId == conversation.id && message.read == 0;
    }).length;

    final lastMessage =
        conversation.messages.isNotEmpty ? conversation.messages.last : null;

    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          conversation.image != ''
              ? 'http://10.0.2.2:8000/storage/uploads/users/${conversation.image}'
              : 'http://w3schools.fzxgj.top/Static/Picture/img_avatar3.png',
        ),
      ),
      title: Text(
        conversation.name,
        style: TextStyle(color: TColor.primaryColor1, fontSize: 13),
      ),
      subtitle: lastMessage != null
          ? Text(
              lastMessage.message ?? '',
              style: TextStyle(
                color: lastMessage.read == 0
                    ? TColor.secondaryColor1
                    : TColor.gray,
                fontSize: 9,
                fontWeight:
                    lastMessage.read == 0 ? FontWeight.bold : FontWeight.normal,
              ),
            )
          : const Text(''),
      trailing: lastMessage != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (unreadMessagesCount > 0)
                  CircleAvatar(
                    radius: 10,
                    backgroundColor:
                        TColor.secondaryColor2, // Customize as needed
                    child: Text(
                      '$unreadMessagesCount',
                      style: const TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ),
                const Spacer(),
                Text(
                  Jiffy(lastMessage.createdAt).fromNow(),
                  style: TextStyle(
                      color: lastMessage.read == 0
                          ? TColor.secondaryColor1
                          : TColor.gray,
                      fontSize: 9),
                ),
              ],
            )
          : const SizedBox(),
    );
  }
}
