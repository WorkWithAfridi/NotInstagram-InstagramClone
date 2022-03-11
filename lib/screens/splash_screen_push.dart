import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:not_instagram/responsive/mobile_screen_layout.dart';

import 'login_screen.dart';

class SplashScreenPush extends StatefulWidget {
  const SplashScreenPush({Key? key}) : super(key: key);

  @override
  _SplashScreenPushState createState() => _SplashScreenPushState();
}

class _SplashScreenPushState extends State<SplashScreenPush> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            return const MobileScreenLayout();
          } else if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          }
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return const LoginScreen();
      },
    );
  }
}
