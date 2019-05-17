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
      this.favorites,
      this.notification,
      this.picture,
      this.reservation});

  final String name;
  final String surname;
  final String mail;
  final String phone;
  final DateTime dob;
  final bool sex;
  final List<String> music;
  final List<String> favorites;
  final bool notification;
  final String picture;
  final Map<String, dynamic> reservation;

  Map<String,dynamic> getDataMap(){
    return {
      "name":name,
      "surname":surname,
      "mail":mail,
      "phone":phone,
      "DOB":dob,
      "sex":sex,
      "music":music,
      "favoris":favorites,
      "notification":notification,
      "picture":picture,
      "reservation":reservation
    };
  }
}
