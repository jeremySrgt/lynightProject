import 'package:flutter/material.dart';
import 'package:lynight/nightCubPage/nightClubProfile.dart';

class InputSearch {
  final String strInput;

  InputSearch(this.strInput);
}

class SearchBar extends StatelessWidget {
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
}

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
    return new Container(
      child: new TextField(
        onChanged: (value) {},
        decoration: InputDecoration(
            hintText: "Recherchez un nom de boîte",
            prefixIcon: Icon(
              Icons.search,
              color: Colors.grey,
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)))),
        onSubmitted: (String str) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => new SuggestionList(inputSearch: str)));
        },
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
    final suggestionList = clubsList.where((p) => p.startsWith(widget.inputSearch)).toList();
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Résultats"),
        ),
        body: new ListView.builder(
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(Icons.domain),
                title: Text("${suggestionList[index]}"),
                onTap: () {},
              );
            },
            itemCount: suggestionList.length));
  }
}
