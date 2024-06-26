import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp_flutter/common/color_extension.dart';
import 'package:fyp_flutter/models/chat_message.dart';
import 'package:fyp_flutter/views/widget/image_screen.dart';
import 'package:fyp_flutter/views/widget/pdf_view.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class MyMessageCard extends StatelessWidget {
  final ChatMessage message;
  const MyMessageCard({
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ImageScreen(
                                        imageUrl: message.file!,
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PDFViewPage(
                                        title:
                                            '${dotenv.env['BASE_URL']}/storage/uploads/chats/files/${message.file!}',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Column(
                                children: [
                                  message.file != null &&
                                              (message.file!.endsWith('.jpg') ||
                                                  message.file!
                                                      .endsWith('.png')) ||
                                          message.file!.endsWith('.jpeg') ||
                                          message.file!.endsWith('.gif')
                                      ? Image.network(
                                          '${dotenv.env['BASE_URL']}/storage/uploads/chats/files/${message.file!}',
                                          errorBuilder: (BuildContext context,
                                              Object exception,
                                              StackTrace? stackTrace) {
                                            // This function is called when the image fails to load
                                            // You can return a fallback image here
                                            return Image.asset(
                                              'assets/img/non.png', // Path to your placeholder image asset
                                              width: 40,
                                              height: 40,
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        )
                                      : Container(
                                          height: 50,
                                          alignment: Alignment.centerLeft,
                                          child: const Icon(
                                              Icons.picture_as_pdf_outlined,
                                              size: 50.0)), // Image icon
                                  const SizedBox(
                                      height:
                                          8), // Add spacing between icon and text
                                  Row(children: [
                                    Expanded(
                                      child: Text(
                                        message.file!,
                                        style: const TextStyle(fontSize: 16),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        downloadFile(
                                            '${dotenv.env['BASE_URL']}/storage/uploads/chats/files/${message.file!}');
                                      },
                                      icon: const Icon(
                                          Icons.file_download), // Download icon
                                    ),
                                  ]),
                                ],
                              ),
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
