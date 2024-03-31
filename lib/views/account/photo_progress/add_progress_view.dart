import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fyp_flutter/common/color_extension.dart';
import 'package:fyp_flutter/common_widget/outlined_textfield.dart';
import 'package:fyp_flutter/common_widget/round_button.dart';
import 'package:fyp_flutter/models/exercise_for_customizaition.dart';
import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:fyp_flutter/services/account/customize_workout_service.dart';
import 'package:fyp_flutter/services/account/progress_service.dart';
import 'package:fyp_flutter/views/account/photo_progress/photo_progress_view.dart';
import 'package:fyp_flutter/views/account/workout_tracker/customized_workout_view.dart';
import 'package:fyp_flutter/views/layouts/authenticated_user_layout.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProgressForm extends StatefulWidget {
  const ProgressForm({super.key});

  @override
  State<ProgressForm> createState() => _ProgressFormState();
}

class _ProgressFormState extends State<ProgressForm> {
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  late AuthProvider authProvider;
  File? frontImage;
  File? backImage;
  File? rightImage;
  File? leftImage;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Access the authentication provider
    authProvider = Provider.of<AuthProvider>(context, listen: false);
  }

  void handleImageUpload(String type) async {
    setState(() {
      isLoading = true;
    });
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (type == 'front') {
          frontImage = File(pickedFile.path);
        } else if (type == 'back') {
          backImage = File(pickedFile.path);
        } else if (type == 'right') {
          rightImage = File(pickedFile.path);
        } else {
          leftImage = File(pickedFile.path);
        }
        isLoading = false;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  void save(body) async {
    setState(() {
      isLoading = true;
    });
    var result = await ProgressService(authProvider).saveProgress(
        body: body,
        frontImage: frontImage,
        backImage: backImage,
        rightImage: rightImage,
        leftImage: leftImage);
    if (result) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PhotoProgressView(),
        ),
      );
    } else {}
  }

  @override
  Widget build(BuildContext context) {
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
        : AuthenticatedLayout(
            child: Scaffold(
              appBar: AppBar(
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
                title: Text(
                  "Create Workout",
                  style: TextStyle(
                      color: TColor.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    OutlinedTextField(
                      controller: weightController,
                      icon: const Icon(Icons.play_for_work_outlined),
                      hitText: 'Weight',
                    ),
                    SizedBox(
                      height: media.width * 0.04,
                    ),
                    OutlinedTextField(
                      controller: heightController,
                      icon: const Icon(Icons.play_for_work_outlined),
                      hitText: 'Height',
                    ),
                    SizedBox(
                      height: media.width * 0.04,
                    ),
                    InkWell(
                      onTap: () => handleImageUpload('front'),
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
                                frontImage != null
                                    ? frontImage!.path.split('/').last
                                    : 'Upload Front Image',
                                style: TextStyle(color: TColor.gray),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (frontImage != null)
                              Flexible(
                                child: Image.file(
                                  frontImage!,
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
                    InkWell(
                      onTap: () => handleImageUpload('back'),
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
                                backImage != null
                                    ? backImage!.path.split('/').last
                                    : 'Upload Back Image',
                                style: TextStyle(color: TColor.gray),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (backImage != null)
                              Flexible(
                                child: Image.file(
                                  backImage!,
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
                    InkWell(
                      onTap: () => handleImageUpload('right'),
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
                                rightImage != null
                                    ? rightImage!.path.split('/').last
                                    : 'Upload Right Image',
                                style: TextStyle(color: TColor.gray),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (rightImage != null)
                              Flexible(
                                child: Image.file(
                                  rightImage!,
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
                    InkWell(
                      onTap: () => handleImageUpload('left'),
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
                                leftImage != null
                                    ? leftImage!.path.split('/').last
                                    : 'Upload Left Image',
                                style: TextStyle(color: TColor.gray),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (leftImage != null)
                              Flexible(
                                child: Image.file(
                                  leftImage!,
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
                    RoundButton(
                      onPressed: () {
                        var body = {
                          'weight': weightController.text.trim(),
                          'height': heightController.text.trim(),
                        };
                        save(body);
                      },
                      title: 'Save',
                    ),
                    SizedBox(
                      height: media.width * 0.01,
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
