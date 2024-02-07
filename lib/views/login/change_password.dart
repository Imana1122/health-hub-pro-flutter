import 'package:flutter/material.dart';
import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

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

  @override
  void initState() {
    super.initState();
    oldPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  Future<void> _changePassword() async {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
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
            ElevatedButton(
              onPressed: _changePassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Change button color here
              ),
              child: const Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }
}
