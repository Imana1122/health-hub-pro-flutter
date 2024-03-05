import 'package:flutter/material.dart';
import 'package:fyp_flutter/common_widget/round_button.dart';

class DieticianDetails extends StatelessWidget {
  final Map dietician;
  final VoidCallback onPressed;
  const DieticianDetails(
      {super.key, required this.dietician, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dietician Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(11.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(
                    'http://10.0.2.2:8000/uploads/dietician/profile/${dietician['image']}',
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${dietician['first_name']} ${dietician['last_name']}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${dietician['email']}',
                          style: const TextStyle(fontSize: 11),
                        ),
                        Text(
                          '${dietician['phone_number']}',
                          style: const TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Text(
              'Bio:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "${dietician['bio']}",
              style: const TextStyle(fontSize: 11),
            ),
            const SizedBox(height: 14),
            const Text(
              'Description:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "${dietician['description']}",
              style: const TextStyle(fontSize: 11),
            ),
            const SizedBox(height: 14),
            const Text(
              'Booking Amount:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "NRs. ${dietician['booking_amount']}",
              style: const TextStyle(fontSize: 11),
            ),
            const SizedBox(height: 20),
            RoundButton(title: 'Book', onPressed: onPressed)
          ],
        ),
      ),
    );
  }
}
