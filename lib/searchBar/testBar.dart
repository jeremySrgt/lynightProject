import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lynight/searchBar/searchService.dart';

void main() => runApp(new TestTest());

class TestTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new TestBar(),
    );
  }
}

class TestBar extends StatefulWidget {
  @override
  _TestBarState createState() => new _TestBarState();
}

class _TestBarState extends State<TestBar> {
  var queryResultSet = [];
  var tempSearchStore = [];

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
        if (element['name'].startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(tempSearchStore);
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        title: Text('Firestore search'),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.white,
              ),
              child: ListTile(
                leading: Icon(
                  Icons.search,
                  color: Theme.of(context).accentColor,
                ),
                title: TextField(
                  onChanged: (val) {
                    initiateSearch(val);
                  },
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      hintText: "Turn up",
                      hintStyle: TextStyle(
                          color: Theme.of(context).accentColor, fontSize: 18.0),
                      border: InputBorder.none),
                ),
              ),
            ),
            Expanded(
              child: Container(
                  child: ListView(
                children: tempSearchStore.map((element) {
                  return buildResultCard(element);
                }).toList(),
              )),
            )
          ]),
        ),
      ),
    );
  }
}

Widget buildResultCard(data) {
  return Card(color: Colors.red);
}
