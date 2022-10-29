// ignore_for_file: avoid_print, unused_import, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:project_alpha/model/user.dart' as model;
import 'package:project_alpha/resources/storage_method.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserData() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection("user").doc(currentUser.uid).get();

    return model.User.fromSnap(snap );
  }

  //sign up
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file, //image
  }) async {
    String response = "Some Error Occurred";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty) {
        //REGISTER USER only stores email and password for login
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        print(cred.user!.uid);

        String profilePicUrl = await StorageMethods()
            .uploadImageToStorage("profilePics", file, false); //adding image

        model.User user = model.User(
          username: username,
          uid: cred.user!.uid,
          email: email,
          bio: bio,
          followers: [],
          following: [],
          photoUrl: profilePicUrl,
        );

        await _firestore.collection("users").doc(cred.user!.uid).set(
            user.toJson()); //for name bio and file we use firestore database
        response = "Success";
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == "email-already-in-use") {
        response = "Email is already in use";
      } else if (err.code == "invalid-email") {
        response = "Email entered is invalid";
      }
    } catch (err) {
      response = err.toString();
    }

    return response;
  }

  Future<String> loginUser(
      {required String email, required String password}) async {
    String response = "Some Error Occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        UserCredential cred = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        print(cred.user!.uid);
        response = "Success";
      } else {
        response = "Email or Password cannot be empty";
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == "email-already-in-use") {
        response = "Email is already in use";
      } else if (err.code == "invalid-email") {
        response = "Email entered is invalid";
      }
    } catch (err) {
      response = err.toString();
    }
    return response;
  }
}
