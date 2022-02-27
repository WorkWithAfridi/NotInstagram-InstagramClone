import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:not_instagram/providers/user_provider.dart';
import 'package:not_instagram/resources/auth_methods.dart';
import 'package:not_instagram/responsive/mobile_screen_layout.dart';
import 'package:not_instagram/responsive/responsive_layout_screen.dart';
import 'package:not_instagram/responsive/web_screen_layout.dart';
import 'package:not_instagram/screens/login_screen.dart';
import 'package:not_instagram/utils/colors.dart';
import 'package:not_instagram/utils/global_variables.dart';
import 'package:not_instagram/utils/utils.dart';
import 'package:not_instagram/widgets/text_field_input.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _bioTextController = TextEditingController();
  final TextEditingController _userNameTextController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _bioTextController.dispose();
    _userNameTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: backgroundColor,
          leading: IconButton(
            onPressed: (){
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ),
              );
            },
            icon: Icon(Icons.arrow_back, color: Colors.white,),
          ),
        ),
        backgroundColor: backgroundColor,
        body: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(
            horizontal: 20,
          ),
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  // color: Colors.red.withOpacity(.3),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // SizedBox(
                        //   height: 25,
                        // ),
                        Text(
                          'Sign up to',
                          style: titleTextStyle.copyWith(fontSize: 16),
                        ),
                        Text(
                          'Not Instagram.',
                          style: titleTextStyle.copyWith(fontSize: 30),
                        ),
                        // SizedBox(
                        //   height: MediaQuery.of(context).size.height * .05,
                        // ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Stack(
                                children: [
                                  _image != null
                                      ? CircleAvatar(
                                          radius: 40,
                                          backgroundImage: MemoryImage(_image!),
                                        )
                                      : CircleAvatar(
                                          radius: 40,
                                          backgroundColor: backgroundColor,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                            child: Image.asset(
                                              'assets/defaultProPic.png',
                                              fit: BoxFit.fitHeight,
                                            ),
                                          ),
                                        ),
                                  Positioned(
                                    bottom: -15,
                                    left: 40,
                                    child: IconButton(
                                      onPressed: () async {
                                        Uint8List? image = await pickImage(
                                            ImageSource.gallery);
                                        if (image != null) {
                                          setState(() {
                                            _image = image;
                                          });
                                        }
                                      },
                                      icon: Icon(
                                        Icons.add_a_photo,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Container(
                                  child: CustomTextField(
                                      textEditingController:
                                          _userNameTextController,
                                      hintText: 'Enter your user name here.',
                                      textInputType:
                                          TextInputType.emailAddress),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        CustomTextField(
                            textEditingController: _emailTextController,
                            hintText: 'Enter your email here.',
                            textInputType: TextInputType.emailAddress),
                        SizedBox(
                          height: 10,
                        ),
                        CustomTextField(
                            textEditingController: _passwordTextController,
                            hintText: 'Enter your password here.',
                            isPass: true,
                            textInputType: TextInputType.emailAddress),
                        SizedBox(
                          height: 10,
                        ),
                        CustomTextField(
                            textEditingController: _bioTextController,
                            hintText: 'Enter your bio here.',
                            textInputType: TextInputType.emailAddress),
                        SizedBox(
                          height: 10,
                        ),
                        _isLoading
                            ? CircularProgressIndicator(
                                color: Theme.of(context).primaryColor,
                              )
                            : Container(
                                width: MediaQuery.of(context).size.width,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    if (_image != null &&
                                        _emailTextController.text.isNotEmpty &&
                                        _passwordTextController
                                            .text.isNotEmpty &&
                                        _userNameTextController
                                            .text.isNotEmpty &&
                                        _bioTextController.text.isNotEmpty) {
                                      String res =
                                          await AuthMethods().signUpUser(
                                        email: _emailTextController.text,
                                        password: _passwordTextController.text,
                                        userName: _userNameTextController.text,
                                        bio: _bioTextController.text,
                                        file: _image!,
                                      );
                                      if (res == 'success') {
                                        await Provider.of<UserProvider>(context,
                                                listen: false)
                                            .refreshUser();
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ResponsiveLayout(
                                              mobileScreenLayout:
                                                  MobileScreenLayout(),
                                              webScreenLayout:
                                                  WebScreenLayout(),
                                            ),
                                          ),
                                        );
                                      }
                                    } else {
                                      showSnackbar(context, "Invalid input.");
                                    }
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  },
                                  child: Text('Sign up'),
                                  style: ElevatedButton.styleFrom(
                                      primary: Theme.of(context).primaryColor),
                                ),
                              ),
                        SizedBox(
                          height: 6,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Divider(
                            color: Colors.white.withOpacity(.5),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () async {
                              showSnackbar(context,
                                  'Ahhh nah, it doesnot work! Gotta code it in. :)');
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: Icon(
                                      FontAwesomeIcons.google,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Sign up with Google.',
                                    style: headerTextStyle.copyWith(
                                        color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.white.withOpacity(.9)),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () async {
                              showSnackbar(context,
                                  'Ahhh nah, it doesnot work! Gotta code it in. :)');
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: Icon(
                                      FontAwesomeIcons.facebook,
                                      // color: Colors.black,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Sign up with Facebook.',
                                    style: headerTextStyle,
                                  ),
                                ),
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blueAccent),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: subHeaderNotHighlightedTextStyle,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );
                    },
                    child: Text("Log in", style: subHeaderTextStyle),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
