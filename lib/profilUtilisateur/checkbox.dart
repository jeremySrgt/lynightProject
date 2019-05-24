import 'package:flutter/material.dart';
import 'package:lynight/services/crud.dart';


class MyCheckbox extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyCheckboxState();
  }
}


class _MyCheckboxState extends State<MyCheckbox>{
  CrudMethods crudObj = new CrudMethods();


  bool electro = false;
  bool rap = false;
  bool rnb = false;
  bool populaire = false;
  bool rock = false;
  bool trans = false;




  Widget checkbox(String title, bool boolValue) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(title),
        Checkbox(
          value: boolValue,
          onChanged: (bool value) {
            setState(() {
              switch (title) {
                case "electro":
                  electro = value;
                  break;
                case "rap":
                  rap = value;
                  break;
                case "rnb":
                  rnb = value;
                  break;
                case "populaire":
                  populaire = value;
                  break;
                case "rock":
                  rock = value;
                  break;
                case "trans":
                  trans = value;
                  break;
              }
            });
            crudObj.createOrUpdateUserData({'music':{'electro':electro}});
          },
        )
      ],
    );
  }

  _ocelectro(bool value){
    setState(() {
      electro = value;
    });
    crudObj.createOrUpdateUserData({'music':{'electro':electro}});

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            checkbox('electro', electro),
            SizedBox(width: 20,),
            checkbox('populaire', populaire),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            checkbox('rap', rap),
            SizedBox(width: 20,),
            checkbox('rnb', rnb),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            checkbox('rock', rock),
            SizedBox(width: 20,),
            checkbox('trans', trans),
          ],
        ),
        Row(
          children: <Widget>[
            Checkbox(value: electro, onChanged: _ocelectro)
          ],
        )
      ],
    );
  }
}