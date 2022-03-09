import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:not_instagram/model/user.dart' as model;
import 'package:not_instagram/providers/user_provider.dart';
import 'package:not_instagram/resources/firestore_method.dart';
import 'package:not_instagram/utils/global_variables.dart';
import 'package:not_instagram/utils/utils.dart';
import 'package:not_instagram/widgets/text_field_input.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;

  _selectImage(BuildContext context) {
    return showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) {
        return SimpleDialog(
          elevation: 6,
          backgroundColor: backgroundColor,
          title: Text(
            'Post a memory',
            style: subHeaderTextStyle.copyWith(fontSize: 25),
          ),
          children: [
            SimpleDialogOption(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Text(
                'Take a Photo',
                style: subHeaderTextStyle,
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(ImageSource.camera);
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Text(
                'Choose from Gallery',
                style: subHeaderTextStyle,
              ),
              onPressed: () async {
                try {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                } catch (e) {}
              },
            ),
            SimpleDialogOption(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Text(
                'Cancel',
                style: subHeaderTextStyle,
              ),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar:
          // _file == null
          //     ? PreferredSize(child: AppBar(), preferredSize: Size.fromHeight(0))
          //     :
          AppBar(
        leading: _file == null
            ? Container()
            : IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _file = null;
                  });
                },
              ),
        backgroundColor: backgroundColor,
        title: _file == null
            ? Text(
                'Upload',
                style: headerTextStyle,
              )
            : Text(
                'Post To',
                style: headerTextStyle,
              ),
        centerTitle: _file == null ? true : false,
        actions: [
          _file == null
              ? Text('')
              : TextButton(
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    String uid = user.userId;
                    String userName = user.userName;
                    String profileImage = user.photoUrl;

                    try {
                      String res = await FireStoreMethods().uploadPost(
                          _file!,
                          _descriptionController.text,
                          uid,
                          userName,
                          user.photoUrl);
                      if (res == 'success') {
                        showSnackbar(context, 'Posted');
                      } else {
                        showSnackbar(context, res);
                      }
                    } catch (e) {
                      showSnackbar(
                          context, 'Could not post. An Error occurred.');
                    }
                    setState(
                      () {
                        _isLoading = false;
                        _file = null;
                      },
                    );
                  },
                  child: Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                )
        ],
      ),
      backgroundColor: Colors.black,
      body: _file == null
          ? Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              color: backgroundColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height * .1,
                    width: MediaQuery.of(context).size.height * .1,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 3),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: IconButton(
                      icon: Icon(
                        Icons.upload,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        try {
                          _selectImage(context);
                        } catch (e) {}
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Icon(
                    Icons.arrow_upward,
                    color: Colors.white,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Click here to save a memory',
                    style: headerTextStyle,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/3.toInt()),
                  //   child: Divider(height: .5,
                  //     color: Colors.white.withOpacity(.2),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // Text(
                  //   'Click here to add a story',
                  //   style: headerTextStyle,
                  // ),
                  // SizedBox(
                  //   height: 15,
                  // ),
                  // Icon(
                  //   Icons.arrow_downward,
                  //   color: Colors.white,
                  // ),
                  // SizedBox(
                  //   height: 15,
                  // ),
                  // Container(
                  //   alignment: Alignment.center,
                  //   height: MediaQuery.of(context).size.height * .1,
                  //   width: MediaQuery.of(context).size.height * .1,
                  //   decoration: BoxDecoration(
                  //       border: Border.all(color: Colors.white, width: 3),
                  //       borderRadius: BorderRadius.all(Radius.circular(10))),
                  //   child: IconButton(
                  //     icon: RotatedBox(
                  //       quarterTurns: 2,
                  //       child: Icon(
                  //         Icons.upload,
                  //         color: Colors.white,
                  //       ),
                  //     ),
                  //     onPressed: () {
                  //       try {
                  //         _selectImage(context);
                  //       } catch (e) {}
                  //     },
                  //   ),
                  // ),
                ],
              ),
            )
          : Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: backgroundColor,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _isLoading
                        ? const LinearProgressIndicator(
                            color: Colors.pink,
                          )
                        : Container(),
                    Container(
                      height: MediaQuery.of(context).size.height * .5,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          alignment: FractionalOffset.topCenter,
                          image: MemoryImage(_file!),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(user.photoUrl),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: getTextField(
                                textEditingController: _descriptionController,
                                maxLines: 4,
                                hintText: 'Enter a caption...',
                                textInputType: TextInputType.text),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
