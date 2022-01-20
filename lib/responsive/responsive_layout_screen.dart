import 'package:flutter/material.dart';
import 'package:not_instagram/utils/dimentions.dart';

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({Key? key, required this.webScreenLayout, required this.mobileScreenLayout}) : super(key: key);

  final Widget webScreenLayout;
  final Widget mobileScreenLayout;


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints){
        if(constraints.maxWidth>webScreenSize){
          //web Screen layout
          return webScreenLayout;
        }
        //mobile screen
        return mobileScreenLayout;
      },
    );
  }
}
