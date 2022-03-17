import 'dart:io';

import 'package:flutter/material.dart';
import 'package:not_instagram/utils/global_variables.dart';
import 'package:webview_flutter/webview_flutter.dart';

class OpenWebView extends StatefulWidget {
  static const routeName = '/web_view';
  final String websiteLink;
  const OpenWebView({Key? key, required this.websiteLink}) : super(key: key);

  @override
  State<OpenWebView> createState() => _OpenWebViewState();
}

class _OpenWebViewState extends State<OpenWebView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    String url = widget.websiteLink;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          backgroundColor: Colors.black,
        ),
      ),
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: Container(
          height: double.infinity,
          width: double.infinity,
          child: WebView(
            zoomEnabled: true,
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: url,
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: backgroundColor,
            title: Text(
              'Close this window?',
              style: headerTextStyle,
            ),
            // content: Text(
            //   'Are you sure, you want to close this window?',
            //   style: subHeaderTextStyle,
            // ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  'No',
                  style: subHeaderTextStyle,
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  'Yes',
                  style: subHeaderTextStyle,
                ),
              ),
            ],
          ),
        )) ??
        false;
  }
}
