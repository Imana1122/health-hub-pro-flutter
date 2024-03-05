import 'package:flutter/material.dart';
import 'package:fyp_flutter/providers/dietician_auth_provider.dart';
import 'package:fyp_flutter/views/account/login/login_view.dart';
import 'package:fyp_flutter/views/account/profile/profile_view.dart';
import 'package:provider/provider.dart';

class DieticianProfileEditView extends StatefulWidget {
  const DieticianProfileEditView({super.key});

  @override
  State<DieticianProfileEditView> createState() =>
      _DieticianProfileEditViewState();
}

class _DieticianProfileEditViewState extends State<DieticianProfileEditView> {
  late TextEditingController bioController;
  late TextEditingController emailController;
  late TextEditingController phoneNumberController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    DieticianAuthProvider authProvider =
        Provider.of<DieticianAuthProvider>(context, listen: false);
    authProvider = Provider.of<DieticianAuthProvider>(context, listen: false);
    if (!authProvider.isLoggedIn) {
      // If the dietician is not logged in, navigate to the login page
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>
                const LoginView(), // Replace LoginPage with your actual login page
          ),
        );
      });
    } else {
      bioController = TextEditingController(text: authProvider.dietician.bio);
      emailController =
          TextEditingController(text: authProvider.dietician.email);
      phoneNumberController =
          TextEditingController(text: authProvider.dietician.phoneNumber);
    }
  }

  Future<void> _saveProfile() async {
    setState(() {
      isLoading = true;
    });
    DieticianAuthProvider authProvider =
        Provider.of<DieticianAuthProvider>(context, listen: false);
    bool success = await authProvider.updatePersonalInfo(
      bio: bioController.text,
      phoneNumber: phoneNumberController.text,
      email: emailController.text,
    );

    if (success) {
      // Handle success, you can navigate back or show a success message
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ProfileView(),
        ),
      );
    } else {
      // Handle failure, show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Failed to update profile'),
        ),
      );
    }
    setState(() {
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
              title: const Text('Edit Profile'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: bioController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: phoneNumberController,
                    decoration:
                        const InputDecoration(labelText: 'Phone Number'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _saveProfile,
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
          );
  }
}
