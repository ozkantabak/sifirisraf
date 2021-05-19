import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sifirisraf/utils/variables.dart';
import 'package:timeago/timeago.dart' as tAgo;

class CommentPage extends StatefulWidget {
  final String documentid;
  CommentPage(this.documentid);
  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  var commentcontroller = TextEditingController();

  addcomment() async {
    var firebaseuser = FirebaseAuth.instance.currentUser;
    DocumentSnapshot userdoc =
        await usercollection.doc(firebaseuser.uid).get();
    flowcollection
        .doc(widget.documentid)
        .collection('comments')
        .doc()
        .set({
      'comment': commentcontroller.text,
      'username': userdoc['username'],
      'uid': userdoc['uid'],
      'profilepic': userdoc['profilepic'],
      'time': DateTime.now()
    });
    DocumentSnapshot commentcount =
        await flowcollection.doc(widget.documentid).get();
    
    flowcollection.doc(widget.documentid).update({
      'commentcount': commentcount['commentcount'] + 1});
    commentcontroller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: flowcollection
                      .doc(widget.documentid)
                      .collection('comments')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot commentdoc =
                              snapshot.data.docs[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage:
                                  NetworkImage(commentdoc['profilepic']),
                            ),
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    commentdoc['username'],
                                    style: mystyle(20),
                                  ),
                                  flex: 0,
                                ),
                                SizedBox(
                                  width: 15.0,
                                ),
                                Expanded(
                                  child: Text(
                                    commentdoc['comment'],
                                    style: mystyle(20, Colors.grey, FontWeight.w500),
                                  ),
                                )
                              ],
                            ),
                            /*e: Text(
                              tAgo
                                  .format(commentdoc['time'].toDate())
                                  .toString(),
                              style: mystyle(15),
                            ),*/
                          );
                        });
                  },
                ),
              ),
              Divider(),
              ListTile(
                title: TextFormField(
                  controller: commentcontroller,
                  decoration: InputDecoration(
                    hintText: "Bir yorum ekle...",
                    hintStyle: mystyle(18),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey,)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                  ),
                ),
                trailing: OutlineButton(
                  onPressed: () => addcomment(),
                  borderSide: BorderSide.none,
                  child: Text(
                    "Gönder",
                    style: mystyle(16),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
