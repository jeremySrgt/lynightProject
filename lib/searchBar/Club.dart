import 'package:flutter/material.dart';

class Club {
  String title;
  int nbLikes;
  String songsType;
  AssetImage clubImage;

  Club({this.title, this.nbLikes, this.songsType, this.clubImage});
}

List<Club> getClub() {
  return [
    Club(
      title: "Wanderlust",
      nbLikes: 5,
      songsType: "HipHop, RnB",
      clubImage: AssetImage('assets/nightClub.jpg'),
    ),
    Club(
      title: "AuDD",
      nbLikes: 4,
      songsType: "QLF, Faya",
      clubImage: AssetImage('assets/nightClub.jpg'),
    ),
    Club(
      title: "ESIEE",
      nbLikes: 1,
      songsType: "Electro, HipHop",
      clubImage: AssetImage('assets/nightClub.jpg'),
    ),
    Club(
      title: "ChezJerem",
      nbLikes: 0,
      songsType: "Justin Bieber",
      clubImage: AssetImage('assets/nightClub.jpg'),
    ),
    Club(
      title: "Club Haussmann",
      nbLikes: 4,
      songsType: "Généraliste",
      clubImage: AssetImage('assets/nightClub.jpg'),
    ),
    Club(
      title: "BNK",
      nbLikes: 4,
      songsType: "Techno, Trans",
      clubImage: AssetImage('assets/nightClub.jpg'),
    ),
    Club(
      title: "Nuits Fauves",
      nbLikes: 3,
      songsType: "Techno, Trans",
      clubImage: AssetImage('assets/nightClub.jpg'),
    ),
    Club(
      title: "Coachella",
      nbLikes: 5,
      songsType: "Le feeeu",
      clubImage: AssetImage('assets/nightClub.jpg'),
    ),
    Club(
      title: "Kelly Kelly NightClub",
      nbLikes: 5,
      songsType: "Diams, Zaho",
      clubImage: AssetImage('assets/nightClub.jpg'),
    ),
  ];
}
