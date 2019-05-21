import 'package:flutter/material.dart';
import 'package:lynight/searchBar/Club.dart';
import 'package:lynight/nightCubPage/nightClubProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lynight/searchBar/SearchService.dart';

void main() => runApp(SearchBar());

class SearchBar extends StatefulWidget {
  @override
  _SearchBar createState() => _SearchBar();
}

class _SearchBar extends State<SearchBar> with SearchDelegate<String> {
  var queryResultSet = [];
  var tempSearchStore = [];

  List<Club> clubs;
  final _inpuController = new TextEditingController();
  FocusNode _focus = new FocusNode();
  bool hasFocus;
  String inputValue;

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }

    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);

    if (queryResultSet.length == 0 && value.length == 1) {
      SearchService().searchByName(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.documents.length; ++i) {
          queryResultSet.add(docs.documents[i].data);
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['businessName'].startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

  @override
  void initState() {
    clubs = getClub();
    super.initState();
    _focus.addListener(_onChange);
    _inpuController.addListener(_onChange);
  }

  void _onChange() {
    setState(() {
      inputValue = _inpuController.text.toLowerCase();
      hasFocus = _focus.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Container(
          color: Colors.transparent,
          child: Column(children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.white30,
              ),
              child: ListTile(
                leading: Icon(
                  Icons.search,
                  color: Colors.grey[600],
                ),
                title: TextFormField(
                  controller: _inpuController,
                  focusNode: _focus,
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      hintText: "Turn up",
                      hintStyle:
                          TextStyle(color: Colors.grey[600], fontSize: 18.0),
                      border: InputBorder.none),
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: buildSuggestions(context),
              ),
            )
          ]),
        ),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {}

  @override
  Widget buildLeading(BuildContext context) {}

  @override
  Widget buildResults(BuildContext context) {}

  @override
  Widget buildSuggestions(BuildContext context) {
    query = inputValue;
    final suggestionList = query.isEmpty
        ? queryResultSet
        : tempSearchStore;
    print(queryResultSet);

    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        return Card(
          color: Colors.transparent,
          elevation: 12.0,
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.deepOrangeAccent,
                      Theme.of(context).primaryColor,
                    ]),
                //color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(25))),
            child: Container(
              padding:
                  EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0, bottom: 5),
              child: Column(children: [
                ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(100.0),
                    child: Container(
                      padding: EdgeInsets.only(top: 2.0),
                      width: 60.0,
                      height: 150.0,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: suggestionList[index].clubImage,
                        fit: BoxFit.fill,
                      )),
                    ),
                  ),
                  title: Text(suggestionList[index]['name'],
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold)),
                  subtitle: Row(
                    children: <Widget>[
                      Icon(Icons.music_note, color: Colors.blue,),
                      Text(suggestionList[index].songsType,
                      style: TextStyle(color: Colors.white, fontSize: 14.0)),
                    ]),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
                ),
              ]),
            ),
          ),
        );
      },
      itemCount: suggestionList.length,
    );
  }
}
