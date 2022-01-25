import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:not_instagram/screens/explore_screen.dart';
import 'package:not_instagram/screens/profile_screen.dart';
import 'package:not_instagram/screens/upload_post.dart';
import 'package:not_instagram/screens/my_feed_screen.dart';

const webScreenSize = 600;

var homeScreenPages = [
  MyFeedScreen(),
  ExploreScreen(),
  AddPostScreen(),
  Container(
    color: Colors.purple,
  ),
  ProfileScreen()
];

Color backgroundColor=Color(0xff111111) ;
Color liftedBackgroundColor=Colors.white;

final TextStyle headerTextStyle = GoogleFonts.getFont('Ubuntu Condensed', textStyle: const TextStyle(color: Colors.white, fontSize: 17,));
final TextStyle subHeaderTextStyle = GoogleFonts.getFont('Ubuntu Condensed', textStyle: TextStyle(color: Colors.white, fontSize: 14,));
final TextStyle subHeaderNotHighlightedTextStyle = GoogleFonts.getFont('Ubuntu Condensed', textStyle: TextStyle(color: Colors.white54, fontSize: 14,));
final TextStyle titleTextStyle = GoogleFonts.getFont('Sedgwick Ave', textStyle: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w900));
final TextStyle subTitleTextStyle = GoogleFonts.getFont('Ubuntu Condensed', textStyle: TextStyle(color: Colors.white54, fontSize: 16,));