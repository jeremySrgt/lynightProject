import 'package:flutter/material.dart';
import 'package:lynight/nightCubPage/nightClubProfile.dart';
import 'package:lynight/searchBar/suggestionList.dart';

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
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.deepOrangeAccent,
                  Theme.of(context).primaryColor,
                ]),
          ),
          alignment: Alignment.center,
          child: Container(
            width: 300,
            height: 60,
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

/*class FavoritesNightClub extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _FavoritesNightClubState();
  }
}

class _FavoritesNightClubState extends State<FavoritesNightClub> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    final Iterable<Widget> tiles = _SuggestionListState()._saved.map(
      (Club club) {
        return Container(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: _SuggestionListState()._saved.length,
            itemBuilder: (BuildContext context, int index) {
              return _SuggestionListState()
                  ._makeCard(_SuggestionListState().clubs[index]);
            },
          ),
        );
      },
    );
    final List<Widget> divided = ListTile.divideTiles(
      context: context,
      tiles: tiles,
      color: Theme.of(context).primaryColor,
    ).toList();

    return new Scaffold(
      body: ListView(
        children: divided,
      ),
    );
  }
}*/


