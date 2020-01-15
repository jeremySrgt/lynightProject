import 'package:flutter/material.dart';
import 'package:lynight/creditCard/credit_card_form.dart';
import 'package:lynight/creditCard/credit_card_model.dart';
import 'package:lynight/creditCard/flutter_credit_card.dart';
import 'package:lynight/widgets/slider.dart';
import 'package:lynight/authentification/auth.dart';
import 'package:lynight/services/crud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CarteCredit extends StatefulWidget {
  CarteCredit({this.onSignOut});

  final VoidCallback onSignOut;

  BaseAuth auth = new Auth();

  void _signOut() async {
    try {
      await auth.signOut();
      onSignOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  State<StatefulWidget> createState() {
    return _CarteCreditState();
  }
}

class _CarteCreditState extends State<CarteCredit> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  String userId = 'userId';
  CrudMethods crudObj = new CrudMethods();
  String userMail = 'userMail';


  @override

  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text(
          'CB',
          style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 30),
        ),
        backgroundColor: Colors.white,
      ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              CreditCardWidget(
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cardHolderName: cardHolderName,
                cvvCode: cvvCode,
                showBackView: isCvvFocused,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: CreditCardForm(
                    onCreditCardModelChange: onCreditCardModelChange,
                  ),
                ),
              )
            ],
          ),
        ),
      drawer: CustomSlider(
        userMail: userMail,
        signOut: widget._signOut,
        activePage: 'test',
      ),
      );

  }



  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }



}