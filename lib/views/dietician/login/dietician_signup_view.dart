import 'dart:io';

import 'package:fyp_flutter/common/color_extension.dart';
import 'package:fyp_flutter/common_widget/round_button.dart';
import 'package:fyp_flutter/common_widget/round_textfield.dart';
import 'package:fyp_flutter/providers/dietician_auth_provider.dart';
import 'package:fyp_flutter/views/dietician/login/dietician_login_view.dart';
import 'package:flutter/material.dart';
import 'package:fyp_flutter/views/widget/pdf_view_from_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

class DieticianSignUpView extends StatefulWidget {
  const DieticianSignUpView({super.key});

  @override
  State<DieticianSignUpView> createState() => _DieticianSignUpViewState();
}

class _DieticianSignUpViewState extends State<DieticianSignUpView> {
  TextEditingController firstNameController = TextEditingController(text: '');
  TextEditingController lastNameController = TextEditingController(text: '');
  TextEditingController emailController = TextEditingController(text: '');
  TextEditingController phoneNumberController = TextEditingController(text: '');
  TextEditingController descriptionController = TextEditingController(text: '');
  TextEditingController specialityController = TextEditingController(text: '');

  TextEditingController esewaIdController = TextEditingController(text: '');

  TextEditingController bookingAmountController =
      TextEditingController(text: '');
  TextEditingController bioController = TextEditingController(text: '');
  TextEditingController passwordController = TextEditingController(text: '');
  TextEditingController confirmPasswordController =
      TextEditingController(text: '');
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  bool isLoading = false;
  bool isCheck = false;
  File? cvFile;
  File? imageFile;

  void handleCVUpload() async {
    setState(() {
      isLoading = true;
    });
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      setState(() {
        cvFile = file;
        isLoading = false;
      });
    }
    setState(() {
      isLoading = false;
    });
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
  void initState() {
    super.initState();

    // Access the authentication provider
    DieticianAuthProvider authProvider =
        Provider.of<DieticianAuthProvider>(context, listen: false);

    // Check if the user is already logged in
    if (authProvider.isLoggedIn) {
      // Navigate to DieticianProfilePage and replace the current route
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context,
            '/dietician-profile'); // Replace '/dietician-profile' with the route of DieticianProfilePage
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    DieticianAuthProvider authProvider =
        Provider.of<DieticianAuthProvider>(context);

    void handleRegister() async {
      setState(() {
        isLoading = true;
      });

      if (isCheck) {
        if (await authProvider.register(
            firstName: firstNameController.text.trim(),
            email: emailController.text.trim(),
            phoneNumber: phoneNumberController.text.trim(),
            lastName: lastNameController.text.trim(),
            description: descriptionController.text.trim(),
            esewaId: esewaIdController.text.trim(),
            bookingAmount: bookingAmountController.text.trim(),
            bio: bioController.text.trim(),
            cv: cvFile,
            image: imageFile,
            speciality: specialityController.text.trim(),
            password: passwordController.text.trim(),
            passwordConfirmation: confirmPasswordController.text.trim())) {
          Navigator.pushNamed(context, '/login-dietician');
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
              'Please accept the terms and conditions first',
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
        : Scaffold(
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
                    "Hey Dietician,",
                    style: TextStyle(color: TColor.gray, fontSize: 16),
                  ),
                  Text(
                    "Please Sign up",
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: media.width * 0.05,
                      ),
                      RoundTextField(
                          hitText: 'First Name',
                          controller: firstNameController,
                          icon: const Icon(Icons.person)),
                      SizedBox(
                        height: media.width * 0.05,
                      ),
                      RoundTextField(
                        hitText: 'Last Name',
                        controller: lastNameController,
                        icon: const Icon(Icons.person),
                      ),
                      SizedBox(
                        height: media.width * 0.04,
                      ),
                      RoundTextField(
                        hitText: 'Email',
                        controller: emailController,
                        icon: const Icon(Icons.email),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(
                        height: media.width * 0.04,
                      ),
                      RoundTextField(
                        hitText: 'Phone Number',
                        controller: phoneNumberController,
                        icon: const Icon(Icons.phone),
                      ),
                      SizedBox(
                        height: media.width * 0.04,
                      ),
                      RoundTextField(
                        hitText: 'Esewa ID',
                        controller: esewaIdController,
                        icon: const Icon(Icons.credit_card),
                      ),
                      SizedBox(
                        height: media.width * 0.04,
                      ),
                      RoundTextField(
                        hitText: 'Booking Amount',
                        controller: bookingAmountController,
                        icon: const Icon(Icons.attach_money),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(
                        height: media.width * 0.04,
                      ),
                      RoundTextField(
                        hitText: 'Bio',
                        controller: bioController,
                        icon: const Icon(Icons.info_outline),
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                      ),
                      SizedBox(
                        height: media.width * 0.04,
                      ),
                      InkWell(
                        onTap: () => handleCVUpload(),
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
                                  cvFile != null
                                      ? cvFile!.path.split('/').last
                                      : 'Upload CV',
                                  style: TextStyle(color: TColor.gray),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Spacer(),
                              if (cvFile != null)
                                Flexible(
                                  child: InkWell(
                                    onTap: () {
                                      // Open the selected PDF file
                                      // You can use a PDF viewer package or a web view to display the PDF
                                      // Here, I'm assuming you have a PDF viewer widget named PDFViewer
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PDFViewFromStoragePage(
                                                  title: cvFile!.path),
                                        ),
                                      );
                                    },
                                    child: Icon(
                                      Icons.picture_as_pdf_rounded,
                                      color: TColor.gray,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
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
                        height: media.width * 0.05,
                      ),
                      RoundTextField(
                        hitText: 'Speciality',
                        controller: specialityController,
                        maxLines: 6,
                        icon: const Icon(Icons.folder_special),
                      ),
                      SizedBox(
                        height: media.width * 0.04,
                      ),
                      RoundTextField(
                        hitText: 'Description',
                        controller: descriptionController,
                        maxLines: 6,
                        icon: const Icon(Icons.description),
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
                      Row(
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
                            child: Text(
                              "By continuing you accept our Privacy Policy and\nTerm of Use",
                              style:
                                  TextStyle(color: TColor.gray, fontSize: 10),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: media.width * 0.1,
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
                                  builder: (context) =>
                                      const DieticianLoginView()));
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
          );
  }
}
