import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:not_instagram/resources/auth_methods.dart';
import 'package:not_instagram/responsive/mainframe.dart';
import 'package:not_instagram/screens/signup_screen.dart';
import 'package:not_instagram/utils/global_variables.dart';
import 'package:not_instagram/utils/utils.dart';
import 'package:not_instagram/widgets/customTextField.dart';

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
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              'assets/login_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.black.withOpacity(.75),
          ),
          Container(
            alignment: Alignment.center,
            // color: Colors.red,
            padding: const EdgeInsets.only(left: 30, right: 30, top: 60),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // const SizedBox(
                //   height: 10,
                // ),
                // Text(
                //   'English (United Kingdom)',
                //   style: subHeaderNotHighlightedTextStyle,
                // ),
                // const SizedBox(
                //   height: 10,
                // ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    // color: Colors.blue,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          // color: Colors.yellow,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '!instagram',
                                style: AppTitleTextStyle.copyWith(fontSize: 30),
                              ),
                              Text(
                                "It's !instagram and it's better.",
                                style: subHeaderNotHighlightedTextStyle
                                    .copyWith(height: .8, fontSize: 13),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              getTextField(
                                  textEditingController: _emailTextController,
                                  maxLines: 1,
                                  hintText:
                                      'Phone number, email address or username',
                                  textInputType: TextInputType.emailAddress),
                              const SizedBox(
                                height: 10,
                              ),
                              getTextField(
                                  textEditingController:
                                      _passwordTextController,
                                  hintText: 'Password',
                                  maxLines: 1,
                                  isPass: true,
                                  textInputType: TextInputType.emailAddress),
                              const SizedBox(
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
                                          if (_emailTextController
                                                  .text.isNotEmpty &&
                                              _passwordTextController
                                                  .text.isNotEmpty) {
                                            setState(() {
                                              _isLoading = true;
                                            });
                                            String res = await AuthMethods()
                                                .logInUser(
                                                    email: _emailTextController
                                                        .text,
                                                    password:
                                                        _passwordTextController
                                                            .text,
                                                    context: context);

                                            if (res == 'success') {
                                              // await Provider.of<UserProvider>(
                                              //         context,
                                              //         listen: false)
                                              //     .refreshUser();

                                              Navigator.of(context)
                                                  .pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const MainFrame(),
                                                ),
                                                ModalRoute.withName('/'),
                                              );
                                            } else {
                                              setState(() {
                                                _isLoading = false;
                                              });
                                              showSnackbar(context, res);
                                            }
                                          } else {
                                            showSnackbar(context,
                                                'Credentials cannot be left empty!!');
                                          }
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
                              const SizedBox(
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
                              // const SizedBox(
                              //   height: 10,
                              // ),
                              // Padding(
                              //   padding: const EdgeInsets.symmetric(
                              //       horizontal: 25.0),
                              //   child: Divider(
                              //     color: Colors.white.withOpacity(.5),
                              //   ),
                              // ),
                              // const SizedBox(
                              //   height: 10,
                              // ),
                              // SizedBox(
                              //   width: MediaQuery.of(context).size.width,
                              //   height: 40,
                              //   child: ElevatedButton(
                              //     onPressed: () async {
                              //       showSnackbar(context,
                              //           'Ahhh nah, it doesnot work! Gotta code it in. :)');
                              //     },
                              //     child: Row(
                              //       mainAxisAlignment:
                              //           MainAxisAlignment.center,
                              //       children: [
                              //         const Flexible(
                              //           flex: 1,
                              //           child: Padding(
                              //             padding:
                              //                 EdgeInsets.only(right: 10.0),
                              //             child: Icon(
                              //               FontAwesomeIcons.google,
                              //               color: Colors.black,
                              //             ),
                              //           ),
                              //         ),
                              //         Expanded(
                              //           child: Text(
                              //             'Sign in with Google.',
                              //             style: headerTextStyle.copyWith(
                              //                 color: Colors.black),
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //     style: ElevatedButton.styleFrom(
                              //         primary: Colors.white.withOpacity(.9)),
                              //   ),
                              // ),
                              // const SizedBox(
                              //   height: 10,
                              // ),
                              // Container(
                              //   width: MediaQuery.of(context).size.width,
                              //   height: 40,
                              //   child: ElevatedButton(
                              //     onPressed: () async {
                              //       showSnackbar(context,
                              //           'Ahhh nah, it doesnot work! Gotta code it in. :)');
                              //     },
                              //     child: Row(
                              //       mainAxisAlignment:
                              //           MainAxisAlignment.center,
                              //       children: [
                              //         const Flexible(
                              //           flex: 1,
                              //           child: Padding(
                              //             padding:
                              //                 EdgeInsets.only(right: 10.0),
                              //             child: Icon(
                              //               FontAwesomeIcons.facebook,
                              //               // color: Colors.black,
                              //             ),
                              //           ),
                              //         ),
                              //         Expanded(
                              //           child: Text(
                              //             'Sign in with Facebook.',
                              //             style: headerTextStyle,
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //     style: ElevatedButton.styleFrom(
                              //         primary: Colors.blueAccent),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
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
                const SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
