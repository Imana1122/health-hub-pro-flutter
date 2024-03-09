import 'package:fyp_flutter/common/color_extension.dart';
import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:fyp_flutter/services/account/dietician_booking_service.dart';
import 'package:fyp_flutter/views/account/dietician_booking/dietician_details.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class DieticianListView extends StatefulWidget {
  const DieticianListView({super.key});

  @override
  State<DieticianListView> createState() => _WorkoutTrackerViewState();
}

class _WorkoutTrackerViewState extends State<DieticianListView> {
  late AuthProvider authProvider;
  List dieticians = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    _loadDieticians();
  }

  Future<void> _bookDietician(String dieticianId) async {
    setState(() {
      isLoading = true;
    });
    try {
      print("dietician :  $dieticianId");
      await DieticianBookingService(authProvider)
          .bookDietician(dieticianId: dieticianId);

      await _loadDieticians();
    } catch (e) {
      // Handle any errors that occur during booking
      // For example, show a toast message with the error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Problems in connecting.',
            textAlign: TextAlign.center,
          ),
        ),
      );
      print("Error: $e");
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _loadDieticians() async {
    setState(() {
      isLoading = true;
    });
    var result = await DieticianBookingService(authProvider).getDieticians();
    setState(() {
      dieticians = result['data'];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return isLoading
        ? SizedBox(
            height: media.height, // Adjust height as needed
            width: media.width, // Adjust width as needed
            child: const Center(
              child: SizedBox(
                width: 50, // Adjust size of the CircularProgressIndicator
                height: 50, // Adjust size of the CircularProgressIndicator
                child: CircularProgressIndicator(
                  strokeWidth:
                      4, // Adjust thickness of the CircularProgressIndicator
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.blue), // Change color
                ),
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text('Dieticians'),
            ),
            body: dieticians.isEmpty
                ? const Center(
                    child: Text('No dieticians available'),
                  )
                : ListView.builder(
                    itemCount: dieticians.length,
                    itemBuilder: (context, index) {
                      final dietician = dieticians[index];
                      return GestureDetector(
                        onTap: () {
                          // Your onTap logic here
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DieticianDetails(
                                dietician: dietician,
                                onPressed: () {
                                  _bookDietician(dietician["id"]);
                                },
                              ),
                            ),
                          );
                        },
                        child: SizedBox(
                          child: Padding(
                            padding: const EdgeInsets.all(
                                8.0), // Adjust the padding as needed
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    12.0), // Rounded corners
                                gradient: LinearGradient(
                                  colors: [
                                    TColor.primaryColor1,
                                    TColor.primaryColor2
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(
                                    8.0), // Padding inside the container
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          'http://10.0.2.2:8000/uploads/dietician/profile/${dietician['image']}',
                                        ),
                                      ),
                                      title: Text(
                                        '${dietician['first_name']} ${dietician['last_name']}',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      subtitle: Text(
                                        dietician['description'],
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 9),
                                      ),
                                      trailing: ElevatedButton(
                                        onPressed: () {
                                          print(dietician);
                                          _bookDietician(dietician['id']);
                                        },
                                        child: const Text('Book'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          );
  }
}