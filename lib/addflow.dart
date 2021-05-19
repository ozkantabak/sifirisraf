import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sifirisraf/utils/variables.dart';

class AddFlow extends StatefulWidget {
  @override
  _AddFlowState createState() => _AddFlowState();
}

class _AddFlowState extends State<AddFlow> {
  File imagepath;
  TextEditingController flowcontroller = TextEditingController();
  bool uploading = false;

  pickImage(ImageSource imgsource) async {
    final image = await ImagePicker().getImage(source: imgsource);
    setState(() {
      imagepath = File(image.path);
    });
    Navigator.pop(context);
  }

  optionsdialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: [
              SimpleDialogOption(
                onPressed: () => pickImage(ImageSource.gallery),
                child: Text(
                  "Galeriden seç",
                  style: mystyle(20),
                ),
              ),
              SimpleDialogOption(
                onPressed: () => pickImage(ImageSource.camera),
                child: Text(
                  "Kameraya bağlan",
                  style: mystyle(20),
                ),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Geri",
                  style: mystyle(20),
                ),
              )
            ],
          );
        });
  }

  uploadimage(String id) async {
    UploadTask uploadTask =
        flowpictures.child(id).putFile(imagepath);
    TaskSnapshot storageTaskSnapshot =
        await uploadTask;
    String downloadurl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadurl;
  }

  postflow() async {
    setState(() {
      uploading = true;
    });
    var firebaseuser = FirebaseAuth.instance.currentUser;
    DocumentSnapshot userdoc =
        await usercollection.doc(firebaseuser.uid).get();
    var alldocuments = await flowcollection.get();
    int length = alldocuments.docs.length;
    // 3 conditions
    // only flow
    if (flowcontroller.text != '' && imagepath == null) {
      flowcollection.doc('Flow $length').set({
        'username': userdoc.data()['username'],
        'profilepic': userdoc.data()['profilepic'],
        'uid': firebaseuser.uid,
        'id': 'Flow $length',
        'flow': flowcontroller.text,
        'likes': [],
        'commentcount': 0,
        'shares': 0,
        'type': 1
      });
      Navigator.pop(context);
    }
    // only image
    if (flowcontroller.text == '' && imagepath != null) {
      String imageurl = await uploadimage('Flow $length');
      flowcollection.doc('Flow $length').set({
        'username': userdoc.data()['username'],
        'profilepic': userdoc.data()['profilepic'],
        'uid': firebaseuser.uid,
        'id': 'Flow $length',
        'image': imageurl,
        'likes': [],
        'commentcount': 0,
        'shares': 0,
        'type': 2
      });
      Navigator.pop(context);
    }
    // flow and image
    if (flowcontroller.text != '' && imagepath != null) {
      String imageurl = await uploadimage('Flow $length');
      flowcollection.doc('Flow $length').set({
        'username': userdoc.data()['username'],
        'profilepic': userdoc.data()['profilepic'],
        'uid': firebaseuser.uid,
        'id': 'Flow $length',
        'flow': flowcontroller.text,
        'image': imageurl,
        'likes': [],
        'commentcount': 0,
        'shares': 0,
        'type': 3
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => postflow(),
        child: Icon(
          Icons.publish,
          size: 32,
        ),
      ),
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back, size: 32),
        ),
        centerTitle: true,
        title: Text(
          "Gönderi Ekle",
          style: mystyle(20),
        ),
        actions: [
          InkWell(
            onTap: () => optionsdialog(),
            child: Icon(
              Icons.photo,
              size: 40,
            ),
          )
        ],
      ),
      body: uploading == false ? Column(
        children: [
          Expanded(
            child: TextField(
              controller: flowcontroller,
              maxLines: null,
              style: mystyle(20),
              decoration: InputDecoration(
                  labelText: "Ne düşünüyorsun?",
                  labelStyle: mystyle(25),
                  border: InputBorder.none),
            ),
          ),
          Expanded(
            child: TextField(
              controller: flowcontroller,
              maxLines: null,
              style: mystyle(20),
              decoration: InputDecoration(
                  labelText: "Kategori seç:",
                  labelStyle: mystyle(25),
                  border: InputBorder.none),
            ),
          ),
          imagepath == null
              ? Container()
              : MediaQuery.of(context).viewInsets.bottom > 0
                  ? Container()
                  : Image(
                      width: 200,
                      height: 200,
                      image: FileImage(imagepath),
                    )
        ],
      ) : Center(
        child: Text("Karşıya Yükleniyor...",style: mystyle(25),),
      ),
    );
  }
}
