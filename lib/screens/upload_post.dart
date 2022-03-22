import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:not_instagram/constants/layout_constraints.dart';
import 'package:not_instagram/model/user.dart' as model;
import 'package:not_instagram/providers/user_provider.dart';
import 'package:not_instagram/resources/firestore_method.dart';
import 'package:not_instagram/utils/global_variables.dart';
import 'package:not_instagram/utils/utils.dart';
import 'package:not_instagram/widgets/customTextField.dart';
import 'package:provider/provider.dart';

class AddDetailAndUploadPost extends StatefulWidget {
  final Uint8List file;
  const AddDetailAndUploadPost({Key? key, required this.file}) : super(key: key);

  @override
  _AddDetailAndUploadPostState createState() => _AddDetailAndUploadPostState();
}

class _AddDetailAndUploadPostState extends State<AddDetailAndUploadPost> {
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
      appBar:
          AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {

            Navigator.of(context).pop();
          },
        ),
        backgroundColor: backgroundColor,
        title: Text(
          'Add a memory',
          style: headerTextStyle,
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () async {
              setState(() {
                _isLoading = true;
              });
              String uid = user.userId;
              String userName = user.userName;
              String profileImage = user.photoUrl;

              try {
                String res = await FireStoreMethods().uploadPost(widget.file,
                    _descriptionController.text, uid, userName, user.photoUrl);
                if (res == 'success') {
                  showSnackbar(context, 'Posted');
                } else {
                  showSnackbar(context, res);
                }
              } catch (e) {
                showSnackbar(context, 'Could not post. An Error occurred.');
              }
              setState(
                () {
                  _isLoading = false;
                  Navigator.of(context).pop();
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
      body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: backgroundColor,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _isLoading
                        ? const LinearProgressIndicator(
                            minHeight: 1,
                            color: Colors.pink,
                          )
                        : Container(),
                    Container(
                      height: MediaQuery.of(context).size.height * .5,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          alignment: FractionalOffset.topCenter,
                          image: MemoryImage(widget.file),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(user.photoUrl),
                            backgroundColor: Colors.transparent,
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
