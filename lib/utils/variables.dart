import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

mystyle(double size,[Color color,FontWeight fw]){
  return GoogleFonts.montserrat(fontSize: size, fontWeight: fw, color: color);
}

CollectionReference usercollection = FirebaseFirestore.instance.collection('users');
CollectionReference flowcollection = FirebaseFirestore.instance.collection('flows');
Reference flowpictures =
FirebaseStorage.instance.ref().child('flowpictures');
var exampleimage = 'https://pbs.twimg.com/profile_images/1086291310112358400/8kw06X93_400x400.jpg';