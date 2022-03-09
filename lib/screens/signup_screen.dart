import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:not_instagram/providers/user_provider.dart';
import 'package:not_instagram/resources/auth_methods.dart';
import 'package:not_instagram/responsive/mobile_screen_layout.dart';
import 'package:not_instagram/screens/login_screen.dart';
import 'package:not_instagram/utils/global_variables.dart';
import 'package:not_instagram/utils/utils.dart';
import 'package:not_instagram/widgets/text_field_input.dart';
import 'package:provider/provider.dart';

import '../constants/layout_constraints.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailTEC = TextEditingController();
  final TextEditingController passwordTEC = TextEditingController();
  final TextEditingController bioTEC = TextEditingController();
  final TextEditingController usernameTEC = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    emailTEC.dispose();
    passwordTEC.dispose();
    bioTEC.dispose();
    usernameTEC.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: getHeight(context),
        width: getWidth(context),
        child: Stack(
          children: [
            Container(
              height: getHeight(context),
              width: getWidth(context),
              child: Image.asset(
                'assets/signup_bg.png',
                fit: BoxFit.cover,
              ),
            ),
            Container(
              height: getHeight(context),
              width: getWidth(context),
              color: Colors.black.withOpacity(.85),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .15,
                          ),
                          Text(
                            'Not Instagram',
                            style: titleTextStyle.copyWith(fontSize: 30),
                          ),
                          Text(
                            "It's not Instagram but it's better.",
                            style: subHeaderNotHighlightedTextStyle,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
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
                                              fit: BoxFit.fitWidth,
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
                                        color: Colors.pink,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                'Create a \nnew account',
                                style: titleTextStyle.copyWith(fontSize: 25),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          getTextField(
                            textEditingController: usernameTEC,
                            hintText: 'Username',
                            textInputType: TextInputType.emailAddress,
                            maxLines: 1,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          getTextField(
                            textEditingController: emailTEC,
                            hintText: 'Email',
                            textInputType: TextInputType.emailAddress,
                            maxLines: 1,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          getTextField(
                            textEditingController: passwordTEC,
                            hintText: 'Password',
                            textInputType: TextInputType.emailAddress,
                            maxLines: 1,
                            isPass: true,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          getTextField(
                            textEditingController: bioTEC,
                            hintText: 'Bio',
                            textInputType: TextInputType.text,
                            maxLines: 3,
                            isPass: false,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          _isLoading
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                )
                              : Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      if (_image != null &&
                                          emailTEC.text.isNotEmpty &&
                                          passwordTEC.text.isNotEmpty &&
                                          usernameTEC.text.isNotEmpty &&
                                          bioTEC.text.isNotEmpty) {
                                        String res =
                                            await AuthMethods().signUpUser(
                                          email: emailTEC.text,
                                          password: passwordTEC.text,
                                          userName: usernameTEC.text,
                                          bio: bioTEC.text,
                                          file: _image!,
                                        );
                                        if (res == 'success') {
                                          await Provider.of<UserProvider>(
                                                  context,
                                                  listen: false)
                                              .refreshUser();
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const MobileScreenLayout()),
                                          );
                                        }
                                      } else {
                                        showSnackbar(context, "Invalid input.");
                                      }
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    },
                                    child: Text(
                                      'Login',
                                      style: headerTextStyle,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        primary:
                                            Theme.of(context).primaryColor),
                                  ),
                                ),

                          SizedBox(
                            height: 30,
                          ),
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
                            child: Text(
                              'Login',
                              style: subHeaderTextStyle.copyWith(fontSize: 20),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          // SizedBox(
                          //   height: 15,
                          // ),
                          // Text(
                          //   'Forgotten your login details?',
                          //   style: getDefaultTextStyle.copyWith(fontSize: 10),
                          // ),
                          // Text(' Get help with logging in.',
                          //     style: getDefaultTextStyle),
                          // SizedBox(
                          //   height: 10,
                          // ),
                        ],
                      ),
                    ),
                  ),
                  // Container(
                  //   child: Column(
                  //     children: [
                  //     ],
                  //   ),
                  // )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              height: 125,
              width: getWidth(context),
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
