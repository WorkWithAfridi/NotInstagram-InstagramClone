import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:not_instagram/providers/user_provider.dart';
import 'package:not_instagram/responsive/mobile_screen_layout.dart';
import 'package:not_instagram/responsive/responsive_layout_screen.dart';
import 'package:not_instagram/responsive/web_screen_layout.dart';
import 'package:not_instagram/screens/login_screen.dart';
import 'package:not_instagram/screens/signup_screen.dart';
import 'package:not_instagram/utils/colors.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: 'AIzaSyAAKFAzdkGFPnhFC06uXR6d9QvkT7lwMTU',
      appId: '1:1067572072236:web:7f873fa697dc2f7835a689',
      messagingSenderId: '1067572072236',
      projectId: 'notinstagram-6f647',
      storageBucket: "notinstagram-6f647.appspot.com",
    ));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=> UserProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Not Instagram',
        theme: ThemeData.light().copyWith(
          // scaffoldBackgroundColor: mobileBackgroundColor,
          primaryColor: Colors.pink,
        ),
        //check if user is already logged in or not
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const ResponsiveLayout(
                  mobileScreenLayout: MobileScreenLayout(),
                  webScreenLayout: WebScreenLayout(),
                );
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
        ),

        // const
      ),
    );
  }
}

// link

// https://www.youtube.com/watch?v=mEPm9w5QlJM

// time
// 2:58:46
