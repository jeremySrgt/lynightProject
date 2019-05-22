import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class ClubPicture{
  final String clubID;
  ClubPicture({this.clubID});

  createDirectory() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child('clubPics/$clubID/test.jpg');
//    final StorageUploadTask task = firebaseStorageRef.putFile('../assets/boite.jpg');

  }

}