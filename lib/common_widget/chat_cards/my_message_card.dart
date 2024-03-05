import 'package:fyp_flutter/common/color_extension.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:fyp_flutter/models/chat_message.dart';

class MyMessageCard extends StatelessWidget {
  final ChatMessage message;
  const MyMessageCard({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(21),
              decoration: BoxDecoration(
                color: TColor.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(21),
                  topRight: Radius.circular(21),
                  bottomLeft: Radius.circular(21),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(message.message ?? ''),
                  const Spacer(),
                  if (message.read == 0) // Show one tick for unread messages
                    Icon(Icons.done, size: 20, color: TColor.gray),
                  if (message.read == 1) // Show two ticks for read messages
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.done_all,
                            size: 20, color: TColor.primaryColor1),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
