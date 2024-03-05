import 'package:fyp_flutter/common/color_extension.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:fyp_flutter/models/chat_message.dart';

class FriendMessageCard extends StatelessWidget {
  final ChatMessage message;
  final String image;
  const FriendMessageCard({
    super.key,
    required this.message,
    required this.image,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          CircleAvatar(
            backgroundImage: NetworkImage(image != ''
                ? 'http://10.0.2.2:8000/uploads/dietician/profile/$image'
                : 'http://w3schools.fzxgj.top/Static/Picture/img_avatar3.png'),
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(21),
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    TColor.primaryColor1,
                    TColor.primaryColor2,
                    TColor.primaryColor1,
                    TColor.primaryColor2,
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(21),
                    topRight: Radius.circular(21),
                    bottomRight: Radius.circular(21),
                  )),
              child: Text(message.message ?? ''),
            ),
          )
        ],
      ),
    );
  }
}
