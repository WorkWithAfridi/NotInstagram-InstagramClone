import 'package:flutter/material.dart';
import 'package:not_instagram/utils/global_variables.dart';

class LikesScreen extends StatefulWidget {
  const LikesScreen({Key? key}) : super(key: key);

  @override
  _LikesScreenState createState() => _LikesScreenState();
}

class _LikesScreenState extends State<LikesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Text('Work in progress...', style: subHeaderNotHighlightedTextStyle,),
      ),
    );
  }
}
