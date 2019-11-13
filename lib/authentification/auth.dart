import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';



abstract class BaseAuth {

  Future<String> currentUser();
  Future<String> userEmail();
  Future<String> signIn(String email, String password);
  Future<String> createUser(String email, String password);
  Future<void> signOut();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signIn(String email, String password) async {
    AuthResult authresult = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    print('USERID : ' + authresult.user.uid);
    if (authresult.user.isEmailVerified){
      return authresult.user.uid;
    }
    return null;
  }

  Future<String> createUser(String email, String password) async {
    AuthResult authresult = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    try {
      await authresult.user.sendEmailVerification();
      return null;
    } catch (e) {
      print("An error occured while trying to send email        verification");
      print(e.message);
    }
  }

  Future<FirebaseUser> user() async{
    return await _firebaseAuth.currentUser();
  }

  Future<String> currentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    //print('USERID : ' + user.uid);
    return user != null ? user.uid : null;
  }

  Future<String> userEmail() async{
    FirebaseUser user = await _firebaseAuth.currentUser();
    //print('USER EMAIL : ' + user.email);
    return user != null ? user.email : null;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }


    //body: 'Bonjour et bienvenue sur Bloon, l\'application qui vous guidera vos soirées. Veuillez confirmer votre mail en cliquant sur l\'url suivant : ',
    //subject: 'Validation de votre compte Bloon',
    //recipients: ['vsoudy@gmail.com'],
    //isHTML: true,
    //bccRecipients: ['other@example.com'],
    //ccRecipients: ['third@example.com'],
    //attachments: [ 'path/to/image.png', ],


  //await FlutterMailer.send(mailOptions);



}