import 'package:fyp_flutter/common/color_extension.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:fyp_flutter/models/chat_message.dart';

class DieticianMyMessageCard extends StatelessWidget {
  final ChatMessage message;
  const DieticianMyMessageCard({
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
              padding: const EdgeInsets.all(21),
              decoration: BoxDecoration(
                  color: TColor.secondaryColor1,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(21),
                    topRight: Radius.circular(21),
                    bottomLeft: Radius.circular(21),
                  )),
              child: Text(message.message ?? ''),
            ),
          ),
        ],
      ),
    );
  }
}
