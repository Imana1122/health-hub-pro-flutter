import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fyp_flutter/common/color_extension.dart';

class ImageScreen extends StatelessWidget {
  final String imageUrl;

  const ImageScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.primaryColor1,
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
      ),
      body: Center(
        child: Image.network(
          '${dotenv.env['BASE_URL']}/storage/uploads/chats/files/$imageUrl',
          errorBuilder:
              (BuildContext context, Object exception, StackTrace? stackTrace) {
            // This function is called when the image fails to load
            // You can return a fallback image here
            return Image.asset(
              'assets/img/non.png', // Path to your placeholder image asset
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            );
          },
        ),
      ),
    );
  }
}
