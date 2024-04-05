import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:fyp_flutter/common/color_extension.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class PDFViewPage extends StatefulWidget {
  final String title;

  const PDFViewPage({super.key, required this.title});

  @override
  _PDFViewPageState createState() => _PDFViewPageState();
}

class _PDFViewPageState extends State<PDFViewPage> {
  String urlPDFPath = "";
  bool exists = true;
  int _totalPages = 0;
  int _currentPage = 0;
  bool pdfReady = false;
  late PDFViewController _pdfViewController;
  bool loaded = false;

  Future<File> getFileFromUrl(String url, {String? name}) async {
    var fileName = 'testonline';
    if (name != null) {
      fileName = name;
    }
    try {
      var data = await http.get(Uri.parse(url));
      var bytes = data.bodyBytes;
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$fileName.pdf");
      print(dir.path);
      File urlFile = await file.writeAsBytes(bytes);
      return urlFile;
    } catch (e) {
      throw Exception("Error opening url file");
    }
  }

  void requestPermission() async {
    await Permission.storage.request();
  }

  @override
  void initState() {
    super.initState();

    requestPermission();
    getFileFromUrl(widget.title).then(
      (value) => {
        setState(() {
          if (value != null) {
            urlPDFPath = value.path;
            loaded = true;
            exists = true;
          } else {
            exists = false;
          }
        })
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print(urlPDFPath);
    if (loaded) {
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
            "PDF View",
            style: TextStyle(
                color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
        body: PDFView(
          filePath: urlPDFPath,
          autoSpacing: true,
          enableSwipe: true,
          pageSnap: true,
          swipeHorizontal: true,
          nightMode: false,
          onError: (e) {
            //Show some error message or UI
          },
          onRender: (_pages) {
            setState(() {
              _totalPages = _pages!;
              pdfReady = true;
            });
          },
          onViewCreated: (PDFViewController vc) {
            setState(() {
              _pdfViewController = vc;
            });
          },
          onPageChanged: (int? page, int? total) {
            setState(() {
              _currentPage = page!;
            });
          },
          onPageError: (page, e) {},
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: TColor.secondaryColor1,
                borderRadius:
                    BorderRadius.circular(8), // Adjust the radius as needed
              ),
              width: 40,
              height: 40,
              padding: const EdgeInsets.all(
                  3), // Add padding to ensure the icon is not too close to the edges
              child: FittedBox(
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      if (_currentPage > 0) {
                        _currentPage--;
                        _pdfViewController.setPage(_currentPage);
                      }
                    });
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
              ),
            ),
            Text(
              "${_currentPage + 1}/$_totalPages",
              style: const TextStyle(color: Colors.black, fontSize: 20),
            ),
            Container(
              decoration: BoxDecoration(
                color: TColor.secondaryColor1,
                borderRadius:
                    BorderRadius.circular(8), // Adjust the radius as needed
              ),
              width: 40,
              height: 40,
              padding: const EdgeInsets.all(
                  3), // Add padding to ensure the icon is not too close to the edges
              child: FittedBox(
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      if (_currentPage < _totalPages - 1) {
                        _currentPage++;
                        _pdfViewController.setPage(_currentPage);
                      }
                    });
                  },
                  icon: const Icon(Icons.arrow_forward),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      if (exists) {
        //Replace with your loading UI
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
              "PDF View",
              style: TextStyle(
                  color: TColor.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
            ),
          ),
          body: const Center(
            child: Text(
              "Loading..",
              style: TextStyle(fontSize: 20),
            ),
          ),
        );
      } else {
        //Replace Error UI
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
              "PDF View",
              style: TextStyle(
                  color: TColor.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
            ),
          ),
          body: const Text(
            "PDF Not Available",
            style: TextStyle(fontSize: 20),
          ),
        );
      }
    }
  }
}
