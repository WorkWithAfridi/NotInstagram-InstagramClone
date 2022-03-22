import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:not_instagram/screens/explore_screen.dart';
import 'package:not_instagram/screens/likes_screen.dart';
import 'package:not_instagram/screens/user_profile_screen.dart';
import 'package:not_instagram/screens/upload_post.dart';
import 'package:not_instagram/screens/my_feed_screen.dart';

const webScreenSize = 600;

var Pages = [
  const HomeScreen(),
  const ExploreScreen(),
  const LikesScreen(),
  const UserProfileScreen()
];

Color backgroundColor = const Color(0xff111111);
Color liftedBackgroundColor = Colors.white;

final TextStyle headerTextStyle = GoogleFonts.getFont(
  'Ubuntu Condensed',
  textStyle: const TextStyle(
    color: Colors.white,
    fontSize: 17,
  ),
);
final TextStyle subHeaderTextStyle = GoogleFonts.getFont(
  'Ubuntu Condensed',
  textStyle: const TextStyle(
    color: Colors.white,
    fontSize: 14,
  ),
);
final TextStyle subHeaderNotHighlightedTextStyle = GoogleFonts.getFont(
  'Ubuntu Condensed',
  textStyle: const TextStyle(
    color: Colors.white54,
    fontSize: 14,
  ),
);
final TextStyle AppTitleTextStyle = GoogleFonts.getFont(
  'Fredoka One',
  textStyle: const TextStyle(
    color: Colors.white,
    fontSize: 25,
    fontWeight: FontWeight.w500,
  ),
);
final TextStyle subTitleTextStyle = GoogleFonts.getFont(
  'Ubuntu Condensed',
  textStyle: const TextStyle(
    color: Colors.white54,
    fontSize: 16,
  ),
);
final TextStyle creatorTextStyle = GoogleFonts.getFont(
  'Indie Flower',
  textStyle: const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
      height: .5,
      color: Colors.pink),
);
