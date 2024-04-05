import 'package:fyp_flutter/models/notification.dart';
import 'package:intl/intl.dart';

import '../common/color_extension.dart';
import 'package:flutter/material.dart';

class NotificationRow extends StatelessWidget {
  final NotificationModel nObj;
  const NotificationRow({super.key, required this.nObj});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          nObj.image != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.network(
                    nObj.image.toString(),
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                )
              : const SizedBox(),
          const SizedBox(
            width: 15,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nObj.message.toString(),
                style: TextStyle(
                    color: TColor.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 12),
              ),
              Text(
                DateFormat('dd-MMM-yyyy HH:mm').format(nObj.scheduledAt!),
                style: TextStyle(
                  color: TColor.gray,
                  fontSize: 10,
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }
}
