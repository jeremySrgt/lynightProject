import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/target_position.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class TutorialFocus {
  TutorialFocus(
      {@required this.key1, @required this.key2, @required this.key3});

  final GlobalKey key1;
  final GlobalKey key2;
  final GlobalKey key3;

  List<TargetFocus> targets = List();

  void initTutorialClass() {
    targets.add(TargetFocus(
        identify: "Target 1",
      targetPosition: TargetPosition(Size(-100.0, -100.0), Offset(400.0, 400.0)),
        contents: [
          ContentTarget(
              align: AlignContent.bottom,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Bienvenue sur Bloon !",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Bloon te permet de découvrir des lieux de sortie pour tes folles soirées parisiennes. La carte te permet de les trouver facilement. Le moyen de payer et reserver sa place sur l'appli arrive bientot !",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ))
        ]));

    targets.add(TargetFocus(identify: "Target 2", keyTarget: key1, contents: [
      ContentTarget(
          align: AlignContent.bottom,
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Découvre des nouveaux lieux !",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Cette section te permet de découvrir des boites de nuit à chaque fois que tu reviens sur cette page",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ))
    ]));

    targets.add(TargetFocus(identify: "Target 3", keyTarget: key2, contents: [
      ContentTarget(
          align: AlignContent.top,
          child: Container(
            padding: EdgeInsets.only(bottom: 150.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Des boites selectionnées pour toi !",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    "La section recommandé contient les boites que notre algorithme a selectionné spécialement pour toi :)",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ))
    ]));

    targets.add(TargetFocus(identify: "Target 4", keyTarget: key3, contents: [
      ContentTarget(
          align: AlignContent.bottom,
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Trouves ce qu'il te plait",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Biensur, le champ de recherche tu connais, tu trouveras facilement ce que tu cherche : une adresse, un nom, un style et c'est party",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ))
    ]));


  }

  List<TargetFocus> getTargetList() {
    return targets;
  }
}
