import 'package:flutter/material.dart';
import 'package:lynight/searchBar/suggestionList.dart';

class FavoritesNightClub extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    //return _FavoritesNightClubState();
    return null;
  }
}

/*class _FavoritesNightClubState extends State<FavoritesNightClub> {
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
