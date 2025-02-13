// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart';

// class AuthService {
//   Future<void>sighnUp({
//     required email,
//     required password
//   })async{
//     try{
//       await FirebaseAuth.instance.createUserWithEmailAndPassword(
//         email: email, password: password);
//     }on FirebaseAuthException catch(e){
//       String message='';
//       if(e.code=='week-password'){
//      message=' password is week ';
//       }else if(e.code=="email-already-in-use"){
//   message ='An account already exits with that email';
//       }
    
//     }
//     catch(e){}
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kuri_application/Views/HomeScreen/homeScreen.dart';
import 'package:kuri_application/Views/LogInScreen/logInScreen.dart';

class AuthService {
  Future<void> signUp({
    required String email,
    required String password,
    required String phoneNumber,
    required String name,
    required BuildContext context, // Add BuildContext to show UI elements
  }) async {
    try {
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

        // Step 2: Save user data (name, email, phoneNumber) to Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
        'name': name,
        'email': email,
        'phoneNumber': phoneNumber,
      });

      await Future.delayed(Duration(seconds: 1));
      Get.off(HomeScreen());
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'weak-password') {
        message = 'Password is too weak. Please use a stronger password.';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists with that email.';
      } else if (e.code == 'invalid-email') {
        message = 'The email address is invalid.';
      } else {
        message = 'Something went wrong. Please try again later.';
      }

      // Show the error message in a Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      print('jishad==========: $e');
      // Show a generic error message in case of unexpected errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred. Please try again.')),
      );
    }
  }





  Future<void> signIn({
    required String email,
    required String password,
    required BuildContext context, // Add BuildContext to show UI elements
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await Future.delayed(Duration(seconds: 1));
      Get.off(HomeScreen());
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'user-not-found') {
        message = 'no user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'wrong password.';
      } 

      // Show the error message in a Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message,style:TextStyle(color: Colors.white),)),
      );
    } catch (e) {
      print('jishad==========: $e');
      // Show a generic error message in case of unexpected errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred. Please try again.')),
      );
    }
  }


  Future<void>signOut({
    required BuildContext context,

  })async{
  await FirebaseAuth.instance.signOut();
  await Future.delayed(Duration(seconds: 1));
    Get.off(LoginScreen());
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('SignOut.')),
      );
      

  }
}

