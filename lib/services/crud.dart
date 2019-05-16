import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class CrudMethods {
  bool isLoggedIn() {
    if (FirebaseAuth.instance.currentUser() != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> addData(collection, data) async {
    if (isLoggedIn()) {
      Firestore.instance.collection(collection).add(data).catchError((e) {
        print(e);
      });
    } else {
      print('il faut etre loggé pour ajouter des données');
    }
  }

  getData(collection) async {
    return await Firestore.instance.collection(collection).snapshots();
  }

  updateData(collection, selectedDoc, newValues) {
    Firestore.instance
        .collection(collection)
        .document(selectedDoc)
        .updateData(newValues)
        .catchError((e) {
      print(e);
    });
  }

  deleteData(collection, docId) {
    Firestore.instance
        .collection(collection)
        .document(docId)
        .delete()
        .catchError((e) {
      print(e);
    });
  }
}
