import 'package:flutter/material.dart';
import 'package:lynight/authentification/primary_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NightClubProfile extends StatelessWidget {
  NightClubProfile({this.documentID});

  final String documentID;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('club')
          .document(documentID)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        var clubData = snapshot.data;
        return pageConstruct(clubData, context);
      },
    );
  }

  Widget pageConstruct(clubData, context) {

    List musicStyle = clubData['music'];

    final linkUrlWebsite = Container(
      margin: EdgeInsets.only(top: 10.0, left: 5.0),
      height: 60,
      width: 275,
      child: Text(
        clubData['siteUrl']  + '\n' + '\n' + clubData['soundcloud'],
      ),
    );

    final linkSoundcloud = Container(
      color: Colors.red,
      height: 25,
      width: 150,
    );

    final music0 = Container(
      alignment: FractionalOffset.center,
      height: 30,
      width: 80,
      child: Text(
         musicStyle[0]
      ),
      margin: EdgeInsets.only(left: 15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black
        ),
        borderRadius: BorderRadius.all(
            Radius.circular(10.0),
        ),
      ),
    );

    final music1 = Container(
      alignment: FractionalOffset.center,
      height: 30,
      width: 80,
      child: Text(
           musicStyle[1]
      ),
      margin: EdgeInsets.only(left: 15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
            color: Colors.black
        ),
        borderRadius: BorderRadius.all(
            Radius.circular(10.0)
        ),
      ),
    );

    final music2 = Container(
      alignment: FractionalOffset.center,
      height: 30,
      width: 80,
      child: Text(
           musicStyle[2]
      ),
      margin: EdgeInsets.only(left: 15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
            color: Colors.black
        ),        borderRadius: BorderRadius.all(
            Radius.circular(10.0)
        ),
      ),
    );


    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: false,
            pinned: true,
            title: Text(clubData['name']),
            backgroundColor: Theme.of(context).primaryColor,
            expandedHeight: 250.0,
            flexibleSpace: FlexibleSpaceBar(
              background:
                  Image.asset('assets/nightClub.jpg', fit: BoxFit.cover),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(height: 15),

                Container(
                  alignment: Alignment.center,
                  height: 125,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(2.0, 5.0),
                          blurRadius: 10.0,
                        )
                      ],
                    ),
                    margin: EdgeInsets.only(top: 10),
                    height: 120,
                    width: 375,
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            width: 60,
                            child: Icon(
                              Icons.description,
                              size: 35,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          VerticalDivider(),
                          Container(
                            alignment: FractionalOffset.center,
                            margin: EdgeInsets.only(left: 10.0),
                            height: 100,
                            child: Text(
                              'AU PIED DE L’ARC DE TRIOMPHE, SUR LA PRESTIGIEUSE AVENUE FOCH,'
                              'LE DUPLEX VOUS OUVRE SES PORTES TOUS LES JOURS À PARTIR DE 23H30. '
                              'UN LIEU TOTALEMENT REPENSÉ ET RÉNOVÉ .',
                              style: TextStyle(fontSize: 13),
                              textAlign: TextAlign.justify,
                            ),
                            width: 275,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(height: 10),


                Container(
                  alignment: FractionalOffset.center,
                  height: 100,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(2.0, 5.0),
                          blurRadius: 10.0,
                        )
                      ],
                    ),
                    margin: EdgeInsets.only(top: 10),
                    height: 80,
                    width: 375,
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Container(
                            alignment: FractionalOffset.center,
                            width: 60,
                            child: Icon(
                              Icons.music_note,
                              size: 35,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          VerticalDivider(),
                          Container(
                            alignment: FractionalOffset.center,
                            height: 60,
                            color: Colors.white10,
                            width: 290,
                            child: Row(
                              children: <Widget>[
                                music0,
                                music1,
                                music2,
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Container(
                  alignment: FractionalOffset.center,
                  height: 110,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(2.0, 5.0),
                          blurRadius: 10.0,
                        )
                      ],
                    ),
                    margin: EdgeInsets.only(top: 10),
                    height: 80,
                    width: 375,
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Container(
                            alignment: FractionalOffset.center,
                            width: 60,
                            child: Icon(
                              Icons.contacts,
                              size: 35,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          VerticalDivider(),
                          Container(
                            alignment: FractionalOffset.centerLeft,
                            height: 60,
                            color: Colors.white10,
                            width: 290,
                            child: Text(
                              clubData['adress'] + '\n' + '\n' + clubData['phone']
                            )
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Container(
                  alignment: FractionalOffset.center,
                  height: 110,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(2.0, 5.0),
                          blurRadius: 10.0,
                        )
                      ],
                    ),
                    margin: EdgeInsets.only(top: 10),
                    height: 80,
                    width: 375,
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Container(
                            alignment: FractionalOffset.center,
                            width: 60,
                            child: Icon(
                              Icons.link,
                              size: 35,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          VerticalDivider(),
                          Container(
                            alignment: FractionalOffset.center,
                            margin: EdgeInsets.only(top: 5.0),
                            height: 60,
                            color: Colors.white10,
                            width: 290,
                            child: Row(
                              children: <Widget>[
                                linkUrlWebsite,
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),


                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      PrimaryButton(
                          //key:  Key('register'),
                          text: 'Let\'s Party',
                          height: 44.0),
                      //onPressed: validateAndSubmit),
                    ],
                  ),
                ),
                Container(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

/*
  Widget pageConstruct(clubData, context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  clubData['name'],
                  textAlign: TextAlign.center,
                ),
                background: Image.asset(
                  'assets/nightClub.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    infoSection(clubData, context),
                    //priceSection,
                  ],
                ),
              ),
            )
          ],
        ),
        constraints: BoxConstraints(
            maxHeight: double.infinity,
            maxWidth: double.infinity
        ),
      ),

    );
  }

  Widget infoSection(clubData, context) {
    List musicStyle = clubData['music'];

    return Expanded(
      child: Row(
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, //met dans le bon axe
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(30, 20, 0, 0),
                  height: 40,
                  child: Text(
                    'Informations\n',
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(50, 20, 0, 0),
                  child: Text(
                    clubData['name'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(50, 15, 0, 0),
                  child: Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, //met dans le bonne axe
                    children: [
                      Icon(
                        Icons.place,
                        size: 17,
                        color: Theme.of(context).primaryColor,
                      ),
                      Text(
                        '  ' + clubData['adress'],
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(50, 15, 0, 0),
                  child: Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, //met dans le bonne axe
                    children: [
                      Icon(
                        Icons.phone,
                        color: Theme.of(context).primaryColor,
                        size: 17,
                      ),
                      Text(
                        '  ' + clubData['phone'],
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(50, 15, 0, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.insert_link,
                        size: 17,
                        color: Theme.of(context).primaryColor,
                      ),
                      Text(
                        '  ' + clubData['siteUrl'],
                        style: TextStyle(
                          color: Colors.blue,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Container(
                    width: 375,
                    padding: const EdgeInsets.fromLTRB(50, 15, 0, 0),
                    child: Text(
                      clubData['description'],
                      textAlign: TextAlign.justify,
                      softWrap: true,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(30, 20, 0, 0),
                  height: 50,
                  child: Text(
                    'Musique\n',
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(50, 15, 0, 0),
                  child: Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, //met dans le bonne axe
                    children: [
                      Icon(
                        Icons.music_note,
                        color: Theme.of(context).primaryColor,
                        size: 17,
                      ),
                      Text(
                        '  ' + musicStyle[0],
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(50, 15, 0, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.queue_music,
                        size: 17,
                        color: Theme.of(context).primaryColor,
                      ),
                      Text(
                        '  ' + clubData['soundcloud'],
                        style: TextStyle(
                          color: Colors.blue,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      PrimaryButton(
                          //key:  Key('register'),
                          text: 'Let\'s Party',
                          height: 44.0),
                      //onPressed: validateAndSubmit),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      PrimaryButton(
                        //key:  Key('register'),
                          text: 'Let\'s Party',
                          height: 44.0),
                      //onPressed: validateAndSubmit),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      PrimaryButton(
                        //key:  Key('register'),
                          text: 'Let\'s Party',
                          height: 44.0),
                      //onPressed: validateAndSubmit),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }*/
}
