import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lynight/services/clubPictures.dart';
import 'package:simple_slider/simple_slider.dart';
import 'package:lynight/nightCubPage/carousel.dart';
import 'package:lynight/services/clubPictures.dart';
import 'package:lynight/nightCubPage/sumUpPage.dart';

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

  Widget carouselPictureNightClubProfile(clubData, context) {
    var length = clubData['pictures'].length;
    List<String> urlTab = [];
    //i<= 3 pour eviter de charger plus que 4 images de la base
    for(int i = 0;i<length && i<=3 ;i++){
      urlTab.insert(i,clubData['pictures'][i]);
    }
    return Container(
      height: 230,
      width: 300,
      child: PageView(
        children: <Widget>[
          ImageSliderWidget(
            imageUrls:
            urlTab,
            imageBorderRadius: BorderRadius.circular(8.0),
          ),
        ],
        scrollDirection: Axis.horizontal,
      ),
    );
  }



  Widget nightClubProfileInfo(clubData, context){
    List musicStyle = clubData['music'];

    final linkUrlWebsite = Container(
      margin: EdgeInsets.only(top: 10.0, left: 5.0),
      height: 60,
      width: 250,
      child: Text(
        clubData['siteUrl'] + '\n' + '\n' + clubData['soundcloud'],
      ),
    );

    final music0 = Container(
      alignment: FractionalOffset.center,
      height: 30,
      width: 80,
      child: Text(
          musicStyle[0],
        textAlign: TextAlign.center,
      ),
      margin: EdgeInsets.only(left: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black),
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
          musicStyle[1],
        textAlign: TextAlign.center,
      ),
      margin: EdgeInsets.only(left: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
    );

    final music2 = musicStyle[2] != null ? Container(
      alignment: FractionalOffset.center,
      height: 30,
      width: 80,
      child:
      Text(
          musicStyle[2],
          textAlign: TextAlign.center,
      ),
      margin: EdgeInsets.only(left: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
    ) : Container();

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
           child: Column(
             children: <Widget>[
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
                   width: 350,
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
                           width: 250,
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
                   width: 350,
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
                           width: 270,
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
                   width: 350,
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
                             width: 270,
                             child: Text(clubData['adress'] +
                                 '\n' +
                                 '\n' +
                                 clubData['phone'])),
                       ],
                     ),
                   ),
                 ),
               ),
               Container(
                 alignment: FractionalOffset.center,
                 height: 95,
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
                   width: 350,
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
                           width: 270,
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
               Container(height: 25),
               Container(
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: <Widget>[
                   RaisedButton(
                   elevation: 5.0,
                   shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(30.0)),
                   child: Text('Let\'s Party',
                       style: TextStyle(color: Colors.white, fontSize: 20.0)),
                   color: Theme.of(context).primaryColor,
                   textColor: Colors.black87,
                   onPressed: (){
                     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SumUp(clubId: documentID,)));
                   },
                 ),
                     //onPressed: validateAndSubmit),
                   ],
                 ),
               ),
               Container(height: 30),

             ],
           ),
          )
        ],
      ),
    );





  }


  Widget pageConstruct(clubData, context) {


    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                clubData['name']
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  child: carouselPictureNightClubProfile(clubData, context),
                ),
                Container(
                  child: nightClubProfileInfo(clubData, context),
                ),
              ],
            ),
          ),
        ],
      ),
    );


    }
  }
