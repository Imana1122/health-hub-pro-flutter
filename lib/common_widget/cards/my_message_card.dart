import 'package:fyp_flutter/common/color_extension.dart';
import 'package:fyp_flutter/models/message_model.dart';
import 'package:flutter/material.dart' hide Badge;

class MyMessageCard extends StatelessWidget {
  final MessageModal message;
  const MyMessageCard({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.all(21),
              decoration: BoxDecoration(
                  color: TColor.gray,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(21),
                    topRight: Radius.circular(21),
                    bottomLeft: Radius.circular(21),
                  )),
              child: Text("${message.body}"),
            ),
          ),
        ],
      ),
    );
  }
}
