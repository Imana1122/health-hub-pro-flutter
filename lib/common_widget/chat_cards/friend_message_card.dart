import 'package:fyp_flutter/common/color_extension.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:fyp_flutter/models/chat_message.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 20),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    TColor.primaryColor1,
                    TColor.primaryColor2,
                    TColor.primaryColor1,
                    TColor.primaryColor2,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Flexible(
                      child: Text(
                        message.message ?? '',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 10, // Adjust maxLines as needed
                        style: TextStyle(
                          fontSize: 11, // Adjust the font size as needed
                          fontWeight: FontWeight
                              .normal, // Adjust the font weight as needed
                          color:
                              TColor.black, // Adjust the text color as needed
                          // Add more style properties as needed
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      Text(
                        Jiffy(message.createdAt).fromNow(),
                        style: TextStyle(
                            color: message.read == 0
                                ? TColor.secondaryColor1
                                : TColor.black,
                            fontSize: 9),
                      ),
                      Text(
                        DateFormat('h:mm a').format(
                            DateTime.parse(message.createdAt).toLocal()),
                        style: TextStyle(
                          color: message.read == 0
                              ? TColor.secondaryColor1
                              : TColor.black,
                          fontSize: 9,
                        ),
                      ),
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
