import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lynight/services/crud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lynight/friends/ResultSearch.dart';

class SearchAlgo extends StatefulWidget {
  final String userName;
  final String currentUserId;

  SearchAlgo({this.userName, this.currentUserId});

  @override
  _SearchAlgoState createState() => new _SearchAlgoState();
}

class _SearchAlgoState extends State<SearchAlgo> {
  CrudMethods crudObj = new CrudMethods();
  List<Map<dynamic, dynamic>> allUser;

  final strController = TextEditingController();
  List<Map<dynamic, dynamic>> suggestionList = [];

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    strController.dispose();
    super.dispose();
  }

  void initState() {
    super.initState();

    crudObj.getDataDocuments('user').then((querySnapshot) {
      List<Map<dynamic, dynamic>> tempList = [];
      for (int i = 0; i < querySnapshot.documents.length; i++) {
        Map<dynamic, dynamic> tempMap = querySnapshot.documents[i].data;
        tempMap['userID'] = querySnapshot.documents[i].documentID;
        tempList.add(tempMap);
      }

      setState(() {
        allUser = tempList;
      });
    });
  }

  initiateSearch(value) {
    //Est appelé lorsque l'on tape qqch dans la searchBar
    if (value.length == 0) {
      setState(() {
        suggestionList = [];
      });
    }

    if(value != 0) {
      allUser.forEach((user) {
        if (user['mail'].toUpperCase().startsWith(strController.text.toUpperCase())) {
          if(suggestionList.contains(user)){
            //pour ne pas multiplier le user dans la suggestionList
          }else {
            setState(() {
              suggestionList.add(user);
            });
          }
        }
        else{
          setState(() {
            suggestionList.remove(user);
          });
        }
      });
    }
  }

  Widget ConditionResultSearch() {
    if (strController.text.length == 0){
      setState(() {
        suggestionList = [];
      });
    }
    return ResultSearch(userName: widget.userName, currentUserId: widget.currentUserId, suggestionList: suggestionList,);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double font = MediaQuery.of(context).textScaleFactor;

    String val = "";
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(24.0)),
      ),
      child: Column(children: [
        ListTile(
          leading: Icon(
            Icons.search,
            color: Theme.of(context).accentColor,
            size: 25,
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
                hintText: "Recherche par e-mail",
                hintStyle: TextStyle(color: Colors.grey, fontSize: font * 20,),
                border: InputBorder.none),
          ),
          trailing: Icon(Icons.arrow_downward,color: Theme.of(context).primaryColor,size: 25,),
        ),
        ConditionResultSearch()
    ]),
    );
  }
}