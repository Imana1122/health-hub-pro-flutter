import 'package:flutter/material.dart';
import 'package:fyp_flutter/common/color_extension.dart';
import 'package:intl/intl.dart';

class PaymentHistoryItem extends StatelessWidget {
  final Map payment;

  const PaymentHistoryItem({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        hoverColor: TColor.secondaryColor1,
        isThreeLine: true,
        tileColor: TColor.primaryColor2,
        contentPadding: const EdgeInsets.all(8.0),
        leading: ClipOval(
          child: Image.network(
            payment['dietician']['image'] != null
                ? 'http://10.0.2.2:8000/storage/uploads/dietician/profile/${payment['dietician']['image']}'
                : 'http://w3schools.fzxgj.top/Static/Picture/img_avatar3.png',
            width: 48,
            height: 48,
            fit: BoxFit.cover,
            errorBuilder: (BuildContext context, Object exception,
                StackTrace? stackTrace) {
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
          '${payment['dietician']['first_name']} ${payment['dietician']['last_name']}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Table(
          columnWidths: const {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(2),
          },
          children: [
            TableRow(
              children: [
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      'Amount:',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      '${payment['dietician']['booking_amount']}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      'Date:',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      DateFormat.yMMMMd().add_jm().format(
                            DateTime.parse(payment['updated_at']).toLocal(),
                          ),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: const Icon(
          Icons.payment,
          color: Colors.blue,
        ),
      ),
    );
  }
}
