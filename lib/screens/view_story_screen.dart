import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:not_instagram/utils/global_variables.dart';

import '../widgets/text_field_input.dart';

class ViewStory extends StatefulWidget {
  final snap;
  final user;
  const ViewStory({Key? key, required this.snap, required this.user})
      : super(key: key);

  @override
  _ViewStoryState createState() => _ViewStoryState();
}

class _ViewStoryState extends State<ViewStory> {
  TextEditingController _messageTEC = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          elevation: 0,
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            SizedBox.expand(
              child: Hero(
                tag: widget.snap['postPhotoUrl'],
                child: Image.network(
                  widget.snap['postPhotoUrl'],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.black54,
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 50,
                    padding: EdgeInsets.only(left: 15),
                    child: Row(
                      children: [
                        Container(
                          height: 45,
                          width: 45,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(45),
                            child: Image.network(
                              widget.snap['profilePhotoUrl'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.snap['username'],
                                style: titleTextStyle.copyWith(fontSize: 20),
                              ),
                              Text(
                                DateFormat.yMMMd().format(
                                  DateTime.parse(
                                    widget.snap['datePublished'],
                                  ),
                                ),
                                style: subHeaderNotHighlightedTextStyle,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.more_vert,
                              color: Colors.white,
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Container(
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(widget.user.photoUrl),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: CustomTextField(
                              textEditingController: _messageTEC,
                              hintText: 'Send a message...',
                              textInputType: TextInputType.text),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
