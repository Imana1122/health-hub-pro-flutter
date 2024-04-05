import 'dart:io';

import 'package:fyp_flutter/common/color_extension.dart';
import 'package:fyp_flutter/common_widget/round_button.dart';
import 'package:fyp_flutter/providers/dietician_auth_provider.dart';
import 'package:fyp_flutter/services/dietician/dietician_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:fyp_flutter/views/dietician/layout.dart';
import 'package:fyp_flutter/views/layouts/authenticated_dietician_layout.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UpdateProfileImage extends StatefulWidget {
  const UpdateProfileImage({super.key});

  @override
  State<UpdateProfileImage> createState() => _UpdateProfileImageState();
}

class _UpdateProfileImageState extends State<UpdateProfileImage> {
  File? imageFile;

  bool isLoading = false;
  bool isCheck = false;
  @override
  void initState() {
    super.initState();
  }

  void handleImageUpload() async {
    setState(() {
      isLoading = true;
    });
    final picker = ImagePicker();

    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          imageFile = File(pickedFile.path);
          isLoading = false;
        });
      }
    } catch (e) {
      final LostDataResponse response = await picker.retrieveLostData();
      final List<XFile>? files = response.files;
      if (files != null) {
        final pickedFile = files[0];

        setState(() {
          imageFile = File(pickedFile.path);
          isLoading = false;
        });
      }

      print('ImagePicker:: - $e');
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    DieticianAuthProvider authProvider =
        Provider.of<DieticianAuthProvider>(context);

    handleSubmit() async {
      setState(() {
        isLoading = true;
      });

      if (imageFile != null) {
        var result = await DieticianAuthService().updateProfileImage(
            image: imageFile!, token: authProvider.getAuthenticatedToken());

        if (result != null && result is Map) {
          authProvider.getAuthenticatedDietician().image = result['image'];
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DieticianCommonLayout(),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                'Problems in updating image.',
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
        : AuthenticatedDieticianLayout(
            child: Scaffold(
              appBar: AppBar(
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [TColor.primaryColor2, TColor.primaryColor1],
                    ),
                  ),
                ),
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
                      "Update Profile Image",
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
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
                        RoundButton(
                          title: "Save",
                          onPressed: () => handleSubmit(),
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
