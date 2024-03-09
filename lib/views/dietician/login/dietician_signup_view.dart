import 'dart:io';

import 'package:fyp_flutter/common/color_extension.dart';
import 'package:fyp_flutter/common_widget/round_button.dart';
import 'package:fyp_flutter/common_widget/round_textfield.dart';
import 'package:fyp_flutter/providers/dietician_auth_provider.dart';
import 'package:fyp_flutter/views/dietician/login/dietician_login_view.dart';
import 'package:flutter/material.dart';
import 'package:fyp_flutter/views/widget/pdf_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_summernote/flutter_summernote.dart';

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
  TextEditingController passwordController = TextEditingController(text: '');

  TextEditingController esewaClientIdController =
      TextEditingController(text: '');
  TextEditingController esewaSecretKeyController =
      TextEditingController(text: '');

  TextEditingController bookingAmountController =
      TextEditingController(text: '');
  TextEditingController bioController = TextEditingController(text: '');
  final GlobalKey<FlutterSummernoteState> _descriptionEditor = GlobalKey();
  final GlobalKey<FlutterSummernoteState> _specialityEditor = GlobalKey();

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
        String description = '';
        String speciality = '';

        description = await _descriptionEditor.currentState!.getText();
        speciality = await _specialityEditor.currentState!.getText();

        print("Description :: $description");

        if (await authProvider.register(
          firstName: firstNameController.text.trim(),
          email: emailController.text.trim(),
          phoneNumber: phoneNumberController.text.trim(),
          lastName: lastNameController.text.trim(),
          description: description.trim(),
          esewaClientId: esewaClientIdController.text.trim(),
          esewaSecretKey: esewaSecretKeyController.text.trim(),
          bookingAmount: bookingAmountController.text.trim(),
          bio: bioController.text.trim(),
          cv: cvFile,
          image: imageFile,
          speciality: speciality,
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
                        hitText: 'Esewa Client ID',
                        controller: esewaClientIdController,
                        icon: const Icon(Icons.credit_card),
                      ),
                      SizedBox(
                        height: media.width * 0.04,
                      ),
                      RoundTextField(
                        hitText: 'Esewa Secret Key',
                        controller: esewaSecretKeyController,
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
                                          builder: (context) => PDFViewerScreen(
                                              filePath: cvFile!.path),
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
                      Container(
                        width: media.width,
                        height: 50,
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Color.fromARGB(255, 182, 208, 229),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Text('Speciality'),
                            Spacer(),
                            Icon(Icons.description),
                          ],
                        ),
                      ),
                      FlutterSummernote(
                        key: _specialityEditor,
                        height: media.height * 0.5,
                        hasAttachment: true,
                        showBottomToolbar: true,
                        customToolbar: """""
             [
                          ['style', ['bold', 'italic', 'underline', 'clear']],
                          ['font', ['strikethrough', 'superscript', 'subscript']],
                          ['fontsize', ['fontsize']],
                          ['color', ['color']],
                          ['para', ['ul', 'ol', 'paragraph']],
                          ['height', ['height']],
                          ['insert', ['link', 'picture', 'video']],
                          ['view', ['fullscreen', 'codeview', 'help']]
                        ]
            """
                            "",
                      ),
                      SizedBox(
                        height: media.width * 0.04,
                      ),
                      Container(
                        width: media.width,
                        height: 50,
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Color.fromARGB(255, 182, 208, 229),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Text("Description"),
                            Spacer(),
                            Icon(Icons.description),
                          ],
                        ),
                      ),
                      FlutterSummernote(
                        key: _descriptionEditor,
                        height: media.height * 0.5,
                        hasAttachment: true,
                        showBottomToolbar: true,
                        customToolbar: """""
             [
                          ['style', ['bold', 'italic', 'underline', 'clear']],
                          ['font', ['strikethrough', 'superscript', 'subscript']],
                          ['fontsize', ['fontsize']],
                          ['color', ['color']],
                          ['para', ['ul', 'ol', 'paragraph']],
                          ['height', ['height']],
                          ['insert', ['link', 'picture', 'video']],
                          ['view', ['fullscreen', 'codeview', 'help']]
                        ]
            """
                            "",
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

  InputDecoration _getInputDecoration(String label, IconData icon) {
    return InputDecoration(
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        hintText: label,
        border: const OutlineInputBorder(),
        labelText: label,
        prefixIcon: Container(
          width: 50, // Adjust width as needed
          height: 52,
          margin: const EdgeInsets.only(right: 3),
          decoration: const BoxDecoration(
            shape: BoxShape.rectangle, // Makes the container circular
            color: Color.fromARGB(
                255, 182, 208, 229), // Change the background color as desired
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5),
              bottomLeft: Radius.circular(5),
            ),
          ),
          child: Icon(icon),
        ),
        hintStyle: TextStyle(color: TColor.gray, fontSize: 12));
  }
}
