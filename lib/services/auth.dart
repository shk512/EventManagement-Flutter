import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_management/services/db.dart';
import 'package:event_management/services/spf.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class Auth {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //Register
  Future<Object?> createUser(String email, String pass) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: pass))
          .user!;
      if (user != null) {
        return user.uid;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //login
  Future signInWithEmailAndPassword(String email, String pass) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: pass))
          .user!;
      if (user != null) {
        return true;
      } else {
        return false;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future updateNewPass(String newPass) async {
    try {
      await firebaseAuth.currentUser?.updatePassword(newPass);
      return true;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //signOut
  Future signOut() async {
    try {
      await SPF.saveUserName("");
      await SPF.savePhone("");
      await SPF.saveUserLogInStatus(false);
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }

  //DELETE
  Future deleteUser() async {
    try {
      await Db(id: firebaseAuth.currentUser!.uid).deleteData();
      await firebaseAuth.currentUser!.delete();
      return true;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
