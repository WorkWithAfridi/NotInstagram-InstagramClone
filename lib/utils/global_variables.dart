import 'package:flutter/material.dart';
import 'package:not_instagram/screens/app_post.dart';
import 'package:not_instagram/screens/my_feed_screen.dart';

const webScreenSize = 600;

var homeScreenPages = [
  MyFeedScreen(),
  Container(
    color: Colors.blue,
  ),
  AddPostScreen(),
  Container(
    color: Colors.purple,
  ),
  Container(
    color: Colors.green,
  ),
];
