import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:not_instagram/constants/cacheManager.dart';
import 'package:not_instagram/utils/global_variables.dart';

import '../widgets/text_field_input.dart';

class ViewStory extends StatefulWidget {
  final parentSnap;
  final snap;
  final user;
  final indexPosition;
  const ViewStory(
      {Key? key,
      required this.snap,
      required this.user,
      required this.parentSnap,
      required this.indexPosition})
      : super(key: key);

  @override
  _ViewStoryState createState() => _ViewStoryState();
}

class _ViewStoryState extends State<ViewStory> {
  TextEditingController _messageTEC = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    totalStories = widget.parentSnap.docs.length;
    currentIndex = widget.indexPosition;
  }

  int totalStories = 0;
  int currentIndex = 0;
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
                  tag: widget.parentSnap.docs[currentIndex]['postPhotoUrl'],
                  child: CachedNetworkImage(
                    imageUrl: widget.parentSnap.docs[currentIndex]
                        ['postPhotoUrl'],
                    cacheManager: cacheManager,
                    fit: BoxFit.cover,
                    alignment: FractionalOffset.center,
                    placeholder: (context, url) => Container(
                      color: backgroundColor,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        color: Colors.pink,
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: backgroundColor,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.error,
                        color: Colors.pink,
                      ),
                    ),
                  )

                  // Image.network(
                  //   widget.parentSnap.docs[currentIndex]['postPhotoUrl'],
                  //   fit: BoxFit.cover,
                  // ),
                  ),
            ),
            GestureDetector(
              onTap: () {
                counter = 98;
              },
              // onVerticalDragDown: (_) {
              //   Navigator.pop(context);
              // },
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.black54,
              ),
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
                  getTimerBar(),
                  SizedBox(
                    height: 10,
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
                              child: CachedNetworkImage(
                                imageUrl: widget.parentSnap.docs[currentIndex]
                                    ['profilePhotoUrl'],
                                cacheManager: cacheManager,
                                fit: BoxFit.cover,
                                alignment: FractionalOffset.center,
                                placeholder: (context, url) => Container(
                                  color: backgroundColor,
                                  // alignment: Alignment.center,
                                  // child: CircularProgressIndicator(
                                  //   color: Colors.pink,
                                  // ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: backgroundColor,
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.error,
                                    color: Colors.pink,
                                  ),
                                ),
                              )

                              // Image.network(
                              //   widget.parentSnap.docs[currentIndex]
                              //       ['profilePhotoUrl'],
                              //   fit: BoxFit.cover,
                              // ),
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
                                widget.parentSnap.docs[currentIndex]
                                    ['username'],
                                style:
                                    subHeaderTextStyle.copyWith(fontSize: 20),
                              ),
                              Text(
                                DateFormat.yMMMd().format(
                                  DateTime.parse(
                                    widget.parentSnap.docs[currentIndex]
                                        ['datePublished'],
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
                          backgroundColor: Colors.transparent,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: getTextField(
                              maxLines: 1,
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

  int counter = 0;
  Stream<int> getTimer() async* {
    while (true) {
      await Future.delayed(Duration(milliseconds: 40));
      counter++;
      yield counter;
    }
  }

  Padding getTimerBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: StreamBuilder(
          stream: getTimer(),
          initialData: 0,
          builder: (context, snapshot) {
            if (int.parse(snapshot.data.toString()) == 99) {
              Future.delayed(Duration(milliseconds: 40)).then((value) {
                if (currentIndex < totalStories) {
                  currentIndex++;
                  print(currentIndex);
                  if (currentIndex == totalStories)
                    Navigator.of(context).pop();
                  else
                    setState(() {
                      counter = 0;
                    });
                } else {
                  print(currentIndex);
                  print(totalStories);
                  Navigator.of(context).pop();
                }
              });
            }
            return Stack(
              children: [
                Container(
                  height: 3,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.1),
                      borderRadius: BorderRadius.circular(5)),
                ),
                Container(
                  height: 3,
                  width: MediaQuery.of(context).size.width *
                      int.parse(snapshot.data.toString()) /
                      100,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5)),
                ),
              ],
            );
          }),
    );
  }
}
