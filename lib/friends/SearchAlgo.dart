import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lynight/services/crud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  bool _isLoading = false;
  List<dynamic> _friendRequestList0fRequestedFriend;

  bool _alreadyRequestedFriend = false;

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

 /*     for (int n = 0; n < allUser.length; n++) {
        if (allUser[n]['mail'].toUpperCase().startsWith(
            value.toUpperCase())) {
          setState(() {
            suggestionList.add(allUser[n]);
          });
        }
      }*/
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

        resultSearch(),
      ]),
    );
  }

  void addFriend(friendID) {
    setState(() {
      _isLoading = true;
    });

    crudObj.getDataFromUserFromDocumentWithID(friendID).then((value) {
      Map<String, dynamic> dataMap = value.data;
      List friendRequestList = dataMap['friendRequest'];
      if (friendRequestList == null) {
        crudObj.updateData('user', friendID, {
          'friendRequest': [widget.currentUserId]
        });
      } else {
        setState(() {
          _friendRequestList0fRequestedFriend = friendRequestList;
        });

        for (int i = 0; i < _friendRequestList0fRequestedFriend.length; i++) {
          if (_friendRequestList0fRequestedFriend[i] == widget.currentUserId) {
            setState(() {
              _alreadyRequestedFriend = true;
            });
          }
        }

        if (_alreadyRequestedFriend == false) {
          List<String> mutableListOfRequestedFriend =
              List.from(_friendRequestList0fRequestedFriend);

          mutableListOfRequestedFriend.add(widget.currentUserId);

          crudObj.updateData('user', friendID,
              {'friendRequest': mutableListOfRequestedFriend});
        } else {
          print('deja amis===========');
        }
      }
      setState(() {
        _isLoading = false;
      });
    });
  }


  bool alreadyFriend(requestedFriendList){
      for (int i = 0; i < requestedFriendList.length; i++) {
        if (widget.currentUserId == requestedFriendList[i]) {
          return true;
        }
      }
      return false;
  }

  bool alreadyReq(requestedFriendReq){
      for (int i = 0; i < requestedFriendReq.length; i++) {
        if (widget.currentUserId == requestedFriendReq[i]) {
          return true;
        }
      }
      return false;
  }

  Widget ReqSent(index) {
    if(suggestionList[index]['friendRequest'] == null) {
      //pour éviter l'erreur null
    }else {
      if (alreadyReq(suggestionList[index]['friendRequest'])) {
        return Icon(FontAwesomeIcons.paperPlane, color: Colors.white,);
      }
      else{
        return Icon(Icons.add,
          color: Colors.white, size: 30,);
      }
    }
  }

  Widget trailingIcon(index){
    if(suggestionList[index]['friendList'] == null) {
      //pour éviter l'erreur null
    }else {
      if (alreadyFriend(suggestionList[index]['friendList'])) {
          return Icon(Icons.check);
      }
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          addFriend(suggestionList[index]['userID']);
        });
        },
      child: ReqSent(index)
    );
  }

  Widget resultSearch() {
    if (strController.text.length == 0) {
      setState(() {
        suggestionList = [];
      });
    }
    if (suggestionList == [] && strController.text.length >= 1) {
      return Text("Cet utilisateur n'existe pas");
    } else {
      print("DANS LE ELSE : " + suggestionList.toString());
      return Expanded(
        child: Container(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: suggestionList.length,
            itemBuilder: (context, index) {
              return Card(
                color: Colors.transparent,
                elevation: 12.0,
                margin:
                    new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color.fromRGBO(212, 63, 141, 1),
                            Color.fromRGBO(2, 80, 197, 1)
                          ]),
                      //color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(25))),
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
                              suggestionList[index]['picture'],
                              fit: BoxFit.cover,
                              width: 60.0,
                              height: 150.0,
                            ),
                          ),
                          title: Text(suggestionList[index]['name'],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold)),
                          subtitle: Row(children: <Widget>[
                            Icon(
                              Icons.alternate_email,
                              color: Colors.blue,
                              size: 20,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(suggestionList[index]['mail'],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)),
                          ]),
                          trailing: trailingIcon(index),
                        ),
                      ]),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    }
  }
}
