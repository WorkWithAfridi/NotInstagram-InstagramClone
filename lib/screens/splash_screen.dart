import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:not_instagram/main.dart';
import 'package:not_instagram/responsive/mobile_screen_layout.dart';
import 'package:not_instagram/screens/splash_screen_push.dart';
import 'package:not_instagram/utils/global_variables.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash-view';
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void triggerSplashScreen(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3));
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => SplashScreenPush(),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    triggerSplashScreen(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
          primaryColor: Colors.pink,
          splashColor: Colors.pink,
          colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: Colors.pink
          )
      ),
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: AppBar(
            backgroundColor: backgroundColor,
          ),
        ),
        backgroundColor: backgroundColor,
        body: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Not Instagram',
                style: titleTextStyle,
              ),
              Text(
                'By Kyoto.',
                style: headerTextStyle.copyWith(fontSize: 15,height: .5, color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
