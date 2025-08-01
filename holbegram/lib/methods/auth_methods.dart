import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:typed_data';
import '../models/user.dart';
import 'package:uuid/uuid.dart';

class AuthMethods {
  // Firebase authentication and Firestore instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Login Method
  Future<String> login({
    required String email,
    required String password,
  }) async {
    String res = "An error occurred";
    try {
      if (email.isEmpty || password.isEmpty) {
        res = "Please fill all the fields";
      } else {
        // Use FirebaseAuth to sign in
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      }
    } catch (err) {
      res = err.toString(); // Return error message in case of failure
    }
    return res;
  }

  // Sign Up Method
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    Uint8List? file,
  }) async {
    String res = "An error occurred";
    try {
      if (email.isEmpty || password.isEmpty || username.isEmpty) {
        res = "Please fill all the fields";
      } else {
        // Create a new user with Firebase Authentication
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Getting the created user
        User? user = userCredential.user;

        if (user != null) {
          // Create a new Users instance
          Users users = Users(
            uid: user.uid,
            email: email,
            username: username,
            bio: '',
            photoUrl: randomPhotoUrl(),
            followers: [],
            following: [],
            posts: [],
            saved: [],
            searchKey: username.substring(0, 1).toUpperCase(),
          );

          // Save the user information to Firestore
          await _firestore
              .collection("users")
              .doc(user.uid)
              .set(users.toJson());
          res = "success";
        }
      }
    } catch (err) {
      res = err.toString(); // Return error message in case of failure
    }
    return res;
  }

  // getUserDetails method
  Future<Users?> getUserDetails() async {
    try {
      // Get the current Firebase user
      User? currentUser = _auth.currentUser;

      // If the user is authenticated
      if (currentUser != null) {
        // Retrieve the user document from Firestore
        DocumentSnapshot userSnap =
            await _firestore.collection('users').doc(currentUser.uid).get();

        // Return a Users object using the fromSnap method
        return Users.fromSnap(userSnap);
      }
    } catch (err) {
      print("Error getting user details: $err");
    }
    return null; // Return null if the user is not authenticated or an error occurs
  }
}

randomPhotoUrl() {
  String id = const Uuid().v4();
  return 'https://picsum.photos/seed/$id/300/200';
}
