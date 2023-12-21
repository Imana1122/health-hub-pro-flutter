import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Login Page"),
            const SizedBox(
              height: 30,
            ),
            Container(
              width: double.infinity,
              child: const TextField(
                autocorrect: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder()
                )
              )
            )
          ]),
          ),
    );
  }
}