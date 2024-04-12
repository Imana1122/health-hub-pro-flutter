import 'package:flutter/material.dart';
import 'package:fyp_flutter/common/color_extension.dart';
import 'package:fyp_flutter/services/other_service.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactView extends StatefulWidget {
  const ContactView({super.key});

  @override
  State<ContactView> createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView> {
  Map contactInfo = {
    'Corporate Office': 'corporate_office',
    'Email': 'email',
    'Phone Number': 'phone_number',
    'Mobile Number': 'mobile_number',
  };

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    loadData();
  }

  void loadData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var result = await OtherService().getContact();
      setState(() {
        contactInfo = result;
      });
    } catch ($e) {
      print($e);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          "Contact Information",
          style: TextStyle(
              color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      backgroundColor: TColor.white,
      body: ListView.builder(
        itemCount: contactInfo.length - 3,
        itemBuilder: (context, index) {
          String title = contactInfo.keys.elementAt(index + 1);
          String value = contactInfo.values.elementAt(index + 1);
          return ListTile(
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(value),
            leading: const Icon(Icons.contacts),
            onTap: () {
              _launchContactAction(title, value);
            },
          );
        },
      ),
    );
  }

  void _launchContactAction(String title, String value) async {
    if (title == 'phone_number' || title == 'mobile_number') {
      final url = 'tel:$value';
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        throw 'Could not launch $url';
      }
    } else if (title == 'email') {
      var subject = 'HealthHub Pro';
      var body = '';
      final url =
          'mailto:$value?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}';
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        throw 'Could not launch $url';
      }
    } else if (title == 'corporate_office') {
      final url = 'https://www.google.com/maps/search/?api=1&query=$value';

      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        throw 'Could not launch $url';
      }
    }
  }
}
