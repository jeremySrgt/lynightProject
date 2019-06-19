import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lynight/services/crud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ResultSearch extends StatefulWidget {
  final String userName;
  final String currentUserId;
  final List<Map<dynamic, dynamic>> suggestionList;

  ResultSearch({this.userName, this.currentUserId, this.suggestionList});

  @override
  _ResultSearchState createState() => new _ResultSearchState();
}

class _ResultSearchState extends State<ResultSearch> {
  bool test = false;

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

  bool alreadyFriend(requestedFriendList) {
    for (int i = 0; i < requestedFriendList.length; i++) {
      if (widget.currentUserId == requestedFriendList[i]) {
        return true;
      }
    }
    return false;
  }

  bool alreadyReq(requestedFriendReq) {
    for (int i = 0; i < requestedFriendReq.length; i++) {
      if (widget.currentUserId == requestedFriendReq[i]) {
        return true;
      }
    }
    return false;
  }

  Widget trailingIcon(index) {
    if (widget.suggestionList[index]['friendList'] == null) {
      //pour éviter l'erreur null
    } else {
      if (alreadyFriend(widget.suggestionList[index]['friendList'])) {
        return Icon(Icons.check);
      } else {
        return Icon(
            alreadyReq(widget.suggestionList[index]['friendRequest']) == true
                ? FontAwesomeIcons.paperPlane
                : Icons.add,
            color:
                alreadyFriend(widget.suggestionList[index]['friendRequest']) ==
                        true
                    ? Colors.white
                    : Colors.white);
      }
    }
  }

  Widget ReqPopUp() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double font = MediaQuery.of(context).textScaleFactor;

    return Center(
      child: Container(
        child: Column(
          children: <Widget>[
            Text("Demande d'ami envoyée"),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Text("OK"),
            )
          ],
        ),
      ),
    );
  }

  Widget resultSearch() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double font = MediaQuery.of(context).textScaleFactor;
    return Expanded(
      child: Container(
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: widget.suggestionList.length,
          itemBuilder: (context, index) {
            bool localvar = false;
            print("DANS LE ELSE : " + widget.suggestionList.toString());
            return Card(
              color: Colors.transparent,
              elevation: 12.0,
              margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
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
                            widget.suggestionList[index]['picture'],
                            fit: BoxFit.cover,
                            width: 60.0,
                            height: 150.0,
                          ),
                        ),
                        title: Text(widget.suggestionList[index]['name'],
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
                          Text(
                            widget.suggestionList[index]['mail'],
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ]),
                        trailing: trailingIcon(index),
                        onTap: () {
                          setState(() {
                            if (alreadyReq(widget.suggestionList[index]
                                ['friendRequest'])) {
                              //suggestionList[index]['friendRequest'].remove(widget.currentUserId);
                              //alreadyReq(suggestionList[index]['friendRequest']) = false;
                            } else {
                              addFriend(widget.suggestionList[index]['userID']);
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                      contentPadding: EdgeInsets.only(top: 25, bottom: 10),
                                      content: Container(
                                        height: height/8,
                                        child: Column(
                                          children: <Widget>[
                                            Text("Demande d'ami envoyée",),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            GestureDetector(
                                              onTap: () {Navigator.of(context).pop();},
                                              child: Container(
                                                width: 120,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                        begin: Alignment.topLeft,
                                                        end: Alignment.bottomRight,
                                                        colors: [
                                                          Color.fromRGBO(212, 63, 141, 1),
                                                          Color.fromRGBO(2, 80, 197, 1)
                                                        ]),
                                                    //color: Theme.of(context).primaryColor,
                                                    borderRadius: BorderRadius.all(Radius.circular(25))
                                                ),
                                                child: Center(child: Text("OK", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    );
                                  });
                              //alreadyReq(suggestionList[index]['friendRequest']) = true;
                            }
                          });
                        },
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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double font = MediaQuery.of(context).textScaleFactor;
    return Container(child: resultSearch());
  }
}
