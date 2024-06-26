import 'package:fyp_flutter/common/color_extension.dart';
import 'package:fyp_flutter/common_widget/round_button.dart';
import 'package:fyp_flutter/common_widget/round_textfield.dart';
import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:fyp_flutter/views/account/login/forgot_password_view.dart';
import 'package:fyp_flutter/views/layouts/unauthenticated_layout.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController phoneNumberController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  bool obscurePassword = true;

  bool isLoading = false;
  @override
  void initState() {
    super.initState();

    // Access the authentication provider
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    // Check if the user is already logged in
    if (authProvider.isLoggedIn) {
      // Navigate to DieticianProfilePage and replace the current route
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context,
            '/'); // Replace '/dietician-profile' with the route of DieticianProfilePage
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    handleSignIn() async {
      setState(() {
        isLoading = true;
      });
      try {
        if (await authProvider.login(
          phoneNumber: phoneNumberController.text,
          password: passwordController.text,
        )) {
          Navigator.pushNamed(context, '/');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                'Problems in logging in',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: TColor.primaryColor1,
            content: Text(
              e.toString(),
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
      setState(() {
        isLoading = false;
      });
    }

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
        : UnauthenticatedLayout(
            child: Scaffold(
              appBar: AppBar(
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [TColor.primaryColor2, TColor.primaryColor1],
                    ),
                  ),
                ),
                backgroundColor: TColor.white,
                centerTitle: true,
                elevation: 0,
                leading: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: TColor.lightGray,
                        borderRadius: BorderRadius.circular(10)),
                    child: Image.asset(
                      "assets/img/black_btn.png",
                      width: 15,
                      height: 15,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Hey There,",
                      style: TextStyle(color: TColor.gray, fontSize: 16),
                    ),
                    Text(
                      "Welcome Back",
                      style: TextStyle(
                        color: TColor.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              backgroundColor: TColor.white,
              body: SingleChildScrollView(
                child: SafeArea(
                  child: Container(
                    height: media.height * 0.8,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: media.width * 0.05,
                        ),
                        SizedBox(
                          height: media.width * 0.04,
                        ),
                        RoundTextField(
                          hitText: "Phone Number",
                          controller: phoneNumberController,
                          icon: const Icon(Icons.phone),
                        ),
                        SizedBox(
                          height: media.width * 0.04,
                        ),
                        RoundTextField(
                          hitText: "Password",
                          controller: passwordController,
                          icon: const Icon(Icons.lock),
                          obscureText: obscurePassword,
                          rigtIcon: TextButton(
                              onPressed: () {
                                setState(() {
                                  obscurePassword = !obscurePassword;
                                });
                              },
                              child: Container(
                                  alignment: Alignment.center,
                                  width: 20,
                                  height: 20,
                                  child: Image.asset(
                                    "assets/img/show_password.png",
                                    width: 20,
                                    height: 20,
                                    fit: BoxFit.contain,
                                    color: TColor.gray,
                                  ))),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ForgotPasswordView(),
                                  ),
                                );
                              },
                              child: Text(
                                "Forgot your password?",
                                style: TextStyle(
                                    color: TColor.gray,
                                    fontSize: 10,
                                    decoration: TextDecoration.none),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        RoundButton(
                          title: "Login",
                          onPressed: () => handleSignIn(),
                        ),
                        SizedBox(
                          height: media.width * 0.04,
                        ),
                        Row(
                          // crossAxisAlignment: CrossAxisAlignment.,
                          children: [
                            Expanded(
                                child: Container(
                              height: 1,
                              color: TColor.gray.withOpacity(0.5),
                            )),
                            Text(
                              "  Or  ",
                              style:
                                  TextStyle(color: TColor.black, fontSize: 12),
                            ),
                            Expanded(
                                child: Container(
                              height: 1,
                              color: TColor.gray.withOpacity(0.5),
                            )),
                          ],
                        ),
                        SizedBox(
                          height: media.width * 0.04,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Don’t have an account yet? ",
                                style: TextStyle(
                                  color: TColor.black,
                                  fontSize: 14,
                                ),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/register');
                                  },
                                  child: Text(
                                    "Register",
                                    style: TextStyle(
                                        color: TColor.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700),
                                  ))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: media.width * 0.04,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
