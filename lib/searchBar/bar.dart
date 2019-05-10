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
/*@override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: TextField(
        onChanged: (value) {},
        decoration: InputDecoration(
          labelText: "Recherchez un nom de boîte",
          prefixIcon: Icon(Icons.search, color: Colors.grey,)
        ),
      ),
        */ /*child: IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: DataSearch());*/ /*
              //drawer: Drawer(),
//            })
  );
  }
}*/

class MyHomePage extends StatefulWidget {
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

  final recentSearch = ["AuDD", "ESIEE", "ChezJerem"];

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
                borderRadius: BorderRadius.all(Radius.circular(25.0)))
        ),
        onSubmitted: (String str) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => new SuggestionList(inputSearch: str)));
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
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Next Page"),
      ),
      body: new Text("${widget.inputSearch}"),
    );
  }
}


class DataSearch extends SearchDelegate<String> {
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

  final recentSearch = ["AuDD", "ESIEE", "ChezJerem"];

  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return NightClubProfile();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? recentSearch
        : clubsList.where((p) => p.startsWith(query)).toList();

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
            onTap: () {
              showResults(context);
            },
            title: RichText(
              text: TextSpan(
                  text: suggestionList[index].substring(0, query.length),
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                        text: suggestionList[index].substring(query.length),
                        style: TextStyle(color: Colors.grey))
                  ]),
            ),
          ),
      itemCount: suggestionList.length,
    );
  }
}
