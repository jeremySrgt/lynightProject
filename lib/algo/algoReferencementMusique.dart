import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lynight/services/crud.dart';


//TODO l'algo est trop lourd et tourne en front
//TODO on peut utiliser algolia pour nous renvoyer une liste de club qui match les préférences de l'utilisateur
//TODO l'appli serait plus rapide et on pourrait supprimer cette class


class AlgoMusicReference {
  CrudMethods crudObj = new CrudMethods();
  Stream club;
  Map<dynamic, dynamic> mapOfUserMusics;
  bool electro = false;
  bool rap = false;
  bool rnb = false;
  bool populaire = false;
  bool rock = false;
  bool trans = false;
  int numberOfSameMusics= 0;


  List<DocumentSnapshot> dataClubFromBDD;
  final snapClub;

  // On demande une map des music de l'utilisateur et la snapshot
  AlgoMusicReference({
    @required this.mapOfUserMusics,
    @required this.snapClub,
  });

  Map<dynamic, dynamic> test = {};

  //retourne une liste contenant une map de chaque club
  //Faut changer la valeur de la boucle for sur lequel ça tourne
  getClubMusic() {
    crudObj.getDataFromClubFromDocument().then((value) {
      // correspond à await Firestore.instance.collection('user').document(user.uid).get();
      dataClubFromBDD = value.documents;
    });

    //print(dataClubFromBDD);

    var listClubFromDatabase = [];

    int numberOfClub = 0;
    if (snapClub != null) {
      numberOfClub = snapClub.length;
    }

    for (int i = 0; i < numberOfClub; i++) {
      if (snapClub != null) {
        var clubI = snapClub[i].data;
        //print(snapClub[i].documentID);

        listClubFromDatabase.add(clubI);
      }
    }
    //print(listClubFromDatabase.length);
    return listClubFromDatabase;
  }

  // retourne une list de map des music de l'utilisateur
  // forme = [{populaire : true, electro : ...}, {...},...]
  getMusicsOfClubMap() {
    var listMapMusicClub = [];
    Map<dynamic, dynamic> clubMap;
    if (getClubMusic() != null) {
      for (int i = 0; i < getClubMusic().length; i++) {
        List clubMusicList = getClubMusic();
        var club1 = clubMusicList[i];

        clubMap = club1['musics'];

        listMapMusicClub.add(clubMap);
      }

      return listMapMusicClub;
    }
  }

  // retourne une liste de String comportant tout les noms des club
  getClubName() {
    List<String> listNameClub = [];
    if (getClubMusic() != null) {
      var clubNameForReal;
      for (int i = 0; i < getClubMusic().length; i++) {
        var clubName;
        clubName = getClubMusic()[i];
        clubNameForReal = clubName['name'];

        listNameClub.add(clubNameForReal);
      }

      return listNameClub;
    }
  }

  Map<String, int> creationMapOfMusicAndLiked(){
    List<dynamic> getMusic = getMusicsOfClubMap();
    Map<String, int> club = {};
      if(snapClub != null) {
        for (int i = 0; i < getMusic.length; i++) {
          if (snapClub[i].documentID != null) {
            club[snapClub[i].documentID] = 0;
          }
        }
        return club;
      }

  }


  List<List> listNumberOfMusicLiked(){
    var m = 5;
    var n = 2;
    var x = new List.generate(m, (_) => new List(n));
    print('diezbdhuezbhudbezhubdhuzebdhezhudbezhudbeuz');
    print(x);
    return x;
  }

  Map<String, int> returnOneClubAndOneMatched(key, values){
    var valuesInCompetition = 0;
    Map<String, int> keyValues = {key : values};


    if(valuesInCompetition < values){
      valuesInCompetition = values;

    }


    //print('club :' );
    //print(key);
    //print('avec la valeur : ');
    //print(values);
    //print(keyValues);
  }

  // Compare les 2 map
  List<String> compareMusic() {
    Map<String, int> mapOfClubAndMatch = creationMapOfMusicAndLiked();
    //print('dheiuzduiezidez');
    //print(mapOfClubAndMatch);

    final List<String> bestClub = []; //club retenu pour la liste à retourner

    //print('==================');
    //print('Valeur de getMusic : ');
    //print(getMusicsOfClubMap());
    List<dynamic> getMusic = [
      {
        populaire: true,
        rap: false,
        rock: true,
        electro: false,
        rnb: false,
        trans: true
      },
      {
        populaire: false,
        rap: false,
        rock: false,
        electro: true,
        rnb: true,
        trans: true
      },
      {
        populaire: false,
        rap: true,
        rock: true,
        electro: true,
        rnb: true,
        trans: false
      }
    ];
    getMusic = getMusicsOfClubMap();
    //print(getMusic);
    //print('==================');




    // Va boucler sur la taille de la liste complete
    for (int i = 0; i < getMusic.length; i++) {
      if (mapOfUserMusics != null) {
        if (getMusic != null) {
          Map<dynamic, dynamic> mapOfMusicFromList = getMusic[i];

          // Va verifier tout les style de musique d'abord si ils ont là même valeur et ensuite si il retourne true
          // Si c'est le cas on va l'ajouter à la liste qui sera retourné

          if ((mapOfUserMusics['populaire'] == mapOfMusicFromList['populaire']) && (mapOfUserMusics['populaire'] == true)) {
           // listNumberOfMusicLiked();
            //print('debut de la boucle de verif de style de music');
            //print('*********************');
            // print('Les deux il kiffe populaire');


            var numberOfMatchForPoular = mapOfClubAndMatch['${snapClub[i].documentID}'];
            //print('---------------------');
            //print('number of match au debut, devrait etre 0  ');
            //print(numberOfMatchForPoular);
            if(numberOfMatchForPoular != null) {
              numberOfMatchForPoular = numberOfMatchForPoular + 1;
              mapOfClubAndMatch['${snapClub[i].documentID}'] = numberOfMatchForPoular;
              //print('number of match :;;;;;;;;;;;;;; ');
              //print(numberOfMatchForPoular);
              //print(mapOfClubAndMatch);
            }

            //print('++++++++++++++++++++++++');
            //print('si popular match');
            //print(mapOfClubAndMatch);

          }
            if ((mapOfUserMusics['electro'] == mapOfMusicFromList['electro']) && (mapOfUserMusics['electro'] == true)) {
              //print('*****************');
              //print('ils aiment le electro tout les 2 ');

              var numberOfMatchForElectro = mapOfClubAndMatch['${snapClub[i].documentID}'];
              //print('---------------------');
              //print('number of match au debut, devrait etre 0  ');
              //print(numberOfMatchForElectro);
              if(numberOfMatchForElectro != null) {
                numberOfMatchForElectro = numberOfMatchForElectro + 1;
                mapOfClubAndMatch['${snapClub[i].documentID}'] = numberOfMatchForElectro;
                //print('number of match :;;;;;;;;;;;;;; ');
                //print(numberOfMatchForElectro);
                //print(mapOfClubAndMatch);
              }
              //print('***************');
              //print('si pas electro');
              //print(mapOfClubAndMatch);


            }
              if ((mapOfUserMusics['rap'] == mapOfMusicFromList['rap']) && (mapOfUserMusics['rap'] == true)) {
                //print('*****************');
                //print('ils aiment le rap tout les 2 ');


                var numberOfMatchForRap = mapOfClubAndMatch['${snapClub[i].documentID}'];
                //print('---------------------');
                //print('number of match au debut, devrait etre 0  ');
                //print(numberOfMatchForRap);
                if(numberOfMatchForRap != null) {
                  numberOfMatchForRap = numberOfMatchForRap+ 1;
                  mapOfClubAndMatch['${snapClub[i].documentID}'] = numberOfMatchForRap;
                  //print('number of match :;;;;;;;;;;;;;; ');
                  //print(numberOfMatchForRap);
                  //print('si rap : ');
                  //print(mapOfClubAndMatch);
                }
                //print('***************');
                //print('si pas rap');
                //print(mapOfClubAndMatch);


              }
                if ((mapOfUserMusics['rnb'] == mapOfMusicFromList['rnb']) && (mapOfUserMusics['rnb'] == true)) {
                  //print('*****************');
                  //print('ils aiment le rnb tout les 2 ');

                  var numberOfMatchForRnb = mapOfClubAndMatch['${snapClub[i].documentID}'];
                  //print('---------------------');
                  //print('number of match au debut, devrait etre 0  ');
                  //print(numberOfMatchForRnb);
                  if(numberOfMatchForRnb != null) {
                    numberOfMatchForRnb = numberOfMatchForRnb+ 1;
                    mapOfClubAndMatch['${snapClub[i].documentID}'] = numberOfMatchForRnb;
                    //print('number of match :;;;;;;;;;;;;;; ');
                    //print(numberOfMatchForRnb);
                    //print('si rnb : ');
                    //print(mapOfClubAndMatch);
                  }
                  //print('***************');
                  //print('si pas rnb');
                  //print(mapOfClubAndMatch);

                }
                  if ((mapOfUserMusics['rock'] == mapOfMusicFromList['rock']) && (mapOfUserMusics['rock'] == true)) {


                    var numberOfMatchForRock = mapOfClubAndMatch['${snapClub[i].documentID}'];
                    print('---------------------');
                    print('number of match au debut, devrait etre 0  ');
                    print(numberOfMatchForRock);
                    if(numberOfMatchForRock != null) {
                      numberOfMatchForRock = numberOfMatchForRock+ 1;
                      mapOfClubAndMatch['${snapClub[i].documentID}'] = numberOfMatchForRock;
                      //print('number of match :;;;;;;;;;;;;;; ');
                      //print(numberOfMatchForRock);
                      //print('si Rock : ');
                      //print(mapOfClubAndMatch);
                    }
                    //print('***************');
                    //print('si pas Rock');
                    //print(mapOfClubAndMatch);

                  }
                    if ((mapOfUserMusics['trans'] == mapOfMusicFromList['trans']) && (mapOfUserMusics['trans'] == true)) {
                      //print('*****************');
                      //print('ils aiment la trans tout les 2 ');

                      var numberOfMatchForTrans = mapOfClubAndMatch['${snapClub[i].documentID}'];
                      //print('---------------------');
                      //print('number of match au debut, devrait etre 0  ');
                      //print(numberOfMatchForTrans);
                      if(numberOfMatchForTrans != null) {
                        numberOfMatchForTrans = numberOfMatchForTrans+ 1;
                        mapOfClubAndMatch['${snapClub[i].documentID}'] = numberOfMatchForTrans;
                        //print('number of match :;;;;;;;;;;;;;; ');
                        //print(numberOfMatchForTrans);
                        //print('si Trans : ');
                        //print(mapOfClubAndMatch);
                      }
                      //print('***************');
                      //print('si pas Trans');
                      //print(mapOfClubAndMatch);


                      //print('Valur après ajout de trans');
                      //print(bestClub);
                    }

              //print('__________________________');
              //print('fin de la map avec les club');
              //print(mapOfClubAndMatch);
              //print('Le club ' +nameOfClubList[i] +'a aucun son en commun avec le user');
            }
          }

        }



if(mapOfClubAndMatch != null) {
  if (mapOfClubAndMatch.isNotEmpty) {
    var mapSortedInMatchedOrder = mapOfClubAndMatch.keys.toList(
        growable: false)
      ..sort((k1, k2) =>
          mapOfClubAndMatch[k2].compareTo(mapOfClubAndMatch[k1]));
    LinkedHashMap sortedMap = new LinkedHashMap
        .fromIterable(mapSortedInMatchedOrder, key: (k) => k,
        value: (k) => mapOfClubAndMatch[k]);
    //print('map tri&é peut etre --------------------');
    //print(sortedMap);
    if (mapSortedInMatchedOrder.isNotEmpty) {
      int lengthMap = mapSortedInMatchedOrder.length;
      List<String> bestClubFromMap = [];
      if (lengthMap >= 5) {
        int loopFor = 5;
        for (int i = 0; i < loopFor; i++) {
          String clubRetenu = mapSortedInMatchedOrder[i];
          //print('------------------');
          //print('en theorie devrait afficher le club retenu : ');
          //print(clubRetenu);
          bestClubFromMap.add(clubRetenu);
          //print(bestClubFromMap);
        }
      }
      return bestClubFromMap;
    }
  }
}else{
      print('club ps encore finit tourner');
      return null;
    }


  }
}
