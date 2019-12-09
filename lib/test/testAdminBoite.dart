import 'package:flutter/material.dart';
import 'package:lynight/widgets/slider.dart';
import 'package:lynight/services/crud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lynight/authentification/auth.dart';

class TestAdminBoite extends StatefulWidget{



  final BaseAuth auth = new Auth();

  @override
  State<StatefulWidget> createState() {
    return _TestAdminBoiteState();
  }
}

class _TestAdminBoiteState extends State<TestAdminBoite>{

  CrudMethods crudObj = CrudMethods();

  String userId = '';
  String _name = '';
  String _mail = '';
  Map<String,dynamic> currentUserDataMap = {};


  @override
  void initState() {
    super.initState();

    widget.auth.currentUser().then((id) {
      setState(() {
        userId = id;
      });

      Firestore.instance.collection('AdminBoite').document(userId).get().then((value){
        Map<String,dynamic> dataMap = value.data;
        setState(() {
          currentUserDataMap = dataMap;
        });
        print("HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH");
        print(dataMap);
      });
    });

  }


  void addClubToAdmin()async {
    print("rentrer dans addclub");
    Firestore.instance.collection('AdminBoite').document(userId).collection('myClubs').add({
      'name': 'valclub',
      'price': 250,
    });
  }


  Widget _buildStream(){
    return StreamBuilder(
      stream: Firestore.instance.collection('AdminBoite').document(userId).collection('myClubs').snapshots(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return CircularProgressIndicator();
        }
        var data = snapshot.data.documents;
        return clubConstruct(data);
      });
  }


  Widget clubConstruct(data){
    var length = data.length;
    return Expanded(
      child: ListView.builder(
        itemCount: length,
        itemBuilder: (context, index){
//          Map<String, dynamic> currentData = data[index];
          return ListTile(
            title: Text(data[index]['name']),
            trailing: Text(data[index]['price'].toString()),
          );
        },
      ),
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("test admin boite"),
      ),
      drawer: CustomSlider(userMail: 'testmail',signOut: (){},activePage: 'test',),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Text(currentUserDataMap['name']),
            FlatButton(
              child: Icon(Icons.check_circle_outline),
              onPressed: (){
                addClubToAdmin();
              },
            ),

            _buildStream(),
          ],
        ),
      )
    );
  }
}