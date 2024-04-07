import 'package:flutter/material.dart' hide Badge;
import 'package:fyp_flutter/common/color_extension.dart';
import 'package:fyp_flutter/models/dietician_chat_model.dart';
import 'package:jiffy/jiffy.dart';

class ConversationCard extends StatelessWidget {
  final DieticianChatModel conversation;
  final Function()? onTap;

  const ConversationCard({
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
      leading: ClipOval(
        child: Image.network(
          conversation.image.isNotEmpty
              ? 'http://10.0.2.2:8000/storage/uploads/dietician/profile/${conversation.image}'
              : 'http://w3schools.fzxgj.top/Static/Picture/img_avatar3.png',
          errorBuilder:
              (BuildContext context, Object exception, StackTrace? stackTrace) {
            // This function is called when the image fails to load
            // You can return a fallback image here
            return Image.asset(
              'assets/img/non.png', // Path to your placeholder image asset
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            );
          },
        ),
      ),
      title: Text(
        '${conversation.firstName} ${conversation.lastName}',
        style: TextStyle(
            color:
                unreadMessagesCount == 0 ? TColor.gray : TColor.secondaryColor1,
            fontSize: 13),
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
