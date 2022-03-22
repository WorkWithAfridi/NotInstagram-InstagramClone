import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:not_instagram/constants/layout_constraints.dart';
import 'package:not_instagram/model/user.dart' as model;
import 'package:not_instagram/providers/user_provider.dart';
import 'package:not_instagram/resources/firestore_method.dart';
import 'package:not_instagram/utils/global_variables.dart';
import 'package:not_instagram/utils/utils.dart';
import 'package:not_instagram/widgets/customTextField.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'comments_screen.dart';

class EditPostScreen extends StatefulWidget {
  final snap;
  const EditPostScreen({Key? key, required this.snap}) : super(key: key);

  @override
  _EditPostScreenState createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  Uint8List? _file;
  final TextEditingController _textEditingController = TextEditingController();

  _selectImage(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Post a memory'),
          children: [
            SimpleDialogOption(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: const Text('Take a Photo'),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(ImageSource.camera);
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: const Text('Choose from Gallery'),
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
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: const Text('Cancel'),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  final TextEditingController _descriptionController = TextEditingController();

  bool isLikeAnimating = false;
  int noOfComments = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void getData() async {
    _textEditingController.text = widget.snap['description'].toString();
    try {
      QuerySnapshot querySnap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();

      setState(() {
        noOfComments = querySnap.docs.length;
      });
    } catch (e) {}
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _descriptionController.dispose();
  }

  bool showLoading = false;

  @override
  Widget build(BuildContext context) {
    final model.UserModel user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text(
          'Edit post.',
          style: headerTextStyle.copyWith(fontSize: 20),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () async {
              setState(
                () {
                  showLoading = true;
                },
              );
              await FirebaseFirestore.instance
                  .collection('posts')
                  .doc(widget.snap['postId'])
                  .update({'description': _textEditingController.text})
                  .then((value) => print('updated'))
                  .catchError((error) => print('Update Failed: $error'));
              setState(() {
                showLoading = false;
              });
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.check,
              color: Colors.pink,
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      body: SizedBox(
        // padding: EdgeInsets.symmetric(vertical: 0, horizontal: ),
        // color: Colors.black38,
        width: double.infinity,
        child: Card(
          color: backgroundColor,
          elevation: 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              showLoading
                  ? const LinearProgressIndicator(
                      color: Colors.pink,
                    )
                  : Container(),
              Container(
                color: Colors.black26,
                width: getWidth(context),
                height: getWidth(context),
                child: GestureDetector(
                  onDoubleTap: () async {
                    // await FireStoreMethods().likePost(
                    //     widget.snap['postId'], user.userId, widget.snap['likes']);
                    // setState(() {
                    //   isLikeAnimating = true;
                    // });
                  },
                  child: Hero(
                    tag: widget.snap['postPhotoUrl'],
                    child: Image.network(
                      widget.snap['postPhotoUrl'],
                      fit: BoxFit.cover,
                      alignment: FractionalOffset.center,
                    ),
                  ),
                ),
              ),
              Container(
                // height: 100,
                // color: Colors.purple,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 60,
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () async {},
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.black12,
                                  backgroundImage: NetworkImage(
                                      widget.snap['profilePhotoUrl']),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.snap['username'],
                                      style: headerTextStyle,
                                    ),
                                    Text(
                                      timeago.format(widget
                                          .snap['datePublished']
                                          .toDate()),
                                      style: subHeaderNotHighlightedTextStyle,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    getTextField(
                      textEditingController: _textEditingController,
                      maxLines: 4,
                      hintText: 'Enter your post description here.',
                      textInputType: TextInputType.text,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    // GestureDetector(
                    //   onTap: () {
                    //     Navigator.of(context).push(
                    //       MaterialPageRoute(
                    //         builder: (context) => CommentsScreen(
                    //           snap: widget.snap,
                    //         ),
                    //       ),
                    //     );
                    //   },
                    //   child: noOfComments > 0
                    //       ? Text(
                    //           'View all ${noOfComments} comments...',
                    //           style: subHeaderNotHighlightedTextStyle,
                    //         )
                    //       : Container(),
                    // ),
                    // SizedBox(
                    //   height: 10,
                    // )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
