import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:not_instagram/model/user.dart';
import 'package:not_instagram/providers/user_provider.dart';
import 'package:not_instagram/resources/firestore_method.dart';
import 'package:not_instagram/screens/user_profile_screen.dart';
import 'package:not_instagram/screens/visitor_user_profile.dart';
import 'package:not_instagram/utils/global_variables.dart';
import 'package:not_instagram/utils/utils.dart';
import 'package:not_instagram/widgets/comment_card.dart';
import 'package:not_instagram/widgets/text_field_input.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ChatScreen extends StatefulWidget {
  final User user2;
  const ChatScreen({Key? key, required this.user2}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController chatTextEditingController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    chatTextEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.user2.userName,
          style: headerTextStyle,
        ),
        centerTitle: false,
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      backgroundColor: backgroundColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // StreamBuilder(
                      //   stream: FirebaseFirestore.instance
                      //       .collection('chats')
                      //       .doc(widget.user2.userId)
                      //       .collection(user.userId).orderBy('datePublished', descending: false)
                      //       .snapshots(),
                      //   builder: (BuildContext context,
                      //       AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                      //           snapshot) {
                      //     if (snapshot.connectionState ==
                      //         ConnectionState.waiting) {
                      //       return Center(
                      //         child: CircularProgressIndicator(),
                      //       );
                      //     }
                      //     print('New length');
                      //     print(snapshot.data!.docs.length);
                      //     return ListView.builder(
                      //         shrinkWrap: true,
                      //         physics: BouncingScrollPhysics(),
                      //         itemCount: snapshot.data!.docs.length,
                      //         itemBuilder: (context, index) {
                      //           return Card(
                      //             color: Colors.pink.withOpacity(.7),
                      //             elevation: 5,
                      //             child: Container(
                      //               padding: EdgeInsets.symmetric(
                      //                   vertical: 18, horizontal: 10),
                      //               child: Row(
                      //                 // mainAxisAlignment: MainAxisAlignment.start,
                      //                 // crossAxisAlignment: CrossAxisAlignment.start,
                      //                 children: [
                      //                   snapshot.data!
                      //                       .docs[index]
                      //                   ['userId'] == user.userId? Container():  GestureDetector(
                      //                     onTap: () async {},
                      //                     child: CircleAvatar(
                      //                       backgroundImage: NetworkImage(
                      //                         snapshot.data!.docs[index]
                      //                             ['profilePic'],
                      //                       ),
                      //                       radius: 18,
                      //                     ),
                      //                   ),
                      //                   Expanded(
                      //                     child: Padding(
                      //                       padding: EdgeInsets.only(left: 10),
                      //                       child: Column(
                      //                         crossAxisAlignment:
                      //                             CrossAxisAlignment.start,
                      //                         mainAxisAlignment:
                      //                             MainAxisAlignment.center,
                      //                         children: [
                      //                           GestureDetector(
                      //                             onTap: () async {},
                      //                             child: Text(
                      //                               snapshot.data!.docs[index]
                      //                                   ['name'],
                      //                               style: headerTextStyle.copyWith(color: Colors.white.withOpacity(.9)),
                      //                             ),
                      //                           ),
                      //                           RichText(
                      //                             text: TextSpan(
                      //                               children: [
                      //                                 TextSpan(
                      //                                   text: snapshot.data!
                      //                                           .docs[index]
                      //                                       ['chatMessage'],
                      //                                   style: headerTextStyle
                      //                                       .copyWith(
                      //                                           fontWeight:
                      //                                               FontWeight
                      //                                                   .w400,
                      //                                           fontSize: 15),
                      //                                 ),
                      //                               ],
                      //                             ),
                      //                           ),
                      //                           Padding(
                      //                             padding:
                      //                                 EdgeInsets.only(top: 4),
                      //                             child: Text(
                      //                                 '${DateFormat.yMMMd().format(
                      //                                   (snapshot.data!.docs[
                      //                                                   index][
                      //                                               'datePublished']
                      //                                           as Timestamp)
                      //                                       .toDate(),
                      //                                 )}',
                      //                                 style:
                      //                                     subHeaderNotHighlightedTextStyle),
                      //                           ),
                      //                           // Divider( color: Colors.white.withOpacity(.4),)
                      //                         ],
                      //                       ),
                      //                     ),
                      //                   ),
                      //
                      //                   snapshot.data!
                      //                       .docs[index]
                      //                   ['userId'] == user.userId?   GestureDetector(
                      //                     onTap: () async {},
                      //                     child: CircleAvatar(
                      //                       backgroundImage: NetworkImage(
                      //                         snapshot.data!.docs[index]
                      //                         ['profilePic'],
                      //                       ),
                      //                       radius: 18,
                      //                     ),
                      //                   ) : Container(),
                      //                 ],
                      //               ),
                      //             ),
                      //           );
                      //
                      //           //   Container(
                      //           //   child: Text(
                      //           //     snapshot.data!.docs[index]['chatMessage'],
                      //           //     style: headerTextStyle,
                      //           //   ),
                      //           // );
                      //         });
                      //   },
                      // )
                    ],
                  ),
                ),
              ),
            ),
            Divider(
              color: Colors.white.withOpacity(.4),
            ),
            Container(
              height: kToolbarHeight,
              // color: Colors.black87,
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          user.photoUrl,
                        ),
                        radius: 18,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          child: CustomTextField(
                              textEditingController: chatTextEditingController,
                              hintText: 'Send a message...',
                              textInputType: TextInputType.text),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      IconButton(
                          onPressed: () async {
                            String chatId = Uuid().v1();

                            // await FirebaseFirestore.instance
                            //     .collection('chats')
                            //     .doc(widget.user2.userId)
                            //     .collection(user.userId)
                            //     .doc(chatId)
                            //     .set({
                            //   'profilePic': user.photoUrl,
                            //   'name': user.userName,
                            //   'chatId': chatId,
                            //   'chatMessage': chatTextEditingController.text,
                            //   'datePublished': DateTime.now(),
                            //   'userId': user.userId
                            // });




                            await FirebaseFirestore.instance
                                .collection('chats')
                                .doc(widget.user2.userId)
                                .collection('messages')
                                .doc(chatId)
                                .set({
                              'profilePic': user.photoUrl,
                              'name': user.userName,
                              'chatId': chatId,
                              'chatMessage': chatTextEditingController.text,
                              'datePublished': DateTime.now(),
                              'userId': user.userId
                            });
                          },
                          icon: Icon(
                            Icons.send,
                            color: Colors.white,
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 2,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
