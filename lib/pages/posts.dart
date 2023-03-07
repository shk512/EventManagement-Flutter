import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_management/pages/edit_post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../services/db.dart';
import '../utils/decor.dart';

class Posts extends StatefulWidget {
  const Posts({Key? key}) : super(key: key);

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  String _selectedMenu = '';
  @override
  void initState() {
    super.initState();
  }

  check(String postId) async {
    if (_selectedMenu == 'edit') {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => Edit_post(postId: postId)));
    } else if (_selectedMenu == 'delete') {
      deletePost();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("posts")
            .orderBy("time", descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: snapshot.data.docs[index]['createBy'] ==
                            FirebaseAuth.instance.currentUser!.uid
                        ? Card(
                            shadowColor: Colors.black,
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        snapshot.data.docs[index]['name'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Decor.color,
                                          fontSize: 20,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        snapshot.data.docs[index]['address'],
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          fontWeight: FontWeight.bold,
                                          color: Decor.lightBlack,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(),
                                  SizedBox(height: 5),
                                  Text(
                                    'Description ',
                                    style: TextStyle(
                                      color: Decor.prime,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(snapshot.data.docs[index]['desc']),
                                  '${snapshot.data.docs[index]['image']}'
                                          .isEmpty
                                      ? SizedBox(height: 0)
                                      : Image.network(
                                          '${snapshot.data.docs[index]['image']}'),
                                  SizedBox(height: 5),
                                  Divider(),
                                  SizedBox(height: 5),
                                  Center(
                                    child: OutlinedButton(
                                      onPressed: () {},
                                      child: Text('Write a porposal'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : SizedBox(height: 0),
                  );
                });
          } else {
            return Center(
              child: Text('No post'),
            );
          }
        },
      ),
    );
  }

  deletePost() async {}
}
