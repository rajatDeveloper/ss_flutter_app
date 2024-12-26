import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PDFScreen extends StatefulWidget {
  final String? path;

  PDFScreen({Key? key, required this.path}) : super(key: key);

  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();

  int pages = 0;
  int currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Document"),
        // actions: <Widget>[
        //   IconButton(
        //     icon: const Icon(Icons.share),
        //     onPressed: () {
        //       // Add your share logic here
        //     },
        //   ),
        // ],
      ),
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: widget.path,
            enableSwipe: true,
            swipeHorizontal: true,
            autoSpacing: false,
            pageFling: true,
            pageSnap: true,
            defaultPage: currentPage,
            fitPolicy: FitPolicy.BOTH,
            preventLinkNavigation: false, // Handle links in Flutter
            backgroundColor: Colors.black,
            onRender: (int? pagesCount) {
              setState(() {
                pages = pagesCount ?? 0;
                isReady = true;
              });
            },
            onError: (error) {
              setState(() {
                errorMessage = error.toString();
              });
              debugPrint(error.toString());
            },

            onViewCreated: (PDFViewController pdfViewController) {
              _controller.complete(pdfViewController);
            },
            onLinkHandler: (String? uri) {
              debugPrint('Goto uri: $uri');
            },
            onPageChanged: (int? page, int? total) {
              setState(() {
                currentPage = page ?? 0;
              });
              debugPrint('Page changed: $page/$total');
            },
          ),
          if (!isReady && errorMessage.isEmpty)
            const Center(
              child: CircularProgressIndicator(),
            )
          else if (errorMessage.isNotEmpty)
            Center(
              child: Text(
                errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
      floatingActionButton: FutureBuilder<PDFViewController>(
        future: _controller.future,
        builder: (context, AsyncSnapshot<PDFViewController> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return FloatingActionButton.extended(
              label: Text("Go to ${pages ~/ 2}"),
              onPressed: () async {
                await snapshot.data!.setPage(pages ~/ 2);
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
