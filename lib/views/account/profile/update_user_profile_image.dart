import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fyp_flutter/common/color_extension.dart';
import 'package:fyp_flutter/common_widget/round_button.dart';
import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:fyp_flutter/services/account/auth_service.dart';
import 'package:fyp_flutter/views/account/home/home_view.dart';
import 'package:fyp_flutter/views/account/main_tab/main_tab_view.dart';
import 'package:fyp_flutter/views/account/profile/profile_view.dart';
import 'package:fyp_flutter/views/dietician/profile/dietician_profile_view.dart';
import 'package:fyp_flutter/views/layouts/authenticated_user_layout.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UpdateUserProfileImage extends StatefulWidget {
  const UpdateUserProfileImage({super.key});

  @override
  State<UpdateUserProfileImage> createState() => _UpdateUserProfileImageState();
}

class _UpdateUserProfileImageState extends State<UpdateUserProfileImage> {
  File? imageFile;
  bool isLoading = false;

  void handleImageUpload() async {
    final picker = ImagePicker();
    setState(() {
      isLoading = true;
    });
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      isLoading = false;
    });
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    Future<void> handleSubmit() async {
      setState(() {
        isLoading = true;
      });

      if (imageFile != null) {
        var result = await AuthService().updateProfileImage(
            image: imageFile!, token: authProvider.getAuthenticatedToken());
        if (result != null && result is Map) {
          authProvider.getAuthenticatedUser().image = result['image'];
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MainTabView(),
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
              'Please upload a profile image.',
              textAlign: TextAlign.center,
            ),
          ),
        );
      }

      setState(() {
        isLoading = false;
      });
    }

    return isLoading
        ? const Center(
            child: SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                strokeWidth: 4,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
          )
        : AuthenticatedLayout(
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
                      "Update User Profile Image",
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
