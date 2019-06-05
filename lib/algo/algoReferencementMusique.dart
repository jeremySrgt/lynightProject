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


    });

    var listClubFromDatabase = [];

    for(int i=0; i<= 2; i++) {
      if (dataClubFromBDD != null) {
        var clubI = dataClubFromBDD[i].data;

        listClubFromDatabase.add(clubI);

      }
    }
    print(listClubFromDatabase.length);
    return listClubFromDatabase;
  }

  getMusicsOfClubMap(){
    var listMapMusicClub = [];
    Map<dynamic, dynamic> clubMap;
    if(getClubMusic() != null) {
      for (int i = 0; i < getClubMusic().length; i++) {

        List clubMusicList = getClubMusic();
        var club1 = clubMusicList[i];

        clubMap = club1['musics'];

        listMapMusicClub.add(clubMap);
      }

      return listMapMusicClub;

    }
  }

  getClubName(){
    List<String> listNameClub = [];
    if(getClubMusic() != null){
      var clubNameForReal;
      for(int i=0; i<getClubMusic().length; i++){
        var clubName;
        clubName = getClubMusic()[i];
        clubNameForReal = clubName['name'];

        listNameClub.add(clubNameForReal);

      }

      return listNameClub;

    }
  }






  List<String> compareMusic() {
    final List<String> bestClub = []; //club retenu pour la liste à retourner

    print('==================');
    print('Valru de getMusic : ');
    print(getMusicsOfClubMap());
    List<dynamic> getMusic = [{populaire: true, rap: false, rock: true, electro: false, rnb: false, trans: true}, {populaire: false, rap: false, rock: false, electro: true, rnb : true, trans: true}, {populaire: false, rap: true, rock: true, electro: true, rnb: true, trans: false}];
    getMusic = getMusicsOfClubMap();
    print(getMusic);
    print('==================');


    for (int i = 0; i < getMusic.length ; i++) {


      if (getMusic != null) {

        Map<dynamic, dynamic> mapOfMusicFromList = getMusic[i];
        List<String> nameOfClubList = getClubName();


        if ( (mapOfUserMusics['populaire'] == mapOfMusicFromList['populaire']) && (mapOfUserMusics['populaire'] == true) ) {
          print('debut de la boucle de verif de style de music');
          print('*********************');
          print('Les deux il kiffe populaire');
          bestClub.add(nameOfClubList[i]);
          print('Valur après ajout de populaire');
          print(bestClub);
          //return bestClub;
        } else {
          if((mapOfUserMusics['electro'] == mapOfMusicFromList['electro']) && (mapOfUserMusics['electro'] == true)){
            print('*****************');
            print('ils aiment le electro tout les 2 ');
            bestClub.add(nameOfClubList[i]);
            print('Valur après ajout de electro');
            print(bestClub);
          }else{
            if((mapOfUserMusics['rap'] == mapOfMusicFromList['rap']) && (mapOfUserMusics['rap'] == true)) {
              print('*****************');
              print('ils aiment le rap tout les 2 ');
              bestClub.add(nameOfClubList[i]);
              print('Valur après ajout de rap');
              print(bestClub);
            }else{
              if((mapOfUserMusics['rnb'] == mapOfMusicFromList['rnb']) && (mapOfUserMusics['rnb'] == true)) {
                print('*****************');
                print('ils aiment le rnb tout les 2 ');
                bestClub.add(nameOfClubList[i]);
                print('Valur après ajout de rnb');
                print(bestClub);
              }else{
                if((mapOfUserMusics['rock'] == mapOfMusicFromList['rock']) && (mapOfUserMusics['rock'] == true)) {
                  print('*****************');
                  print('ils aiment le rock tout les 2 ');
                  bestClub.add(nameOfClubList[i]);
                  print('Valur après ajout de rock');
                  print(bestClub);
                }else{
                  if((mapOfUserMusics['trans'] == mapOfMusicFromList['trans']) && (mapOfUserMusics['trans'] == true)) {
                    print('*****************');
                    print('ils aiment la trans tout les 2 ');
                    bestClub.add(nameOfClubList[i]);
                    print('Valur après ajout de trans');
                    print(bestClub);
                  }
                }
              }

            }
              print('Valeur de bestclub quoi quil arrive');
            print(bestClub);
            print('il aime ni electro ni populaire');
          }
        }
        print('--------------------------------------------------');

      }

    }
    return bestClub;

  }
}
