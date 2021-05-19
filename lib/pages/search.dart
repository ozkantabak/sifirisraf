import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sifirisraf/pages/viewuser.dart';
import 'package:sifirisraf/utils/variables.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Future<QuerySnapshot> searchuserresult;
  searchuser(String s) {
    var users = usercollection
        .where('username', isGreaterThanOrEqualTo: s)
        .get();

    setState(() {
      searchuserresult = users;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffECE5DA),
        appBar: AppBar(
          title: TextFormField(
            decoration: InputDecoration(
                filled: true,
                hintText: "Aradığınız kullanıcı...",
                hintStyle: mystyle(18)),
            onFieldSubmitted: searchuser,
          ),
        ),
        body: searchuserresult == null
            ? Center(
                child: Text(
                  "Aranılan kullanıcı...",
                  style: mystyle(30),
                ),
              )
            : FutureBuilder(
                future: searchuserresult,
                builder: (BuildContext context, snapshot) {
                  if(snapshot.data == null) {
                    return CircularProgressIndicator();
                  }
                  if (!snapshot.hasData) {
                    Center(child: CircularProgressIndicator());
                  }

                  return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot user = snapshot.data.docs[index];
                      return Card(
                        elevation: 8.0,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(user['profilepic']),
                          ),
                          title: Text(
                            user['username'],
                            style: mystyle(25),
                          ),
                          trailing: InkWell(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ViewUser(user['uid']))),
                            child: Container(
                              width: 90,
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.greenAccent),
                              child: Center(
                                child: Text("Görüntüle", style: mystyle(15)),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ));
  }
}
