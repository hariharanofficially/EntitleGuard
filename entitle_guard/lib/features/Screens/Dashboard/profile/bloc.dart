import 'package:entitle_guard/Utils/theme.dart';
import 'package:entitle_guard/features/Screens/Welcome/Signin/widget/Signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileBloc extends ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  late final FirebaseAuth _auth;

  ProfileBloc() {
    _auth = FirebaseAuth.instance;
  }
  String? _email;
  String? _name;
  String? _photoUrl;

  // Getter methods for user data
  String? get email => _email;
  String? get name => _name;
  String? get photoUrl => _photoUrl;

  // Method to set user email
  void setEmail(String email) {
    _email = email;
    notifyListeners(); // Notify listeners of the change
  }

  // Method to set user name
  void setName(String name) {
    _name = name;
    notifyListeners(); // Notify listeners of the change
  }

  // Method to set user photo URL
  void setPhotoUrl(String photoUrl) {
    _photoUrl = photoUrl;
    notifyListeners(); // Notify listeners of the change
  }

  void signOut(BuildContext context) async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Signin()),
    );
  }

  void toggleDarkMode(BuildContext context) {
    Provider.of<ThemeProviderNotifier>(context, listen: false)
        .toggleThemeMode();
  }
}
