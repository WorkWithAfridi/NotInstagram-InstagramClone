import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:not_instagram/providers/user_provider.dart';
import 'package:not_instagram/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    //if web
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
    if (kDebugMode) {
      print('running main');
    }
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => UserProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Not Instagram',
        theme: ThemeData(
          primaryColor: Colors.pink,
          splashColor: Colors.pink,
          colorScheme: ColorScheme.fromSwatch().copyWith(primary: Colors.pink),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
