import 'package:flutter/material.dart';
import 'package:fyp_flutter/providers/dietician_auth_provider.dart';
import 'package:provider/provider.dart';

class AuthenticatedDieticianLayout extends StatefulWidget {
  final Widget child;
  const AuthenticatedDieticianLayout({super.key, required this.child});

  @override
  State<AuthenticatedDieticianLayout> createState() =>
      _AuthenticatedLayoutState();
}

class _AuthenticatedLayoutState extends State<AuthenticatedDieticianLayout> {
  @override
  void initState() {
    super.initState();

    // Access the authentication provider
    DieticianAuthProvider authProvider =
        Provider.of<DieticianAuthProvider>(context, listen: false);

    // Check if the user is already logged in
    if (!authProvider.isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: widget.child);
  }
}
