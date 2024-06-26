import 'dart:io';

import 'package:fyp_flutter/common/color_extension.dart';
import 'package:fyp_flutter/common_widget/round_button.dart';
import 'package:fyp_flutter/common_widget/round_textfield.dart';
import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:fyp_flutter/views/account/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:fyp_flutter/views/layouts/unauthenticated_layout.dart';
import 'package:fyp_flutter/views/others/terms_and_conditions_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  TextEditingController nameController = TextEditingController(text: '');
  TextEditingController emailController = TextEditingController(text: '');

  TextEditingController phoneNumberController = TextEditingController(text: '');

  TextEditingController passwordController = TextEditingController(text: '');
  TextEditingController confirmPasswordController =
      TextEditingController(text: '');
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  File? imageFile;

  bool isLoading = false;
  bool isCheck = false;
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
        Navigator.pushReplacementNamed(context, '/');
      });
    }
  }

  void handleImageUpload() async {
    setState(() {
      isLoading = true;
    });
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        isLoading = false;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    handleRegister() async {
      setState(() {
        isLoading = true;
      });
      if (isCheck) {
        if (imageFile != null) {
          if (await authProvider.register(
              image: imageFile!,
              name: nameController.text.trim(),
              email: emailController.text.trim(),
              phoneNumber: phoneNumberController.text.trim(),
              password: passwordController.text.trim(),
              passwordConfirmation: confirmPasswordController.text.trim())) {
            Navigator.pushNamed(context, '/complete-profile');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.red,
                content: Text(
                  'Problems in registering.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                'Profile image is not uploaded.',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'Problems in registering.',
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
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Hey There,",
                      style: TextStyle(color: TColor.gray, fontSize: 16),
                    ),
                    Text(
                      "Create an Account",
                      style: TextStyle(
                        color: TColor.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                centerTitle: true, // Center the title horizontally
                elevation: 4, // Add some elevation to the app bar
              ),
              backgroundColor: TColor.white,
              body: SingleChildScrollView(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: media.width * 0.09,
                        ),
                        RoundTextField(
                          hitText: "Full Name",
                          controller: nameController,
                          icon: const Icon(Icons.person),
                          keyboardType: TextInputType.name,
                        ),
                        SizedBox(
                          height: media.width * 0.04,
                        ),
                        RoundTextField(
                          hitText: "Email",
                          controller: emailController,
                          icon: const Icon(Icons.email),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(
                          height: media.width * 0.04,
                        ),
                        RoundTextField(
                          hitText: "Phone Number",
                          controller: phoneNumberController,
                          keyboardType: TextInputType.phone,
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
                          keyboardType: TextInputType.visiblePassword,
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
                        SizedBox(
                          height: media.width * 0.05,
                        ),
                        RoundTextField(
                          hitText: "Password Confirmation",
                          controller: confirmPasswordController,
                          keyboardType: TextInputType.visiblePassword,
                          icon: const Icon(Icons.lock),
                          obscureText: obscureConfirmPassword,
                          rigtIcon: TextButton(
                              onPressed: () {
                                setState(() {
                                  obscureConfirmPassword =
                                      !obscureConfirmPassword;
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
                        SizedBox(
                          height: media.width * 0.04,
                        ),
                        InkWell(
                          onTap: () => handleImageUpload(),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: TColor.gray.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.attach_file,
                                  color: TColor.gray,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    imageFile != null
                                        ? imageFile!.path.split('/').last
                                        : 'Upload Profile Image',
                                    style: TextStyle(color: TColor.gray),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (imageFile != null)
                                  Flexible(
                                    child: Image.file(
                                      imageFile!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: media.width * 0.04,
                        ),
                        Row(
                          // crossAxisAlignment: CrossAxisAlignment.,
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  isCheck = !isCheck;
                                });
                              },
                              icon: Icon(
                                isCheck
                                    ? Icons.check_box_outlined
                                    : Icons.check_box_outline_blank_outlined,
                                color: TColor.gray,
                                size: 20,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const TermsAndConditionsView()),
                                  );
                                },
                                child: Text(
                                  "By continuing you accept our Privacy Policy and\nTerm of Use",
                                  style: TextStyle(
                                      color: TColor.secondaryColor1,
                                      fontSize: 10),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: media.width * 0.4,
                        ),
                        RoundButton(
                          title: "Register",
                          onPressed: () => handleRegister(),
                        ),
                        SizedBox(
                          height: media.width * 0.04,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginView()));
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Already have an account? ",
                                style: TextStyle(
                                  color: TColor.black,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                "Login",
                                style: TextStyle(
                                    color: TColor.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700),
                              )
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
