import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lynight/services/crud.dart';
import 'package:firebase_auth/firebase_auth.dart';




//FIXME TOUT CE QUI EST RELATIF AU COMPTE PRO A ETE DEPLACE DANS L'APP BLOON PRO

class UploadClubPictures extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _UploadClubPictures();
  }
}

class _UploadClubPictures extends State<UploadClubPictures> {
  bool _isLoading = false;
  File clubPicture;
  CrudMethods crudObj = new CrudMethods();

  updateProfilPicture(picUrl) {
    Map<String, dynamic> userMap = {'picture': picUrl};
    crudObj.createOrUpdateUserData(userMap);
  }

  Future getImageFromGallery() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      clubPicture = tempImage;
    });
  }

  Future getImageFromCamera() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      clubPicture = tempImage;
    });
  }

  uploadImage() async {
//    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child('clubPics/.jpg');
    final StorageUploadTask task = firebaseStorageRef.putFile(clubPicture);
    if (task.isInProgress) {
      setState(() {
        _isLoading = true;
      });
    }
    var downloadUrl = await (await task.onComplete).ref.getDownloadURL();
    var url = downloadUrl.toString();
    updateProfilPicture(url);
    setState(() {
      _isLoading = false;
    });
    Navigator.pop(context);
  }

  Widget enableUpload() {
    return Container(
      child: Column(
        children: <Widget>[
          Image.file(
            clubPicture,
            height: 200,
            width: 200,
          ),
          _isLoading == false
              ? Container(
            margin: EdgeInsets.only(top: 10.0),
            child: RaisedButton(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              child: Icon(
                Icons.done,
                color: Color(0xFF0fbc00),
              ),
              color: Color(0xFFe0fcdf),
              textColor: Colors.black87,
              onPressed: uploadImage,
            ),
          )
              : Container(margin: EdgeInsets.only(top: 18.0),child:CircularProgressIndicator()),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Container(
      child: Column(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 20.0),
                  child: clubPicture == null
                      ? Text('sélectionne une image')
                      : enableUpload(),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Icon(
                  Icons.folder,
                  color: Theme.of(context).primaryColor,
                ),
                color: Color(0xFFebdffc),
                textColor: Colors.black87,
                onPressed: getImageFromGallery,
              ),
              SizedBox(
                width: 25,
              ),
              RaisedButton(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Icon(
                  Icons.camera_alt,
                  color: Theme.of(context).primaryColor,
                ),
                color: Color(0xFFebdffc),
                textColor: Colors.black87,
                onPressed: getImageFromCamera,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
