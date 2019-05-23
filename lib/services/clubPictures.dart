import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class ClubPicture {
  final String clubID;

  ClubPicture({this.clubID});

  getPicturesList() async {
//    DocumentSnapshot document = await Firestore.instance.collection('club').document(clubID).get();
//    print('-----');
//    print(document['pictures']);

  return await Firestore.instance.collection('club').document(clubID).get();



//    document.get().then((document) {
//      List<String> pictures = List.from(document['pictures']);
//      print('-------');
//      print(pictures);
//    });
  }
}