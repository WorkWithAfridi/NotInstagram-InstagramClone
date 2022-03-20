import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:not_instagram/main.dart';
import 'package:not_instagram/responsive/mainframe.dart';
import 'package:not_instagram/screens/splash_screen_push.dart';
import 'package:not_instagram/utils/global_variables.dart';

import '../constants/layout_constraints.dart';

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
        builder: (context) => const SplashScreenPush(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    triggerSplashScreen(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.pink,
          splashColor: Colors.pink,
          colorScheme: ColorScheme.fromSwatch().copyWith(primary: Colors.pink)),
      home: Scaffold(
        backgroundColor: backgroundColor,
        body: Stack(
          children: [
            SizedBox(
              height: getHeight(context),
              width: getWidth(context),
              child: Image.asset(
                'assets/splash_screen_bg.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Container(
              height: getHeight(context),
              width: getWidth(context),
              color: Colors.black.withOpacity(.75),
            ),
            Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 100,
                        width: 65,
                        child: Lottie.asset(
                            'assets/lottie_animations/logoAnimation.json',
                            repeat: false),
                      ),
                      Container(
                        width: 1,
                        height: 35,
                        decoration: BoxDecoration(
                          color: Colors.pink,
                          gradient: LinearGradient(
                              colors: [
                                Colors.orange.withOpacity(.8),
                                Colors.orangeAccent.withOpacity(.8),
                                Colors.pink.withOpacity(.8),
                                Colors.redAccent.withOpacity(.8),
                                //add more colors for gradient
                              ],
                              begin: Alignment
                                  .topLeft, //begin of the gradient color
                              end: Alignment
                                  .bottomRight, //end of the gradient color
                              stops: const [
                                0,
                                0.2,
                                0.5,
                                0.8
                              ] //stops for individual color
                              //set the stops number equal to numbers of color
                              ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '!instagram',
                            style: AppTitleTextStyle,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'By KYOTO',
                            style: creatorTextStyle,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
