import 'package:google_sign_in/google_sign_in.dart';

abstract class SplashScreenState {}

class SplashScreenAuthenticated extends SplashScreenState {
  final GoogleSignInAccount googleSignInAccount;

  SplashScreenAuthenticated(this.googleSignInAccount);
}

class SplashScreenUnauthenticated extends SplashScreenState {}

class FirstTimeUser extends SplashScreenState {}
