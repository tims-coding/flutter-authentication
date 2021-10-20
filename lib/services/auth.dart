import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';

class AuthService {
  final _googleSignIn = GoogleSignIn();
  final _auth = FirebaseAuth.instance;

  // Firebase user one-time fetch
  Future<User> get getUser async => _auth.currentUser;

  Stream<User> get user => _auth.authStateChanges();

  // Google Sign In
  Future<User> googleSignIn() async {
    try {
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential result = await _auth.signInWithCredential(credential);
      User user = result.user;

      // Update user data
      //updateUserData(user);

      return user;
    } catch (error) {
      print(error);
      return null;
    }
  }

  // Anonymous Log In
  Future<User> anonLogin() async {
    UserCredential result = await _auth.signInAnonymously();
    User user = result.user;

    //updateUserData(user);
    return user;
  }

  // Sign In with Email & Password
  Future<User> signInEmailPassword(String email, String password) async {
    UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    User user = result.user;

    //updateUserData(user);
    return user;
  }

  // Create User with Email & Password
  Future<User> createUserEmailPassword(String email, String password) async {
    UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    User user = result.user;
    //updateUserData(user);
    return user;
  }

  // Reset Password with User Email
  Future resetPassword(String email) async {
    _auth.sendPasswordResetEmail(email: email);
  }

  Future resetPasswordPhone() async {
    String email = _auth.currentUser.email;
    _auth.sendPasswordResetEmail(email: email);
    return email;
  }

  // Send Phone Verification
  Future sendPhoneVerification(String phone) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (phoneAuthCredential) async {},
      verificationFailed: (verificationFailed) async {},
      codeSent: (verificationId, resendingToken) async {},
      codeAutoRetrievalTimeout: (verificatioId) async {},
    );
  }

  // update on new log
  //Future<void> updateUserData(User user) {
  //  DocumentReference reportRef = _db.collection('reports').doc(user.uid);

  //  return reportRef.set({
  //    'uid': user.uid,
  //    'lastActivity': DateTime.now(),
  //  }, SetOptions(merge: true));
  // }

  // Sign out
  Future<void> signOut() {
    GoogleSignIn().disconnect();
    return _auth.signOut();
  }
}
