import 'package:flutter/material.dart';
import 'package:fyp_flutter/common_widget/round_button.dart';
import 'package:url_launcher/url_launcher.dart';

class DownloadPage extends StatelessWidget {
  final String fileUrl; // URL of the file to be downloaded

  const DownloadPage({super.key, required this.fileUrl});

  Future<void> _downloadFile(String urlString) async {
    var url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RoundButton(
          onPressed: () {
            _downloadFile(fileUrl);
          },
          title: 'Download File',
        ),
      ),
    );
  }
}
