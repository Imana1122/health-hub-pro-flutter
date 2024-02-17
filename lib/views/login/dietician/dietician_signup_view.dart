import 'dart:io';

import 'package:fyp_flutter/common/color_extension.dart';
import 'package:fyp_flutter/common_widget/round_button.dart';
import 'package:fyp_flutter/providers/dietician_auth_provider.dart';
import 'package:fyp_flutter/views/login/dietician/dietician_login_view.dart';
import 'package:flutter/material.dart';
import 'package:fyp_flutter/views/widget/pdf_view.dart';
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
  TextEditingController specialityController = TextEditingController(text: '');
  TextEditingController descriptionController = TextEditingController(text: '');
  TextEditingController esewaIdController = TextEditingController(text: '');
  TextEditingController bookingAmountController =
      TextEditingController(text: '');
  TextEditingController bioController = TextEditingController(text: '');

  bool isLoading = false;
  bool isCheck = false;
  File? cvFile;
  File? imageFile;

  void handleCVUpload() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      setState(() {
        cvFile = file;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFViewerScreen(filePath: file.path),
        ),
      );
    }
  }

  void handleImageUpload() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
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
      WidgetsBinding.instance!.addPostFrameCallback((_) {
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
        )) {
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
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                TColor.primaryColor2,
                TColor.primaryColor1,
              ],
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Hello Dietician,",
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
                  height: media.width * 0.05,
                ),
                TextFormField(
                  controller: firstNameController,
                  decoration: _getInputDecoration('First Name', Icons.person),
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                TextFormField(
                  controller: lastNameController,
                  decoration: _getInputDecoration('Last Name', Icons.person),
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                TextFormField(
                  controller: emailController,
                  decoration: _getInputDecoration('Email', Icons.email),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                TextFormField(
                  controller: phoneNumberController,
                  decoration: _getInputDecoration('Phone Number', Icons.phone),
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                TextFormField(
                  controller: specialityController,
                  decoration: _getInputDecoration('Speciality', Icons.category),
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration:
                      _getInputDecoration('Description', Icons.description),
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                TextFormField(
                  controller: esewaIdController,
                  decoration:
                      _getInputDecoration('Esewa ID', Icons.credit_card),
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                TextFormField(
                  controller: bookingAmountController,
                  decoration:
                      _getInputDecoration('Booking Amount', Icons.attach_money),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                TextFormField(
                  controller: bioController,
                  decoration: _getInputDecoration('Bio', Icons.info_outline),
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
                                        PDFViewerScreen(filePath: cvFile!.path),
                                  ),
                                );
                              },
                              child: Icon(
                                Icons.visibility,
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
                        style: TextStyle(color: TColor.gray, fontSize: 10),
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
                            builder: (context) => const DieticianLoginView()));
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

  InputDecoration _getInputDecoration(String label, IconData icon) {
    return InputDecoration(
        labelText: label,
        hintText: 'Enter $label',
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: TColor.gray.withOpacity(0.1),
        border: InputBorder.none,
        labelStyle: TextStyle(color: TColor.gray), // Color of the label text
        hintStyle: TextStyle(color: TColor.gray), // Color of the hint text
        prefixIconColor: TColor.gray);
  }
}
