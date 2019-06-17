import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lynight/services/crud.dart';
import 'package:lynight/friends/SearchAlgo.dart';

class FriendResearch extends StatefulWidget {
  final String currentUserId;
  final String userName;

  FriendResearch({@required this.currentUserId, @required this.userName});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _FriendResearchState();
  }
}

class _FriendResearchState extends State<FriendResearch> {
  CrudMethods crudObj = new CrudMethods();
  List<dynamic> _friendRequestList0fRequestedFriend;
  static final formKeyAddFriend = new GlobalKey<FormState>();
  bool _alreadyRequestedFriend = false;
  String _friendID;
  bool _isLoading = false;

  Widget friendResearch() {
    // la section research est pour le moment directement un ajout avec l'ID
    return Container(
      child: Form(
        key: formKeyAddFriend,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Ajout par ID (ne pas se tromper)',
                icon: new Icon(
                  FontAwesomeIcons.plusCircle,
                  color: Colors.grey,
                ),
              ),
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Saisis un ID';
                }
              },
              onSaved: (value) => _friendID = value,
            ),
            widget.userName == ''
                ? Text('Tu dois enregistrer ton nom pour ajouter des amis !')
                : _button(),
            _alreadyRequestedFriend == true
                ? Text(
                    'Une demande d\'ami a déjà été envoyée',
                    style: TextStyle(color: Colors.red),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = formKeyAddFriend.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    //TODO ajouter la submition
    if (validateAndSave()) {
      setState(() {
        _isLoading = true;
      });
      formKeyAddFriend.currentState.reset();

      crudObj.getDataFromUserFromDocumentWithID(_friendID).then((value) {
        Map<String, dynamic> dataMap = value.data;
        List friendRequestList = dataMap['friendRequest'];
        if (friendRequestList == null) {
          crudObj.updateData('user', _friendID, {
            'friendRequest': [widget.currentUserId]
          });
        } else {
          setState(() {
            _friendRequestList0fRequestedFriend = friendRequestList;
          });

          for (int i = 0; i < _friendRequestList0fRequestedFriend.length; i++) {
            if (_friendRequestList0fRequestedFriend[i] ==
                widget.currentUserId) {
              setState(() {
                _alreadyRequestedFriend = true;
              });
            }
          }

          if (_alreadyRequestedFriend == false) {
            List<String> mutableListOfRequestedFriend =
                List.from(_friendRequestList0fRequestedFriend);

            mutableListOfRequestedFriend.add(widget.currentUserId);

            crudObj.updateData('user', _friendID,
                {'friendRequest': mutableListOfRequestedFriend});
          }
        }
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  Widget _button() {
    if (_isLoading) {
      return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: CircularProgressIndicator(),
      );
    } else {
      return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: RaisedButton(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            child: Text('demande d\'ami',
                style: TextStyle(color: Colors.white, fontSize: 20.0)),
            color: Theme.of(context).primaryColor,
            textColor: Colors.black87,
            onPressed: () {
              validateAndSubmit();
//                print('friend ID : ' + _friendID);
            },
          ),
        ),
      );
    }
  }

  void _openModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFF737373)),
              color: Color(0xFF737373),
            ),
            child: Container(
              child: SearchAlgo(
                currentUserId: widget.currentUserId,
                userName: widget.userName,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(25.0),
                  topRight: const Radius.circular(25.0),
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double font = MediaQuery.of(context).textScaleFactor;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        child: widget.userName == ''
            ? Text('Tu dois renseigner ton prénom pour ajouter un ami !')
            : Card(
                color: Colors.transparent,
                elevation: 8,
                child: SizedBox(
                  height: height / 18,
                  width: width / 2,
                  child: GestureDetector(
                    onTap: () {
                      _openModalBottomSheet(context);
//              Navigator.push(
//                  context,
//                  MaterialPageRoute(builder: (context) => SearchAlgo(currentUserId: widget.currentUserId, userName: widget.userName,)));
                    },
                    child: Container(
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
                        child: Text('Ajouter un ami',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0)),
                      ),
                      //color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
