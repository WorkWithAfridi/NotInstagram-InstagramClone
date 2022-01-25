import 'package:flutter/material.dart';
import 'package:not_instagram/screens/explore_screen.dart';
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
  Container(
    color: Colors.green,
  ),
];
