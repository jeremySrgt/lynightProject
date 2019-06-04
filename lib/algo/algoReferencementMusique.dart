import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:lynight/services/crud.dart';
import 'package:lynight/nightCubPage/nightClubProfile.dart';

/*class AlgoMusicReference extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AlgoMusicReference();
  }
}*/

class AlgoMusicReference {
  CrudMethods crudObj = new CrudMethods();
  Stream club;
  final user;
  //Map<dynamic, dynamic> userMusic;
  Map<dynamic, dynamic> mapOfUserMusics;
  bool electro = false;
  bool rap = false;
  bool rnb = false;
  bool populaire = false;
  bool rock = false;
  bool trans = false;

  List<DocumentSnapshot> dataClubFromBDD;


  AlgoMusicReference({
    this.user,
    this.mapOfUserMusics
  });

  Map<dynamic, dynamic> test = {} ;

  getUserMusic(){
     crudObj.getDataFromUserFromDocument().then((value){ // correspond à await Firestore.instance.collection('user').document(user.uid).get();
      Map<String,dynamic> dataMap = value.data; // retourne la Map des données de l'utilisateur correspondant à uid passé dans la methode venant du cruObj

      print('---------mmmmmmmm-----------------------------------------');
      print(dataMap['music']);
      print('-----------mmmmmm---------------------------------------');
      Map<dynamic, dynamic> userMusic = dataMap['music'];
      test.addAll(userMusic);
      return userMusic;

    });
  }

  getClubMusic(){
    crudObj.getDataFromClubFromDocument().then((value){ // correspond à await Firestore.instance.collection('user').document(user.uid).get();
      dataClubFromBDD = value.documents;

      //for(int i=0; i< ds.length; i++){
       // Map<String,dynamic> clubMap = ds[0].data; // retourne la Map des données de l'utilisateur correspondant à uid passé dans la methode venant du cruObj
      //}

      //return this.clubMusic = dataMap['musics'];

    });
    for(int i=0; i< 5; i++) {
      if (dataClubFromBDD != null) {
        var clubI = dataClubFromBDD[i].data;
        //print('--------------------------------------------------');
        //print(clubI);
        //print(clubMap);
        print('--------------------------------------------------');
        print(clubI);
        print('--------------------------------------------------');
        i++;
        return clubI;
      }
    }
  }

  getMusicsOfClubMap(){
    Map<dynamic,dynamic> clubMap = getClubMusic()['musics'];
    return clubMap;

  }

  getClubName(){
    String clubName;
    clubName = getClubMusic()['name'];
    return clubName;
  }





  final List bestClub = []; //club retenu pour la liste à retourner

  List compareMusic() {

    for (int i = 0; i < 5 ; i++) {
      if (getClubMusic() != null) {
        print('--------------------------------------------------');
        print('Valeur de user : ');
        print(mapOfUserMusics);
        print('--------------------------------------------------');

        if ( (mapOfUserMusics['populaire'] == getMusicsOfClubMap()['populaire']) && (mapOfUserMusics['populaire'] == true) ) {
          print('Les deux il kiffe populaire sa mère');
          bestClub.add(getClubName());
          print('Valur après ajout inchallah');
          print(bestClub);
          //return bestClub;
        } else {
          print('il aime pas lelectro');
        }
        print('--------------------------------------------------');

        i++;
      }
      if (getClubMusic() != null) {
        print('--------------------------------------------------');
        print('Valeur de user : ');
        print(mapOfUserMusics);
        print('--------------------------------------------------');

        if ( (mapOfUserMusics['populaire'] == getMusicsOfClubMap()['populaire']) && (mapOfUserMusics['populaire'] == true) ) {
          print('Les deux il kiffe populaire sa mère');
          bestClub.add(getClubName());
          print('Valur après ajout inchallah');
          print(bestClub);
          //return bestClub;
        } else {
          print('il aime pas lelectro');
        }
        print('--------------------------------------------------');

        i++;
      }
      return bestClub;
    }
  }
}
