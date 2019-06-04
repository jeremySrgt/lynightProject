import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lynight/searchBar/searchService.dart';
import 'package:lynight/nightCubPage/nightClubProfile.dart';

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => new _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  var queryResultSet = [];
  var tempSearchStore = [];
  var resultID = [];
  var tempID = [];
  List musicType;
  var i =0;
  bool emptyL;

  final strController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    strController.dispose();
    super.dispose();
  }

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
        resultID = [];
        tempID = [];
        emptyL = false;
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
      emptyL = false;
      for (int j = 0; j < queryResultSet.length; j++) {
        if (queryResultSet[j]['name'].toUpperCase().contains(value.toUpperCase())) {
          setState(() {
            tempSearchStore.add(queryResultSet[j]);
            tempID.add(resultID[j]);
          });
        }
        else {
          setState(() {
            tempSearchStore.add("TAGRANDMERE");
          });
        }
        print("ID = " + tempSearchStore.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String val;
    print(strController.text);
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            color: Colors.transparent,
            child: Column(children: [
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 6.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.white,
                  border: Border.all(
                    color: Theme.of(context).accentColor
                  )
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.search,
                    color: Theme.of(context).accentColor,
                  ),
                  title: TextField(
                    controller: strController,
                    onChanged: (val) {
                      initiateSearch(val);
                      //inputSearch = val;
                    },
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        hintText: "Turn up",
                        hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 16.5),
                        border: InputBorder.none),
                  ),
                ),
              ),
              resultSearch()
              /*Expanded(
                  child: Container(
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: tempSearchStore.length,
                          itemBuilder: (context, index) {
                            if(strController.text.length >= 12 && tempID.isNotEmpty) {
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25))),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    NightClubProfile(
                                                        documentID: tempID[index])));
                                      },
                                      child: Center(
                                        child: Container(
                                          height: 80,
                                          padding: EdgeInsets.only(
                                              left: 5.0,
                                              right: 5.0,
                                              top: 2.0,
                                              bottom: 1),
                                          child: Column(children: [
                                            ListTile(
                                              leading: ClipRRect(
                                                borderRadius:
                                                BorderRadius.circular(100.0),
                                                child: Image.network(
                                                  tempSearchStore[index]['pictures'][0],
                                                  fit: BoxFit.cover,
                                                  width: 60.0,
                                                  height: 150.0,
                                                ),
                                              ),
                                              title: Text(
                                                  tempSearchStore[index]['name'],
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20.0,
                                                      fontWeight: FontWeight
                                                          .bold)),
                                              subtitle: Row(children: <Widget>[
                                                Icon(
                                                  Icons.music_note,
                                                  color: Colors.blue,
                                                ),
                                                Text(
                                                    tempSearchStore[index]['music']
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14.0)),
                                              ]),
                                              trailing: Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: Colors.white),
                                            ),
                                          ]),
                                        ),
                                      ),
                                    )),
                              );
                            }
                            else if (strController.text.length >= 1) {
                              return Text("yayaya");
                            }

                          })))*/,
            ]),
          ),
        ));
  }

  Widget resultSearch() {
    if (strController.text.length >= 1 && tempSearchStore.contains("TAGRANDMERE")){
        return Text("yayayayapopo");
    }
    else {
      return Expanded(
          child: Container(
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: tempSearchStore.length,
                  itemBuilder: (context, index) {
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
                              borderRadius: BorderRadius.all(
                                  Radius.circular(25))),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          NightClubProfile(
                                              documentID: tempID[index])));
                            },
                            child: Center(
                              child: Container(
                                height: 80,
                                padding: EdgeInsets.only(
                                    left: 5.0,
                                    right: 5.0,
                                    top: 2.0,
                                    bottom: 1),
                                child: Column(children: [
                                  ListTile(
                                    leading: ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(100.0),
                                      child: Image.network(
                                        tempSearchStore[index]['pictures'][0],
                                        fit: BoxFit.cover,
                                        width: 60.0,
                                        height: 150.0,
                                      ),
                                    ),
                                    title: Text(
                                        tempSearchStore[index]['name'],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight
                                                .bold)),
                                    subtitle: Row(children: <Widget>[
                                      Icon(
                                        Icons.music_note,
                                        color: Colors.blue,
                                      ),
                                      Text(
                                          tempSearchStore[index]['music']
                                              .toString(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.0)),
                                    ]),
                                    trailing: Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.white),
                                  ),
                                ]),
                              ),
                            ),
                          )),
                    );
                  })));
    }
  }

}
