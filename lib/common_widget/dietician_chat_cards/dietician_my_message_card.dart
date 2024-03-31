import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fyp_flutter/common/color_extension.dart';
import 'package:fyp_flutter/models/chat_message.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DieticianMyMessageCard extends StatelessWidget {
  final ChatMessage message;
  const DieticianMyMessageCard({
    super.key,
    required this.message,
  });
  Future<void> downloadFile(String fileUrl) async {
    final statuses = await [Permission.storage].request();
    if (statuses[Permission.storage]!.isGranted) {
      final downloadsDirectory = await getDownloadsDirectory();

      if (downloadsDirectory != null) {
        final fileExtension = fileUrl.split('.').last;

        var saveName =
            DateTime.now().toIso8601String(); // Change the filename as needed
        final savePath = '${downloadsDirectory.path}/$saveName$fileExtension';
        print(savePath);
        try {
          await Dio().download(
            fileUrl,
            savePath,
            onReceiveProgress: (received, total) {
              if (total != -1) {
                print('${(received / total * 100).toStringAsFixed(0)}%');
                // You can build a progress bar feature here
              }
            },
          );
          print('File is saved to the Downloads folder.');
        } on Error catch (e) {
          print(e);
        }
      }
    } else {
      print('No permission to read and write.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 20),
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: TColor.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Flexible(
                      child: message.message != null
                          ? Text(
                              message.message!,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 10,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.normal,
                                color: TColor.gray,
                              ),
                            )
                          : InkWell(
                              onTap: () {
                                // Check if the file is an image
                                if (message.file != null &&
                                        (message.file!.endsWith('.jpg') ||
                                            message.file!.endsWith('.png')) ||
                                    message.file!.endsWith('.jpeg') ||
                                    message.file!.endsWith('.gif')) {
                                  // Navigate to a new screen to display the image
                                  downloadFile(
                                      '${dotenv.env['BASE_URL']}/uploads/chats/files/${message.file!}');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ImageScreen(
                                        imageUrl: message.file!,
                                      ),
                                    ),
                                  );
                                } else {
                                  // Handle file download
                                }
                              },
                              child: Text(message.file!),
                            ),
                    ),
                  ),
                  const Spacer(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      message.read == 0
                          ? Icon(Icons.done, size: 20, color: TColor.gray)
                          : Icon(Icons.done_all,
                              size: 20, color: TColor.primaryColor1),
                      Text(
                        Jiffy(message.createdAt).fromNow(),
                        style: TextStyle(
                          color: message.read == 0
                              ? TColor.secondaryColor1
                              : TColor.gray,
                          fontSize: 9,
                        ),
                      ),
                      Text(
                        DateFormat('h:mm a').format(
                            DateTime.parse(message.createdAt).toLocal()),
                        style: TextStyle(
                          color: message.read == 0
                              ? TColor.secondaryColor1
                              : TColor.gray,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
            '${dotenv.env['BASE_URL']}/uploads/chats/files/$imageUrl'),
      ),
    );
  }
}
