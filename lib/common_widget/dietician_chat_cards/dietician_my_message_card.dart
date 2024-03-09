import 'package:fyp_flutter/common/color_extension.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:fyp_flutter/models/chat_message.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 20),
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: TColor.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
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
                          color: TColor.gray, // Adjust the text color as needed
                          // Add more style properties as needed
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      message.read == 0
                          ? Icon(Icons.done, size: 20, color: TColor.gray)
                          : Icon(Icons.done_all,
                              size: 20, color: TColor.primaryColor1),
                      Text(
                        Jiffy(message.createdAt).fromNow(),
                        style: TextStyle(
                            color: message.read == 0
                                ? TColor.secondaryColor1
                                : TColor.gray,
                            fontSize: 9),
                      ),
                      Text(
                        DateFormat.Hm().format(
                            DateTime.parse(message.createdAt).toLocal()),
                        style: TextStyle(
                          color: message.read == 0
                              ? TColor.secondaryColor1
                              : TColor.gray,
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
