import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:not_instagram/model/user.dart' as model;
import 'package:not_instagram/providers/user_provider.dart';
import 'package:not_instagram/resources/firestore_method.dart';
import 'package:not_instagram/utils/global_variables.dart';
import 'package:not_instagram/utils/utils.dart';
import 'package:provider/provider.dart';

class AddDetailAndUploadStory extends StatefulWidget {
  final Uint8List file;
  const AddDetailAndUploadStory({Key? key, required this.file})
      : super(key: key);

  @override
  _AddDetailAndUploadStoryState createState() =>
      _AddDetailAndUploadStoryState();
}

class _AddDetailAndUploadStoryState extends State<AddDetailAndUploadStory> {
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
    final model.UserModel user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text(
          'Add a Story',
          style: headerTextStyle,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.clear_outlined,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          GestureDetector(
            onTap: () async {
              setState(() {
                _isLoading = true;
              });
              String uid = user.userId;
              String userName = user.userName;
              String profileImage = user.photoUrl;

              try {
                String res = await FireStoreMethods()
                    .uploadStory(widget.file, uid, userName, profileImage);
                if (res == 'success') {
                  showSnackbar(context, 'Posted');
                  setState(() {
                    _isLoading = false;
                  });
                  // await Future.delayed(Duration(seconds: 1));
                  Navigator.of(context).pop();
                } else {
                  showSnackbar(context, res);
                }
              } catch (e) {
                showSnackbar(context, 'Could not post. An Error occurred.');
              }
              setState(
                () {
                  _isLoading = false;
                },
              );
            },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Text(
                  'Upload',
                  style: headerTextStyle.copyWith(color: Colors.pink),
                ),
              ),
            ),
          )
        ],
      ),
      backgroundColor: Colors.black,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: backgroundColor,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _isLoading
                  ? LinearProgressIndicator(
                      minHeight: 1,
                      color: Colors.pink,
                    )
                  : Container(),
              Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    alignment: FractionalOffset.topCenter,
                    image: MemoryImage(widget.file),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
