import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class AuthServices {
  // sign up user
  Future signUpUser(
      String email, String password, String name, BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await FirebaseAuth.instance.currentUser!.updateDisplayName(name);
      await FirebaseAuth.instance.currentUser!.updateEmail(email);
      return showAlert(context, name);
    } on FirebaseAuthException catch (signUpError) {
      if (signUpError is PlatformException) {
        if (signUpError.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
          print('user already registered');
        }
      }
    }
  }

  Future signInUser(String email, String password, BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) => Navigator.pushReplacementNamed(context, '/home'));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found with that email');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided');
      }
    }
  }

  static signUserOut(BuildContext context) {
    FirebaseAuth.instance.signOut();
    print('logged out');
  }
}

Future<void> showAlert(BuildContext context, String name) async {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text("Sign Up"),
          content: Text('User $name registered successfully'),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/Login');
                },
                child: const Text("OK"))
          ],
        );
      });
}
