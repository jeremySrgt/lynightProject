import 'package:flutter/material.dart';

class UserData {
  UserData(
      {this.name,
      this.surname,
      this.mail,
      this.phone,
      this.dob,
      this.sex,
      this.music,
      this.favoris,
      this.notification,
      this.picture,
      this.reservation,
      this.pro,
      this.friendRequest,
      this.friendList,
      this.invitation});

  final String name;
  final String surname;
  final String mail;
  final String phone;
  final DateTime dob;
  final bool sex;
  final Map<dynamic,dynamic> music;
  final List<String> favoris;
  final bool notification;
  final String picture;
  final List<dynamic> reservation;
  final bool pro;
  final List<String> friendRequest;
  final List<String> friendList;
  final List<dynamic> invitation;


  Map<String,dynamic> getDataMap(){
    return {
      "name":name,
      "surname":surname,
      "mail":mail,
      "phone":phone,
      "DOB":dob,
      "sex":sex,
      "music":music,
      "favoris":favoris,
      "notification":notification,
      "picture":picture,
      "reservation":reservation,
      "pro":pro,
      "friendRequest": friendRequest,
      "friendList": friendList,
      "invitation": invitation,
    };
  }
}
