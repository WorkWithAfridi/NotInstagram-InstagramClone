import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:not_instagram/utils/global_variables.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showUsers = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              height: kToolbarHeight,
              // color: Colors.white30,
              child: TextFormField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search',
                  border: InputBorder.none,
                  labelStyle: subHeaderTextStyle,
                ),
                style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 1),
                cursorColor: Colors.white,
                onFieldSubmitted: (String value) {
                  setState(() {
                    _showUsers = true;
                  });
                  print(value);
                },
                // onChanged: (value) {
                //   print(value);
                // },
              ),
            ),
            Expanded(
              child: Container(
                // color: Colors.purple,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: _showUsers
                    ? FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .where(
                              'username',
                              isGreaterThanOrEqualTo: _searchController.text,
                            )
                            .get(),
                        builder: (context, snapshot) {
                          print(_searchController.text);
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return ListView.builder(
                            itemCount: (snapshot.data! as dynamic).docs.length,
                            itemBuilder: (context, index) {
                              return Card(
                                color: backgroundColor,
                                elevation:0,
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.black12,
                                    backgroundImage: NetworkImage(
                                        (snapshot.data! as dynamic).docs[index]
                                            ['photoUrl']),
                                  ),
                                  title: Text(
                                    (snapshot.data! as dynamic).docs[index]
                                        ['username'],
                                    style: headerTextStyle,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      )
                    : Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection('posts')
                              .get(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return StaggeredGridView.countBuilder(
                              crossAxisCount: 3,
                              itemCount:
                                  (snapshot.data! as dynamic).docs.length,
                              itemBuilder: (context, index) {
                                return Image.network((snapshot.data! as dynamic)
                                    .docs[index]['postPhotoUrl'], fit: BoxFit.cover,);
                              },
                              staggeredTileBuilder: (index) =>
                                  StaggeredTile.count((index % 7 == 0) ? 2 : 1,
                                      (index % 7 == 0) ? 2 : 1),
                              mainAxisSpacing: 4,
                              crossAxisSpacing: 4,
                            );
                          },
                        ),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
