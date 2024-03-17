import 'package:flutter/material.dart';
import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class UnauthenticatedLayout extends StatefulWidget {
  final Widget child;
  const UnauthenticatedLayout({super.key, required this.child});

  @override
  State<UnauthenticatedLayout> createState() => _UnauthenticatedLayoutState();
}

class _UnauthenticatedLayoutState extends State<UnauthenticatedLayout> {
  @override
  void initState() {
    super.initState();

    // Access the authentication provider
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    // Check if the user is already logged in
    if (authProvider.isLoggedIn) {
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
