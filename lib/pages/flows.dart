import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sifirisraf/comment.dart';
import 'package:sifirisraf/utils/variables.dart';

import '../addflow.dart';

class FlowsPage extends StatefulWidget {
  @override
  _FlowsPageState createState() => _FlowsPageState();
}

class _FlowsPageState extends State<FlowsPage> {
  String uid;
  initState() {
    super.initState();
    getcurrentuseruid();
  }

  getcurrentuseruid() async {
    var firebaseuser = FirebaseAuth.instance.currentUser;
    setState(() {
      uid = firebaseuser.uid;
    });
  }

  likepost(String documentid) async {
    var firebaseuser = FirebaseAuth.instance.currentUser;
    DocumentSnapshot document = await flowcollection.doc(documentid).get();

    if (document['likes'].contains(firebaseuser.uid)) {
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
    DocumentSnapshot document = await flowcollection.doc(documentid).get();
    flowcollection
        .doc(documentid)
        .update({'shares': document['shares'] + 1});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddFlow())),
          child: Icon(Icons.add, size: 32),
        ),
        appBar: AppBar(
          /*actions: [
            Icon(Icons.star, size: 32),
          ],*/
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Sıfır İsraf",
                style: mystyle(20, Colors.white, FontWeight.w700),
              ),
              SizedBox(
                width: 5.0,
              ),
              Image(width: 45, height: 54, image: AssetImage('images/logo.png'))
            ],
          ),
        ),
        body: StreamBuilder(
            stream: flowcollection.snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }
              return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot flowdoc = snapshot.data.docs[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: NetworkImage(flowdoc.data()['profilepic']),
                        ),
                        title: Text(
                          flowdoc.data()['username'],
                          style: mystyle(20, Colors.black, FontWeight.w600),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (flowdoc.data()['type'] == 1)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    flowdoc.data()['flow'],
                                    style: mystyle(
                                        20, Colors.black, FontWeight.w400),
                                  ),
                                ),
                              if (flowdoc.data()['type'] == 2)
                                Image(image: NetworkImage(flowdoc['image'])),
                              if (flowdoc.data()['type'] == 3)
                                Column(
                                  children: [
                                    Text(
                                      flowdoc.data()['flow'],
                                      style: mystyle(
                                          20, Colors.black, FontWeight.w400),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Image(
                                        image: NetworkImage(flowdoc.data()['image'])),
                                  ],
                                ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=>CommentPage(flowdoc.data()['id']))),
                                        child: Icon(Icons.comment),
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Text(
                                        flowdoc.data()['commentcount'].toString(),
                                        style: mystyle(18),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () => likepost(flowdoc.data()['id']),
                                        child: flowdoc.data()['likes'].contains(uid)
                                            ? Icon(
                                                Icons.favorite,
                                                color: Colors.red,
                                              )
                                            : Icon(Icons.favorite_border),
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Text(
                                        flowdoc.data()['likes'].length.toString(),
                                        style: mystyle(18),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      InkWell(
                                          onTap: () => sharepost(
                                              flowdoc.data()['id'], flowdoc.data()['flow']),
                                          child: Icon(Icons.share)),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Text(
                                        flowdoc.data()['shares'].toString(),
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
            }));
  }
}
