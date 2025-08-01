import 'package:flutter/material.dart';
import '../methods/auth_methods.dart'; // Import AuthMethods
import '../models/user.dart'; // Import Users class

class UserProvider with ChangeNotifier {
  // Private variables
  Users? _user; // To store the user data
  final AuthMethods _authMethods = AuthMethods(); // AuthMethods instance

  // Getter for _user
  Users? get getUser => _user;

  // Method to refresh user details
  Future<void> refreshUser() async {
    // Fetch user details using getUserDetails from AuthMethods
    Users? user = await _authMethods.getUserDetails();

    // If user data is retrieved successfully, update the _user variable
    if (user != null) {
      _user = user;
      notifyListeners(); // Notify listeners about the update
    }
  }
}
