import 'package:flutter/material.dart';
import 'package:algolia/algolia.dart';
import 'algoliaInstantiate.dart';

class DataSearch extends SearchDelegate<String> {
  Algolia algolia = AlgoliaInstance.algolia;
  AlgoliaQuery searchQuery;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    searchQuery =
        algolia.instance.index('test_bloon_club_search').search(query);
    return Column(
      children: <Widget>[
        FutureBuilder(
          future: searchQuery.getObjects(),
          builder: (BuildContext context,
              AsyncSnapshot<AlgoliaQuerySnapshot> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return new Text('Chargement...');
                break;
              default:
                if (snapshot.hasError) {
                  return Text(
                      'Erreur du chargement des données: ${snapshot.error}');
                } else {
                  return Expanded(
                    child: ListView.separated(
                      separatorBuilder: (context, index) => Divider(
                        color: Colors.grey,
                      ),
                      itemCount: snapshot.data.hits.length,
                      itemBuilder: (context, index) {
                        final AlgoliaObjectSnapshot result =
                            snapshot.data.hits[index];
                        return ListTile(
                          title: Text(result.data['name'],
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 18)),
                          subtitle: Text(result.data['adress']),
                        );
                      },
                    ),
                  );
                }
            }
          },
        )
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    searchQuery =
        algolia.instance.index('test_bloon_club_search').search(query);

    return Column(
      children: <Widget>[
        FutureBuilder(
          future: searchQuery.getObjects(),
          builder: (BuildContext context,
              AsyncSnapshot<AlgoliaQuerySnapshot> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return new Text('Chargement...');
                break;
              default:
                if (snapshot.hasError) {
                  return Text(
                      'Erreur du chargement des données: ${snapshot.error}');
                } else {
                  return Expanded(
                    child: ListView.separated(
                      separatorBuilder: (context, index) => Divider(
                        color: Colors.grey,
                      ),
                      itemCount: snapshot.data.hits.length,
                      itemBuilder: (context, index) {
                        final AlgoliaObjectSnapshot result =
                            snapshot.data.hits[index];
                        return ListTile(
                          title: Text(result.data['name'],
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 18)),
                          subtitle: Text(result.data['adress']),
                        );
                      },
                    ),
                  );
                }
            }
          },
        )
      ],
    );
  }
}
