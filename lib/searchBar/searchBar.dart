import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lynight/searchBar/searchService.dart';
import 'package:lynight/nightCubPage/nightClubProfile.dart';

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => new _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  var queryResultSet = []; //Ajoute les data et ID en fonction du searchkey
  var resultID = [];

  var tempSearchStore =
      []; //Ajoute les data et les ID en fonction de ce qui suit le searchkey
  var tempID = [];

  bool nameClubEmpty = false;
  List<String> nameClub = [];

  var allClubs = Firestore.instance.collection('club').getDocuments();
  var allClubsDisplay = [];
  var allClubID = [];

  bool electro = false;
  bool rap = false;
  bool rnb = false;
  bool populaire = false;
  bool rock = false;
  bool trans = false;

  final strController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    strController.dispose();
    super.dispose();
  }

  initiateSearch(value) {
    //Est appelé lorsque l'on tape qqch dans la searchBar
    if (strController.text.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
        resultID = [];
        tempID = [];
        nameClub = [];
        allClubsDisplay = [];
        allClubID = [];
      });
      allClubs.then((QuerySnapshot docs) {
        for (int l = 0; l < docs.documents.length; l++) {
          allClubsDisplay.add(docs.documents[l].data);
          allClubID.add(docs.documents[l].documentID);
        }
      });
    }

    if (queryResultSet.length == 0 && value.length == 1) {
      SearchService().searchByName(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.documents.length; ++i) {
          queryResultSet.add(docs.documents[i].data);
          resultID.add(docs.documents[i].documentID);
        }
      });
    } else {
      tempSearchStore = [];
      tempID = [];
      setState(() {
        nameClub = [];
      });
      for (int j = 0; j < queryResultSet.length; j++) {
        if (queryResultSet[j]['name']
            .toUpperCase()
            .contains(value.toUpperCase())) {
          setState(() {
            tempSearchStore.add(queryResultSet[j]);
            tempID.add(resultID[j]);
            nameClub.add(queryResultSet[j]['name']);
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String val = "";
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            color: Colors.white,
            child: Column(children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.white,
                    border: Border.all(color: Colors.deepPurpleAccent)),
                child: ListTile(
                  leading: Icon(
                    Icons.search,
                    color: Theme.of(context).accentColor,
                  ),
                  title: TextField(
                    controller: strController,
                    onChanged: (val) {
                      initiateSearch(strController.text);
                      //inputSearch = val;
                    },
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        hintText: "Turn up",
                        hintStyle:
                            TextStyle(color: Colors.grey, fontSize: 16.5),
                        border: InputBorder.none),
                  ),
                ),
              ),
              resultSearch(),
            ]),
          ),
        ));
  }

  Widget resultSearch() {
    if (strController.text.length == 0) {
      //initiateSearch(strController.text);
      if (allClubsDisplay.isEmpty) {
        allClubs.then((QuerySnapshot docs) {
          for (int l = 0; l < docs.documents.length; l++) {
            allClubsDisplay.add(docs.documents[l].data);
            allClubID.add(docs.documents[l].documentID);
          }
        });
      }
      return Expanded(
          child: Container(
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: allClubsDisplay.length,
                  itemBuilder: (context, index) {
                    Map<dynamic, dynamic> musicMap = allClubsDisplay[index]['musics'];

                    return Card(
                      color: Colors.transparent,
                      elevation: 12.0,
                      margin: new EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 6.0),
                      child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color.fromRGBO(	212, 63, 141, 1),
                                    Color.fromRGBO(		2, 80, 197, 1)
                                  ]),
                              //color: Theme.of(context).primaryColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25))),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NightClubProfile(
                                          documentID: allClubID[index])));
                            },
                            child: Center(
                              child: Container(
                                height: 80,
                                padding: EdgeInsets.only(
                                    left: 5.0, right: 5.0, top: 2.0, bottom: 1),
                                child: Column(children: [
                                  ListTile(
                                    leading: ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(100.0),
                                      child: Image.network(
                                        allClubsDisplay[index]['pictures'][0],
                                        fit: BoxFit.cover,
                                        width: 60.0,
                                        height: 150.0,
                                      ),
                                    ),
                                    title: Text(allClubsDisplay[index]['name'],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold)),
                                    subtitle: Row(children: <Widget>[
                                      Icon(
                                        Icons.music_note,
                                        color: Colors.blue,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          musicMap['electro'] == true
                                              ? Text('Electro ', style: TextStyle(color: Colors.white),)
                                              : Container(),
                                          musicMap['populaire'] == true
                                              ? Text('Populaire ', style: TextStyle(color: Colors.white),)
                                              : Container(),
                                          musicMap['rap'] == true ? Text('Rap ', style: TextStyle(color: Colors.white),) : Container(),
                                          musicMap['rnb'] == true ? Text('RnB ', style: TextStyle(color: Colors.white),) : Container(),
                                          musicMap['rock'] == true ? Text('Rock ', style: TextStyle(color: Colors.white),) : Container(),
                                          musicMap['trans'] == true
                                              ? Text('Psytrans ', style: TextStyle(color: Colors.white),)
                                              : Container(),
                                        ],
                                      )
                                    ]),
                                    trailing: Icon(Icons.arrow_forward_ios,
                                        color: Colors.white),
                                  ),
                                ]),
                              ),
                            ),
                          )),
                    );
                  })));
    }
    if (strController.text.length >= 1) {
      setState(() {
        allClubsDisplay = [];
        allClubID = [];
      });
    }


    setState(() {
      nameClubEmpty = false;
    });


    if (strController.text.length >= 1 && nameClub.isEmpty) {
      setState(() {
        nameClubEmpty = true;
      });
    }
    if (nameClubEmpty == true) {
      return Expanded(
          child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Text(
                "Soit t'as mal écrit, soit a éxiste pas",
                style: TextStyle(
                  color: Colors.blueGrey,
                ),
              )));
    }


    return Expanded(
        child: Container(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: tempSearchStore.length,
                itemBuilder: (context, index) {
                  Map<dynamic, dynamic> musicMap = tempSearchStore[index]['musics'];

                  return Card(
                    color: Colors.transparent,
                    elevation: 12.0,
                    margin: new EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 6.0),
                    child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.bottomRight,
                                end: Alignment.topLeft,
                                colors: [
                                  Colors.blue,
                                  Colors.deepPurpleAccent,
                                  Colors.purple
                                ]),
                            //color: Theme.of(context).primaryColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(25))),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NightClubProfile(
                                        documentID: tempID[index])));
                          },
                          child: Center(
                            child: Container(
                              height: 80,
                              padding: EdgeInsets.only(
                                  left: 5.0, right: 5.0, top: 2.0, bottom: 1),
                              child: Column(children: [
                                ListTile(
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(100.0),
                                    child: Image.network(
                                      tempSearchStore[index]['pictures'][0],
                                      fit: BoxFit.cover,
                                      width: 60.0,
                                      height: 150.0,
                                    ),
                                  ),
                                  title: Text(tempSearchStore[index]['name'],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold)),
                                  subtitle: Row(children: <Widget>[
                                    Icon(
                                      Icons.music_note,
                                      color: Colors.blue,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        musicMap['electro'] == true
                                            ? Text('Electro ', style: TextStyle(color: Colors.white),)
                                            : Container(),
                                        musicMap['populaire'] == true
                                            ? Text('Populaire ', style: TextStyle(color: Colors.white),)
                                            : Container(),
                                        musicMap['rap'] == true ? Text('Rap ', style: TextStyle(color: Colors.white),) : Container(),
                                        musicMap['rnb'] == true ? Text('RnB ', style: TextStyle(color: Colors.white),) : Container(),
                                        musicMap['rock'] == true ? Text('Rock ', style: TextStyle(color: Colors.white),) : Container(),
                                        musicMap['trans'] == true
                                            ? Text('Psytrans ', style: TextStyle(color: Colors.white),)
                                            : Container(),
                                      ],
                                    )
                                  ]),
                                  trailing: Icon(Icons.arrow_forward_ios,
                                      color: Colors.white),
                                ),
                              ]),
                            ),
                          ),
                        )),
                  );
                }))); //Retourne la listView normale (en tapant dans la recherche)
  }
}
