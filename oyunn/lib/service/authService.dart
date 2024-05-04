import 'package:oyunn/service/databaseService.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../controller/helper.dart';

class AuthService {


  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;


  // ignore: non_constant_identifier_names
  Future LoginUserWithEmailandPassword(String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;

      // ignore: unnecessary_null_comparison
      if (user != null) {
        
        return true;
      } else {

        return "Bu kullanıcı bulunamadı.";
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }

  }

  Future registerUserWithEmailandPassword(
      String fullname, String email, String password) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;

      // ignore: unnecessary_null_comparison
      if (user != null) {
       
        DatabaseService(uid: user.uid).savingUserData(fullname, email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      print(e);
    }

  }

  Future handleGoogleSignIn() async {
    try {
      GoogleAuthProvider _googleAuthProvider = GoogleAuthProvider();

      User user =
          (await firebaseAuth.signInWithProvider(_googleAuthProvider)).user!;

      String email = user.email!;

      String name = user.displayName.toString();

      
      // ignore: unnecessary_null_comparison
      if (user != null) {

        DatabaseService(uid: user.uid).savingUserData(email, email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      print(e);
    }


  }


  Future SignOut() async {
    try {
      await HelperFunctions.saveuserLoggIdstate(false);

      await HelperFunctions.saveuserEmailSF("");
      await HelperFunctions.saveuserNameSF("");

      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }
}
