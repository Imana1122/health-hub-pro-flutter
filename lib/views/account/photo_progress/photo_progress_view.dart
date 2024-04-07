import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:fyp_flutter/services/account/progress_service.dart';
import 'package:fyp_flutter/views/account/photo_progress/add_progress_view.dart';
import 'package:fyp_flutter/views/layouts/authenticated_user_layout.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../common/color_extension.dart';
import '../../../common_widget/round_button.dart';
import 'comparison_view.dart';

class PhotoProgressView extends StatefulWidget {
  const PhotoProgressView({super.key});

  @override
  State<PhotoProgressView> createState() => _PhotoProgressViewState();
}

class _PhotoProgressViewState extends State<PhotoProgressView> {
  List photoArr = [];
  bool isLoading = false;
  late AuthProvider authProvider;
  int currentPage = 1;
  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    loadDetails();
  }

  void loadDetails() async {
    setState(() {
      isLoading = true;
    });
    var result = await ProgressService(authProvider)
        .getProgress(currentPage: currentPage);
    setState(() {
      photoArr = result['data'];
      currentPage = result['current_page'];
      isLoading = false;
    });
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
                  "Progress Photo",
                  style: TextStyle(
                      color: TColor.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
                actions: [
                  InkWell(
                    onTap: () {},
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      height: 40,
                      width: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: TColor.lightGray,
                          borderRadius: BorderRadius.circular(10)),
                      child: Image.asset(
                        "assets/img/more_btn.png",
                        width: 15,
                        height: 15,
                        fit: BoxFit.contain,
                      ),
                    ),
                  )
                ],
              ),
              backgroundColor: TColor.white,
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: Container(
                            width: double.maxFinite,
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                color: const Color(0xffFFE5E5),
                                borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: TColor.white,
                                      borderRadius: BorderRadius.circular(30)),
                                  width: 50,
                                  height: 50,
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                    "assets/img/date_notifi.png",
                                    width: 30,
                                    height: 30,
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Reminder!",
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          "Next Photos Fall On ${getNextMonth()}",
                                          style: TextStyle(
                                              color: TColor.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ]),
                                ),
                                Container(
                                    height: 60,
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.close,
                                          color: TColor.gray,
                                          size: 15,
                                        )))
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: Container(
                            width: double.maxFinite,
                            padding: const EdgeInsets.all(20),
                            height: media.width * 0.4,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  TColor.primaryColor2.withOpacity(0.4),
                                  TColor.primaryColor1.withOpacity(0.4)
                                ]),
                                borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        "Track Your Progress Each\nMonth With Photo",
                                        style: TextStyle(
                                          color: TColor.black,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const Spacer(),
                                    ]),
                                Image.asset(
                                  "assets/img/progress_each_photo.png",
                                  width: media.width * 0.35,
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: media.width * 0.05,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
                          decoration: BoxDecoration(
                            color: TColor.primaryColor2.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Compare my Photo",
                                style: TextStyle(
                                    color: TColor.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                width: 100,
                                height: 25,
                                child: RoundButton(
                                  title: "Compare",
                                  type: RoundButtonType.bgGradient,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ComparisonView(),
                                      ),
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Gallery",
                                style: TextStyle(
                                    color: TColor.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                        ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: photoArr.length,
                            itemBuilder: ((context, index) {
                              var pObj = photoArr[index] as Map? ?? {};
                              var imaArr = [
                                '${dotenv.env['BASE_URL']}/storage/uploads/progress/front/${pObj['front_image']}',
                                '${dotenv.env['BASE_URL']}/storage/uploads/progress/back/${pObj['back_image']}',
                                '${dotenv.env['BASE_URL']}/storage/uploads/progress/right/${pObj['right_image']}',
                                '${dotenv.env['BASE_URL']}/storage/uploads/progress/left/${pObj['left_image']}',
                              ];

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      DateFormat.yMMMM().format(DateTime.parse(
                                          pObj["updated_at"].toString())),
                                      style: TextStyle(
                                          color: TColor.gray, fontSize: 12),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 100,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      padding: EdgeInsets.zero,
                                      itemCount: imaArr.length,
                                      itemBuilder: ((context, indexRow) {
                                        return Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 4),
                                          width: 100,
                                          decoration: BoxDecoration(
                                            color: TColor.lightGray,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.network(
                                              imaArr[indexRow],
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (BuildContext context,
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
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                ],
                              );
                            }))
                      ],
                    ),
                    SizedBox(
                      height: media.width * 0.05,
                    ),
                  ],
                ),
              ),
              floatingActionButton: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProgressForm(),
                    ),
                  );
                },
                child: Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: TColor.secondaryG),
                      borderRadius: BorderRadius.circular(27.5),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5,
                            offset: Offset(0, 2))
                      ]),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.photo_camera,
                    size: 20,
                    color: TColor.white,
                  ),
                ),
              ),
            ),
          );
  }

  String getNextMonth() {
    final now = photoArr.length > 1
        ? DateTime.parse(photoArr[0]['updated_at'])
        : DateTime.now();
    final nextMonth = photoArr.length > 1
        ? DateTime(now.year, now.month + 1)
        : DateTime(now.year, now.month);
    final formatter = DateFormat.MMMM();
    return formatter.format(nextMonth);
  }
}
