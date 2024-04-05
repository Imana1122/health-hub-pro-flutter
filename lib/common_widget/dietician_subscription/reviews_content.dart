import 'package:flutter/material.dart';
import 'package:fyp_flutter/common_widget/dietician_subscription/star_rating.dart';
import 'package:fyp_flutter/services/account/dietician_booking_service.dart';
import 'package:fyp_flutter/views/account/dietician_subscription/subscription_details.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

class ReviewsContent extends StatefulWidget {
  final String id;
  final String avgRating;
  const ReviewsContent({super.key, required this.id, required this.avgRating});

  @override
  State<ReviewsContent> createState() => _ReviewsContentState();
}

class _ReviewsContentState extends State<ReviewsContent> {
  final TextEditingController _commentController = TextEditingController();
  double _rating = 0;
  List ratings = [];

  late AuthProvider authProvider;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);

    loadRatings();
  }

  void loadRatings() async {
    setState(() {
      isLoading = true;
    });
    var result =
        await DieticianBookingService(authProvider).getRatings(id: widget.id);
    setState(() {
      ratings = result['data'];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    saveRating(Object body) async {
      AuthProvider authProvider =
          Provider.of<AuthProvider>(context, listen: false);

      // Instantiate FrontService
      var frontService = DieticianBookingService(authProvider);

      // Call the saveRating method on the instance
      if (await frontService.saveRating(
          id: widget.id,
          body: body,
          token: authProvider.getAuthenticatedToken())) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SubscriptionDetails()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'Problems in submitting reviews.',
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Write a Review',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Rating',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: List.generate(5, (index) {
                    int starValue = index + 1;
                    return IconButton(
                      icon: Icon(
                        _rating >= starValue ? Icons.star : Icons.star_border,
                        color: Colors.yellow,
                      ),
                      onPressed: () {
                        setState(() {
                          _rating = starValue.toDouble();
                        });
                      },
                    );
                  }),
                ),
                const SizedBox(height: 20),
                const Text(
                  'How was your overall experience?',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: _commentController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: 'How was your overall experience?',
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Send form data to backend

                    var body = {
                      'rating': _rating.toString(),
                      'comment': _commentController.text,
                    };
                    saveRating(body);
                  },
                  child: const Text('Submit'),
                ),
                const SizedBox(height: 8),
                Card(
                  elevation: 4, // Set elevation for the card
                  margin: const EdgeInsets.all(8), // Set margin for the card
                  child: Padding(
                    padding:
                        const EdgeInsets.all(16), // Add padding inside the card
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Average Rating',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        StarRating(
                          rating: double.parse(widget.avgRating),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ratings.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: ratings.length,
                        itemBuilder: (context, index) {
                          var review = ratings[index];
                          return Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    review['user']['name'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  StarRating(
                                      rating: review['rating'].toDouble()),
                                  Text(review['comment']),
                                  const Divider(),
                                ],
                              ));
                        },
                      )
                    : const SizedBox(height: 10)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
