import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lynight/services/crud.dart';
import 'package:firebase_auth/firebase_auth.dart';




class SelectProfilPicture extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SelectProfilPictureState();
  }
}


class _SelectProfilPictureState extends State<SelectProfilPicture>{

  File newProfilPic;
  CrudMethods crudObj = new CrudMethods();


  updateProfilPicture(picUrl){
    Map<String, dynamic> userMap = {'picture': picUrl};
    crudObj.createOrUpdateUserData(userMap);
  }


  Future getImage() async{
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      newProfilPic = tempImage;
    });
  }

  uploadImage() async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(
        'profilePics/${user.uid}.jpg'
    );
    final StorageUploadTask task = firebaseStorageRef.putFile(newProfilPic);
    var downloadUrl = await (await task.onComplete).ref.getDownloadURL();
    var url = downloadUrl.toString();
    updateProfilPicture(url);
    Navigator.pop(context);
  }

  Widget enableUpload(){
    return Container(
      child: Column(
        children: <Widget>[
          Image.file(newProfilPic,height: 300, width: 300,),
          RaisedButton(
            child: Text('Upload'),
            onPressed: uploadImage,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Nouvelle image de profil'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Changer photo profil',
        child: Icon(Icons.add),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              child: newProfilPic == null ? Text('selectionnez une image'): enableUpload(),
            )
          ],
        ),
      ),
    );
  }
}




