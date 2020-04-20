import 'dart:async';
import 'package:covidnineteentracker/helpers/colors.dart';
import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';

class NewsDetail extends StatelessWidget {
  final String title;
  final String selectedUrl;

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  NewsDetail({
    @required this.title,
    @required this.selectedUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Bgcolor,
          title: Text(title, style: TextStyle(color: Colors.blue)),
        ),
        body: title != null && title != "" && selectedUrl != null && selectedUrl != ""
            ? WebView(
                initialUrl: selectedUrl,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
              )
            : Center(
                child: Text("Sayfa Bulunamadı"),
              ));
  }
}
