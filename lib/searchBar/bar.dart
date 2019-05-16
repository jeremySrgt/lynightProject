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

class FavoritesNightClub extends StatefulWidget {
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
}

class SuggestionList extends StatefulWidget {
  final String inputSearch;

  SuggestionList({Key key, this.inputSearch}) : super(key: key);

  @override
  _SuggestionListState createState() => new _SuggestionListState();
}

class _SuggestionListState extends State<SuggestionList> {
  List clubs;
  final Set<Club> _saved = Set<Club>();

  @override
  void initState() {
    clubs = getCLub();
    super.initState();
  }

  static final clubsList = [
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

  get suggestionList =>
      clubsList.where((p) => p.startsWith(widget.inputSearch)).toList();

  Widget _makeListTile(Club club) {
    final bool alreadySaved = _saved.contains(club);
    return ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          decoration: new BoxDecoration(
              border: new Border(
                  right: new BorderSide(width: 1.0, color: Colors.white24))),
          child: Container(
            alignment: Alignment.center,
            width: 55,
            height: 55,
            decoration: BoxDecoration(
                image: DecorationImage(image: club.clubImage, fit: BoxFit.fill),
                //color: Colors.redAccent,
                borderRadius: BorderRadius.all(Radius.circular(100))),
          ),
        ),
        title: Text(club.title,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

        subtitle: Column(children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(
                Icons.favorite,
                color: Colors.red,
              ),
              Text(club.nbLikes.toString(),
                  style: TextStyle(
                    color: Colors.white,
                  ))
            ],
          ),
          Row(
            children: <Widget>[
              Icon(Icons.music_note, color: Colors.blueAccent),
              Text(club.songsType, style: TextStyle(color: Colors.white))
            ],
          ),
        ]),
        trailing: IconButton(
          icon: Icon(
            alreadySaved ? Icons.favorite : Icons.favorite_border,
            color: alreadySaved ? Colors.white : Colors.white,
            size: 30,
          ),
          onPressed: () {
            setState(() {
              if (alreadySaved) {
                _saved.remove(club);
              } else {
                _saved.add(club);
              }
            });
            FavoritesNightClub();
          },
        ));
  }

  Widget _makeCard(Club club) {
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
        child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/nightClubProfile');
            },
            child: _makeListTile(club)),
      ),
    );
  }

  Widget _makeBody() {
    return Container(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: suggestionList.length,
        itemBuilder: (BuildContext context, int index) {
          return _makeCard(clubs[index]);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (suggestionList.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Résultats"),
        ),
        body: Center(child: Text("Soit ça existe pas, soit t'as mal écrit")),
      );
    } else {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text("Résultats"),
        ),
        body: _makeBody(),
        /*new ListView.builder(
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(Icons.domain),
                title: Text("${suggestionList[index]}"),
                onTap: () {},
              );
            },
            itemCount: suggestionList.length)*/
      );
    }
  }
}

List getCLub() {
  return [
    Club(
      title: "Wanderlust",
      nbLikes: 5,
      songsType: "HipHop, RnB",
      clubImage: AssetImage('assets/nightClub.jpg'),
    ),
    Club(
      title: "AuDD",
      nbLikes: 4,
      songsType: "QLF, Faya",
      clubImage: AssetImage('assets/nightClub.jpg'),
    ),
    Club(
      title: "ESIEE",
      nbLikes: 1,
      songsType: "Electro, HipHop",
      clubImage: AssetImage('assets/nightClub.jpg'),
    ),
    Club(
      title: "ChezJerem",
      nbLikes: 0,
      songsType: "Justin Bieber",
      clubImage: AssetImage('assets/nightClub.jpg'),
    ),
    Club(
      title: "Club Haussmann",
      nbLikes: 4,
      songsType: "Généraliste",
      clubImage: AssetImage('assets/nightClub.jpg'),
    ),
    Club(
      title: "BNK",
      nbLikes: 4,
      songsType: "Techno, Trans",
      clubImage: AssetImage('assets/nightClub.jpg'),
    ),
    Club(
      title: "Nuits Fauves",
      nbLikes: 3,
      songsType: "Techno, Trans",
      clubImage: AssetImage('assets/nightClub.jpg'),
    ),
    Club(
      title: "Coachella",
      nbLikes: 5,
      songsType: "Le feeeu",
      clubImage: AssetImage('assets/nightClub.jpg'),
    ),
    Club(
      title: "Kelly Kelly NightClub",
      nbLikes: 5,
      songsType: "Diams, Zaho",
      clubImage: AssetImage('assets/nightClub.jpg'),
    ),
  ];
}

class Club {
  String title;
  int nbLikes;
  String songsType;
  AssetImage clubImage;

  Club({this.title, this.nbLikes, this.songsType, this.clubImage});
}
