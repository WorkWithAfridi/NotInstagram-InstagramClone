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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          elevation: 0,
          backgroundColor: mobileBackgroundColor,
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    // color: Colors.white,
                    height: MediaQuery.of(context).size.width / 6,
                    width: MediaQuery.of(context).size.width / 6,
                    child: Lottie.asset(
                        'assets/lottie_animations/instagram_logo.json'),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Not Instagram',
                        style: GoogleFonts.getFont('Mochiy Pop P One',
                            fontSize: 25, fontWeight: FontWeight.w800),
                      ),
                      Text(
                        'Not an Instagram clone!',
                        style: GoogleFonts.getFont('Roboto',
                            fontSize: 15, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              CustomTextField(
                  textEditingController: _emailTextController,
                  hintText: 'Enter your email here.',
                  textInputType: TextInputType.emailAddress),
              SizedBox(
                height: 15,
              ),
              CustomTextField(
                  textEditingController: _passwordTextController,
                  hintText: 'Enter your password here.',
                  isPass: true,
                  textInputType: TextInputType.emailAddress),
              SizedBox(
                height: 15,
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Don't have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SignupScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
