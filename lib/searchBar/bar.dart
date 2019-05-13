import 'package:flutter/material.dart';
import 'package:lynight/nightCubPage/nightClubProfile.dart';

class InputSearch {
  final String strInput;

  InputSearch(this.strInput);
}

/*class SearchBar extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: new MyHomePage(title: 'ListView with Search'),
    );
  }
}*/

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController editingController = TextEditingController();

  String result = "";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Container(
          width: 330,
          height: 100,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              color: Colors.deepOrangeAccent),
          alignment: Alignment.center,
          child: Container(
            width: 300,
            height: 50,
            child: TextField(
              onChanged: (value) {},
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Turn up",
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.black45,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)))),
              onSubmitted: (String str) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            new SuggestionList(inputSearch: str)));
              },
            ),
          ),
        ),
      ),
    );
  }
}

class SuggestionList extends StatefulWidget {
  final String inputSearch;

  SuggestionList({Key key, this.inputSearch}) : super(key: key);

  @override
  _SuggestionListState createState() => new _SuggestionListState();
}

class _SuggestionListState extends State<SuggestionList> {
  final clubsList = [
    "Wanderlust",
    "AuDD",
    "ESIEE",
    "ChezJerem",
    "Club Haussmann",
    "BNK",
    "Nuits Fauves",
    "Coachella",
    "Kelly Kelly NightClub"
  ];

  @override
  Widget build(BuildContext context) {
    final suggestionList =
        clubsList.where((p) => p.startsWith(widget.inputSearch)).toList();

    final makeListTile = ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          decoration: new BoxDecoration(
              border: new Border(
                  right: new BorderSide(width: 2.0, color: Colors.white24))),
          child: Icon(Icons.autorenew, color: Colors.white),
        ),
        title: Text(
          "Nom de la boîte",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

        subtitle: Row(
          children: <Widget>[
            Icon(Icons.music_note, color: Colors.blueAccent),
            Text(" Type de musique", style: TextStyle(color: Colors.white))
          ],
        ),
        trailing:
        Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0));

    final makeCard = Card(
      color: Colors.transparent,
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.deepOrangeAccent,
          borderRadius: BorderRadius.all(Radius.circular(25))),
        child: makeListTile,
      ),
    );

    final makeBody = Container(
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
            return makeCard;
          },
        ),
    );



    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Résultats"),
        ),
        body: makeBody,
      /*new ListView.builder(
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(Icons.domain),
                title: Text("${suggestionList[index]}"),
                onTap: () {},
              );
            },
            itemCount: suggestionList.length)*/);
  }
}
