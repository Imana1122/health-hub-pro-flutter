import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp_flutter/models/user.dart';
import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

import '../../../common/color_extension.dart';

class ExercisesStepDetails extends StatefulWidget {
  final Map eObj;
  const ExercisesStepDetails({super.key, required this.eObj});

  @override
  State<ExercisesStepDetails> createState() => _ExercisesStepDetailsState();
}

class _ExercisesStepDetailsState extends State<ExercisesStepDetails> {
  double burned = 0.0;
  late AuthProvider authProvider;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    User user = authProvider.getAuthenticatedUser();
    burned = (widget.eObj['metabolic_equivalent'] * user.profile.weight) / 60.0;
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
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
              "assets/img/closed_btn.png",
              width: 15,
              height: 15,
              fit: BoxFit.contain,
            ),
          ),
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
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: media.width,
                    height: media.width * 0.43,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: TColor.primaryG),
                        borderRadius: BorderRadius.circular(20)),
                    child: Image.network(
                      'http://10.0.2.2:8000/uploads/exercise/${widget.eObj['image']}',
                      width: media.width,
                      height: media.width * 0.43,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Container(
                    width: media.width,
                    height: media.width * 0.43,
                    decoration: BoxDecoration(
                        color: TColor.black.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                widget.eObj["name"].toString(),
                style: TextStyle(
                    color: TColor.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                "Easy |${burned.toStringAsFixed(2)} per minute",
                style: TextStyle(
                  color: TColor.gray,
                  fontSize: 12,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                "Descriptions",
                style: TextStyle(
                    color: TColor.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 4,
              ),
              ReadMoreText(
                widget.eObj['description'].toString(),
                trimLines: 4,
                colorClickableText: TColor.black,
                trimMode: TrimMode.Line,
                trimCollapsedText: ' Read More ...',
                trimExpandedText: ' Read Less',
                style: TextStyle(
                  color: TColor.gray,
                  fontSize: 12,
                ),
                moreStyle:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                "Custom Repetitions",
                style: TextStyle(
                    color: TColor.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 200,
                child: CupertinoPicker.builder(
                  itemExtent: 40,
                  selectionOverlay: Container(
                    width: double.maxFinite,
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                            color: TColor.gray.withOpacity(0.2), width: 1),
                        bottom: BorderSide(
                            color: TColor.gray.withOpacity(0.2), width: 1),
                      ),
                    ),
                  ),
                  onSelectedItemChanged: (index) {},
                  childCount: 60,
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/img/burn.png",
                          width: 15,
                          height: 15,
                          fit: BoxFit.contain,
                        ),
                        Text(
                          "${((index + 1) * burned).toStringAsFixed(2)} Calories Burn",
                          style: TextStyle(color: TColor.gray, fontSize: 10),
                        ),
                        Text(
                          " ${index + 1} ",
                          style: TextStyle(
                              color: TColor.gray,
                              fontSize: 24,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          " minutes",
                          style: TextStyle(color: TColor.gray, fontSize: 16),
                        )
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
