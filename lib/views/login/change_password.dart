import 'package:flutter/material.dart';
import 'package:fyp_flutter/common_widget/round_button.dart';
import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:fyp_flutter/views/login/login_view.dart';
import 'package:provider/provider.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  late TextEditingController oldPasswordController;
  late TextEditingController newPasswordController;
  late TextEditingController confirmPasswordController;
  bool obscureOldPassword = true;
  bool obscureNewPassword = true;
  bool obscureConfirmPassword = true;
  late AuthProvider authProvider;
  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (!authProvider.isLoggedIn) {
      // If the user is not logged in, navigate to the login page
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>
                const LoginView(), // Replace LoginPage with your actual login page
          ),
        );
      });
    } else {
      oldPasswordController = TextEditingController();
      newPasswordController = TextEditingController();
      confirmPasswordController = TextEditingController();
    }
  }

  Future<void> _changePassword() async {
    bool success = await authProvider.changePassword(
      oldPassword: oldPasswordController.text,
      password: newPasswordController.text,
      passwordConfirmation: confirmPasswordController.text,
    );

    if (success) {
      // Handle success, you can navigate back or show a success message
      Navigator.pop(context);
    } else {
      // Handle failure, show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Failed to change password'),
        ),
      );
    }
  }

  Widget buildPasswordTextField(
    TextEditingController controller,
    String labelText,
    bool obscureText,
    Function(bool) onTap,
  ) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              onTap(!obscureText);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            buildPasswordTextField(
              oldPasswordController,
              'Old Password',
              obscureOldPassword,
              (value) => obscureOldPassword = value,
            ),
            const SizedBox(height: 16),
            buildPasswordTextField(
              newPasswordController,
              'New Password',
              obscureNewPassword,
              (value) => obscureNewPassword = value,
            ),
            const SizedBox(height: 16),
            buildPasswordTextField(
              confirmPasswordController,
              'Confirm Password',
              obscureConfirmPassword,
              (value) => obscureConfirmPassword = value,
            ),
            const SizedBox(height: 16),
            RoundButton(onPressed: _changePassword, title: "ChangePassword"),
          ],
        ),
      ),
    );
  }
}
