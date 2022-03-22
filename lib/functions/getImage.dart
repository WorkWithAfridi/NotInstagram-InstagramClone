import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../screens/upload_post.dart';
import '../screens/upload_story.dart';
import '../utils/global_variables.dart';
import '../utils/utils.dart';

class GetImage {
  _pickAndPushImageToRequiredUploadScreen(
      ImageSource src, BuildContext context, bool isStory) async {
    Uint8List? file = await pickImage(src);
    if (file != null) {
      if (isStory) {
        //TO Story upload page

        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AddDetailAndUploadStory(
              file: file,
            ),
          ),
        );
        Navigator.of(context).pop();
      } else {
        await Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => AddDetailAndUploadPost(file: file)),
        );
        Navigator.of(context).pop();
      }
    } else {
      Navigator.of(context).pop();
    }
  }

  OpenDialogAndShowOptionToPickImageFrom(BuildContext context, bool isStory) {
    return showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) {
        return SimpleDialog(
          elevation: 6,
          backgroundColor: backgroundColor,
          title: GestureDetector(
            onTap: () {
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) => OpenWebView(
              //         websiteLink:
              //         'https://sites.google.com/view/workwithafridi'),
              //   ),
              // );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '!instagram',
                  style: headerTextStyle,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'By KYOTO',
                  style: creatorTextStyle,
                ),
              ],
            ),
          ),
          children: [
            SimpleDialogOption(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Row(
                children: [
                  Icon(
                    Icons.camera,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Take a Photo',
                    style: subHeaderTextStyle,
                  ),
                ],
              ),
              onPressed: () async {
                Uint8List file = await _pickAndPushImageToRequiredUploadScreen(
                    ImageSource.camera, context, isStory);
              },
            ),
            SimpleDialogOption(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Row(
                children: [
                  Icon(
                    Icons.image,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Choose from Gallery',
                    style: subHeaderTextStyle,
                  ),
                ],
              ),
              onPressed: () async {
                try {
                  Uint8List file =
                      await _pickAndPushImageToRequiredUploadScreen(
                          ImageSource.gallery, context, isStory);
                } catch (e) {}
              },
            ),
            SimpleDialogOption(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Row(
                children: [
                  Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Cancel',
                    style: subHeaderTextStyle,
                  ),
                ],
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
}
