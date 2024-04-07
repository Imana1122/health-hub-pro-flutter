import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:fyp_flutter/common/color_extension.dart';
import 'package:permission_handler/permission_handler.dart';

class PDFViewFromStoragePage extends StatefulWidget {
  final String title;

  const PDFViewFromStoragePage({super.key, required this.title});

  @override
  State<PDFViewFromStoragePage> createState() => _PDFViewFromStoragePageState();
}

class _PDFViewFromStoragePageState extends State<PDFViewFromStoragePage> {
  late String urlPDFPath;
  bool loaded = false;
  int _totalPages = 0;
  int _currentPage = 0;
  late PDFViewController _pdfViewController;

  @override
  void initState() {
    super.initState();
    urlPDFPath = widget.title;
    _checkPermissionAndLoadPdf();
  }

  Future<void> _checkPermissionAndLoadPdf() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    setState(() {
      loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!loaded) {
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
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: PDFView(
        filePath: urlPDFPath,
        autoSpacing: true,
        enableSwipe: true,
        pageSnap: true,
        swipeHorizontal: true,
        nightMode: false,
        onError: (e) {
          // Handle error
          print('Error while loading PDF: $e');
        },
        onRender: (pages) {
          setState(() {
            _totalPages = pages!;
          });
        },
        onViewCreated: (controller) {
          setState(() {
            _pdfViewController = controller;
          });
        },
        onPageChanged: (page, total) {
          setState(() {
            _currentPage = page!;
          });
        },
        onPageError: (page, e) {
          // Handle error for specific page
          print('Error on page $page: $e');
        },
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
  }
}
