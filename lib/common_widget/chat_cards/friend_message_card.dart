import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp_flutter/common/color_extension.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:fyp_flutter/common_widget/dietician_chat_cards/dietician_my_message_card.dart';
import 'package:fyp_flutter/models/chat_message.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FriendMessageCard extends StatelessWidget {
  final ChatMessage message;
  final String image;

  const FriendMessageCard({
    super.key,
    required this.message,
    required this.image,
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
          Fluttertoast.showToast(
            msg: "Downloaded Successfully!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: TColor.secondaryColor1,
            textColor: Colors.white,
            fontSize: 16.0,
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
              margin: const EdgeInsets.only(right: 20),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    TColor.primaryColor1,
                    TColor.primaryColor2,
                    TColor.primaryColor1,
                    TColor.primaryColor2,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
              ),
              child: Row(
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
                                      '${dotenv.env['BASE_URL']}/storage/uploads/chats/files/${message.file!}');
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
                    children: [
                      Text(
                        Jiffy(message.createdAt).fromNow(),
                        style: TextStyle(
                            color: message.read == 0
                                ? TColor.secondaryColor1
                                : TColor.black,
                            fontSize: 9),
                      ),
                      Text(
                        DateFormat('h:mm a').format(
                            DateTime.parse(message.createdAt).toLocal()),
                        style: TextStyle(
                          color: message.read == 0
                              ? TColor.secondaryColor1
                              : TColor.black,
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
