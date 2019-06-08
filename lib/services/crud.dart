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


  getDataFromUserFromDocument() async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return await Firestore.instance.collection('user').document(user.uid).get();
  }

  getDataFromUserFromDocumentWithID(userID) async{
    return await Firestore.instance.collection('user').document(userID).get();
  }

  getDataFromClubFromDocument() async{
    return await Firestore.instance.collection('club').getDocuments();
  }

  getDataFromUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return await Firestore.instance
        .collection('user')
        .document(user.uid)
        .snapshots();
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


 createOrUpdateUserData(Map<String, dynamic> userDataMap) async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
//    print('USERID ' + user.uid);
    DocumentReference ref = Firestore.instance.collection('user').document(user.uid);
    return ref.setData(userDataMap, merge: true);
    
  }

  updateUserDataWithUserID(userID, Map<String, dynamic> userDataMap) async{
    DocumentReference ref = Firestore.instance.collection('user').document(userID);
    return ref.setData(userDataMap, merge: true);

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
