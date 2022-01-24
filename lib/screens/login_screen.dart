import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:not_instagram/resources/auth_methods.dart';
import 'package:not_instagram/responsive/mobile_screen_layout.dart';
import 'package:not_instagram/responsive/responsive_layout_screen.dart';
import 'package:not_instagram/responsive/web_screen_layout.dart';
import 'package:not_instagram/screens/signup_screen.dart';
import 'package:not_instagram/utils/colors.dart';
import 'package:not_instagram/utils/utils.dart';
import 'package:not_instagram/widgets/text_field_input.dart';

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
      backgroundColor: Colors.black,
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(left: 30, right: 30, top: 70),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Text(
              'English (United Kingdom)',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 12),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Not Instagram',
                    style: GoogleFonts.getFont('Mochiy Pop P One',
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w800),
                  ),
                  Text(
                    'Not an Instagram clone!',
                    style: GoogleFonts.getFont('Roboto',
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w800),
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
                              if(_emailTextController.text.isNotEmpty && _passwordTextController.text.isNotEmpty){
                                setState(() {
                                  _isLoading = true;
                                });
                                String res = await AuthMethods().logInUser(
                                    email: _emailTextController.text,
                                    password: _passwordTextController.text);

                                setState(() {
                                  _isLoading = false;
                                });
                                if (res != 'success') {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => ResponsiveLayout(
                                        mobileScreenLayout: MobileScreenLayout(),
                                        webScreenLayout: WebScreenLayout(),
                                      ),
                                    ),
                                  );
                                }
                              }
                              else{
                                showSnackbar(context, 'Credentials cannot be left empty!!');
                              }
                            },
                            child: Text('Log in'),
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
                      Text(
                        'Forgotten your login details?',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      Text(
                        ' Get help with logging in.',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 12),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SignupScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 12),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
