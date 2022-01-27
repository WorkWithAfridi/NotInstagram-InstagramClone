import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:not_instagram/model/user.dart';
import 'package:not_instagram/providers/user_provider.dart';
import 'package:not_instagram/resources/auth_methods.dart';
import 'package:not_instagram/responsive/mobile_screen_layout.dart';
import 'package:not_instagram/responsive/responsive_layout_screen.dart';
import 'package:not_instagram/responsive/web_screen_layout.dart';
import 'package:not_instagram/screens/signup_screen.dart';
import 'package:not_instagram/utils/colors.dart';
import 'package:not_instagram/utils/global_variables.dart';
import 'package:not_instagram/utils/utils.dart';
import 'package:not_instagram/widgets/text_field_input.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  bool _isLoading = false;
  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        alignment: Alignment.center,
        // color: Colors.red,
        padding: EdgeInsets.only(left: 30, right: 30, top: 70),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            SizedBox(height: 10,),
            Text(
              'English (United Kingdom)',
              style: subHeaderNotHighlightedTextStyle,
            ),
            Expanded(
              child: Container(
                // color: Colors.yellow,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Hii, welcome to',
                      style: titleTextStyle.copyWith(fontSize: 16),
                    ),
                    Text(
                      'Not Instagram.',
                      style: titleTextStyle.copyWith(fontSize: 30),
                    ),
                    Text(
                      'Definitely not an Instagram clone!',
                      style: subTitleTextStyle,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    CustomTextField(
                        textEditingController: _emailTextController,
                        hintText: 'Phone number, email address or username',
                        textInputType: TextInputType.emailAddress),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                        textEditingController: _passwordTextController,
                        hintText: 'Password',
                        isPass: true,
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
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_emailTextController.text.isNotEmpty &&
                                    _passwordTextController
                                        .text.isNotEmpty) {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  String res = await AuthMethods()
                                      .logInUser(
                                          email: _emailTextController.text,
                                          password:
                                              _passwordTextController.text,
                                          context: context);

                                  if (res == 'success') {
                                    await Provider.of<UserProvider>(context,
                                            listen: false)
                                        .refreshUser();

                                    setState(() {
                                      _isLoading = false;
                                    });
                                    Navigator.of(context)
                                        .pushAndRemoveUntil(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ResponsiveLayout(
                                                mobileScreenLayout:
                                                    MobileScreenLayout(),
                                                webScreenLayout:
                                                    WebScreenLayout(),
                                              ),
                                            ),
                                            ModalRoute.withName('/'));
                                  }
                                } else {
                                  showSnackbar(context,
                                      'Credentials cannot be left empty!!');
                                }
                              },
                              child: Text(
                                'Log in',
                                style: headerTextStyle,
                              ),
                              style: ElevatedButton.styleFrom(
                                  primary: Theme.of(context).primaryColor),
                            ),
                          ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Forgotten your login details?',
                            style: subHeaderNotHighlightedTextStyle),
                        Text(' Get help with logging in.',
                            style: subHeaderTextStyle),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: subHeaderNotHighlightedTextStyle,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => SignupScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Sign Up',
                        style: subHeaderTextStyle,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
