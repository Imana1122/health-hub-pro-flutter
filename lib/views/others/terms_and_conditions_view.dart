import 'package:flutter/material.dart';
import 'package:fyp_flutter/services/other_service.dart';

import '../../../common/color_extension.dart';

class TermsAndConditionsView extends StatefulWidget {
  const TermsAndConditionsView({super.key});

  @override
  State<TermsAndConditionsView> createState() => _TermsAndConditionsViewState();
}

class _TermsAndConditionsViewState extends State<TermsAndConditionsView> {
  List<dynamic> termsAndConditionsArr = [];

  late ScrollController _scrollController;
  bool isLoading = false;
  int currentPage = 1;
  int lastPage = 1;
  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()..addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
    loadMore();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (currentPage < lastPage) {
        setState(() {
          currentPage++;
        });
        loadMore();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void loadMore() async {
    setState(() {
      isLoading = true;
    });
    try {
      var result =
          await OtherService().getTermsAndConditions(currentPage: currentPage);
      setState(() {
        termsAndConditionsArr = result['data'];
        currentPage = result['current_page'];
        lastPage = result['last_page'];
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
              "assets/img/black_btn.png",
              width: 15,
              height: 15,
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: Text(
          "Terms and Conditions",
          style: TextStyle(
              color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      backgroundColor: TColor.white,
      body: Container(
          alignment: Alignment.centerLeft,
          height: media.height,
          child: ListView.separated(
            scrollDirection: Axis.vertical,
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
            itemBuilder: (context, index) {
              var nObj = termsAndConditionsArr[index]; // No need for casting
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Text(
                      '${index + 1}.', // Displaying the index
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                        width:
                            8), // Adding some spacing between index and content
                    Expanded(
                      child: Text(
                        nObj['content'],
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Divider(
                color: TColor.gray.withOpacity(0.5),
                height: 1,
              );
            },
            itemCount: termsAndConditionsArr.length,
          )),
    );
  }
}
