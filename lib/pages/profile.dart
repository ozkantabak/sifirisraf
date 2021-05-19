import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sifirisraf/utils/variables.dart';

import '../comment.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String uid;
  Stream userstream;
  String username;
  int following;
  int followers;
  String profilepic;
  bool isfollowing;
  bool dataisthere = false;
  initState() {
    super.initState();
    getcurrentuseruid();
    getstream();
    getcurrentuserinfo();
  }

  getcurrentuserinfo() async {
    var firebaseuser = FirebaseAuth.instance.currentUser;
    DocumentSnapshot userdoc = await usercollection.doc(firebaseuser.uid).get();
    var followersdocuments = await usercollection
        .doc(firebaseuser.uid)
        .collection('followers')
        .get();
    var followingdocuments = await usercollection
        .doc(firebaseuser.uid)
        .collection('following')
        .get();
    usercollection
        .doc(firebaseuser.uid)
        .collection('followers')
        .doc(firebaseuser.uid)
        .get()
        .then((doc) {
      if (doc.exists) {
        setState(() {
          isfollowing = true;
        });
      } else {
        setState(() {
          isfollowing = false;
        });
      }
    });
    setState(() {
      username = userdoc.data()['username'];
      following = followingdocuments.docs.length;
      followers = followersdocuments.docs.length;
      profilepic = userdoc.data()['profilepic'];
      dataisthere = true;
    });
  }

  getstream() async {
    var firebaseuser = FirebaseAuth.instance.currentUser;
    setState(() {
      userstream = 
          flowcollection.where('uid', isEqualTo: firebaseuser.uid).snapshots();
    });
  }

  getcurrentuseruid() async {
    var firebaseuser = FirebaseAuth.instance.currentUser;
    setState(() {
      uid = firebaseuser.uid;
    });
  }

  likepost(String documentid) async {
    var firebaseuser = FirebaseAuth.instance.currentUser;
    DocumentSnapshot doc = await flowcollection.doc(documentid).get();

    if (doc.data()['likes'].contains(firebaseuser.uid)) {
      flowcollection.doc(documentid).update({
        'likes': FieldValue.arrayRemove([firebaseuser.uid])
      });
    } else {
      flowcollection.doc(documentid).update({
        'likes': FieldValue.arrayUnion([firebaseuser.uid])
      });
    }
  }

  sharepost(String documentid, String flow) async {
    Share.text('Sıfır İsraf', flow, 'text/plain');
    DocumentSnapshot doc = await flowcollection.doc(documentid).get();
    flowcollection.doc(documentid).update({'shares': doc.data()['shares'] + 1});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: dataisthere == true
            ? SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 4,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.greenAccent, Colors.purple])),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 6,
                          left: MediaQuery.of(context).size.width / 2 - 64),
                      child: CircleAvatar(
                        radius: 64,
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(profilepic),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 2.7),
                      child: Column(
                        children: [
                          Text(
                            username,
                            style: mystyle(30, Colors.black, FontWeight.w600),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Takip Edilenler",
                                style:
                                    mystyle(20, Colors.black, FontWeight.w600),
                              ),
                              Text(
                                "Takipçiler",
                                style:
                                    mystyle(20, Colors.black, FontWeight.w600),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                following.toString(),
                                style:
                                    mystyle(20, Colors.black, FontWeight.w600),
                              ),
                              Text(
                                followers.toString(),
                                style:
                                    mystyle(20, Colors.black, FontWeight.w600),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () {},
                            child: Container(
                              width: MediaQuery.of(context).size.width / 2,
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                      colors: [Colors.blue, Colors.lightBlue])),
                              child: Center(
                                child: Text(
                                  "Profili Düzenle",
                                  style: mystyle(
                                      25, Colors.white, FontWeight.w700),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Gönderilerim",
                            style: mystyle(25, Colors.black, FontWeight.w700),
                          ),
                          StreamBuilder(
                              stream: userstream,
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return CircularProgressIndicator();
                                }
                                return ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: snapshot.data.docs.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      DocumentSnapshot flowdoc =
                                          snapshot.data.docs[index];
                                      return Card(
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            backgroundImage: NetworkImage(
                                                flowdoc.data()['profilepic']),
                                          ),
                                          title: Text(
                                            flowdoc.data()['username'],
                                            style: mystyle(20, Colors.black,
                                                FontWeight.w600),
                                          ),
                                          subtitle: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                if (flowdoc.data()['type'] == 1)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      flowdoc.data()['flow'],
                                                      style: mystyle(
                                                          20,
                                                          Colors.black,
                                                          FontWeight.w400),
                                                    ),
                                                  ),
                                                if (flowdoc.data()['type'] == 2)
                                                  Image(
                                                      image: NetworkImage(
                                                          flowdoc['image'])),
                                                if (flowdoc.data()['type'] == 3)
                                                  Column(
                                                    children: [
                                                      Text(
                                                        flowdoc.data()['flow'],
                                                        style: mystyle(
                                                            20,
                                                            Colors.black,
                                                            FontWeight.w400),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Image(
                                                          image: NetworkImage(
                                                              flowdoc[
                                                                  'image'])),
                                                    ],
                                                  ),
                                                SizedBox(height: 10),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        InkWell(
                                                          onTap: () => Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      CommentPage(
                                                                          flowdoc
                                                                              .data()['id']))),
                                                          child: Icon(
                                                              Icons.comment),
                                                        ),
                                                        SizedBox(
                                                          width: 10.0,
                                                        ),
                                                        Text(
                                                          flowdoc
                                                              .data()[
                                                                  'commentcount']
                                                              .toString(),
                                                          style: mystyle(18),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        InkWell(
                                                          onTap: () => likepost(
                                                              flowdoc.data()[
                                                                  'id']),
                                                          child: flowdoc
                                                                  .data()[
                                                                      'likes']
                                                                  .contains(uid)
                                                              ? Icon(
                                                                  Icons
                                                                      .favorite,
                                                                  color: Colors
                                                                      .red,
                                                                )
                                                              : Icon(Icons
                                                                  .favorite_border),
                                                        ),
                                                        SizedBox(
                                                          width: 10.0,
                                                        ),
                                                        Text(
                                                          flowdoc
                                                              .data()['likes']
                                                              .length
                                                              .toString(),
                                                          style: mystyle(18),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        InkWell(
                                                            onTap: () => sharepost(
                                                                flowdoc.data()[
                                                                    'id'],
                                                                flowdoc.data()[
                                                                    'flow']),
                                                            child: Icon(
                                                                Icons.share)),
                                                        SizedBox(
                                                          width: 10.0,
                                                        ),
                                                        Text(
                                                          flowdoc
                                                              .data()['shares']
                                                              .toString(),
                                                          style: mystyle(18),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                              })
                        ],
                      ),
                    )
                  ],
                ),
              )
            : Center(child: CircularProgressIndicator()));
  }
}
