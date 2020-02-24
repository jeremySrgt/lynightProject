import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class BaseAuth {
  Future<String> currentUser();

  Future<String> userEmail();

  Future<String> signIn(String email, String password);

  Future<String> createUser(String email, String password);

  Future<void> signOut();

  Future<String> signInWithGoogle();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<String> signIn(String email, String password) async {
    AuthResult authresult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    print('USERID : ' + authresult.user.uid);
    if (authresult.user.isEmailVerified) {
      return authresult.user.uid;
    }
    return null;
  }

  Future<String> createUser(String email, String password) async {
    AuthResult authresult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    try {
      await authresult.user.sendEmailVerification();
      return null;
    } catch (e) {
      print("An error occured while trying to send email verification");
      print(e.message);
    }
  }

  Future<FirebaseUser> user() async {
    return await _firebaseAuth.currentUser();
  }

  Future<String> currentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    //print('USERID : ' + user.uid);
    return user != null ? user.uid : null;
  }

  Future<String> userEmail() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    //print('USER EMAIL : ' + user.email);
    return user != null ? user.email : null;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _firebaseAuth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _firebaseAuth.currentUser();
    print("HEAD4S UP HERE HEHEHEH");
    print(user.uid);
    assert(user.uid == currentUser.uid);

    return user.uid;
  }
}
