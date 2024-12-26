import 'package:entitle_guard/features/Screens/Welcome/Splash_Screen/bloc/event.dart';
import 'package:entitle_guard/features/Screens/Welcome/Splash_Screen/bloc/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenAuthenticationBloc
    extends Bloc<SplashScreenEvent, SplashScreenState> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  SplashScreenAuthenticationBloc() : super(SplashScreenUnauthenticated()) {
    on<SplashScreenAppStarted>((event, emit) async {
      final isFirstTime = await _checkFirstTime();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      print(isLoggedIn);
      print("isLoggedIn");
      if (isFirstTime) {
        emit(FirstTimeUser());
      } else {
        // final currentUser = _auth.currentUser;
        if (isLoggedIn) {
          final googleSignInAccount = await _googleSignIn.signIn();
          emit(SplashScreenAuthenticated(googleSignInAccount!));
        } else {
          emit(SplashScreenUnauthenticated());
        }
      }
    });
  }

  Future<bool> _checkFirstTime() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final isFirstTime = prefs.getBool('isFirstTime') ?? true;
    if (isFirstTime) {
      prefs.setBool('isFirstTime', false);
    }
    return isFirstTime;
  }
}

// import 'package:entitle_guard/features/Screens/Welcome/Splash_Screen/bloc/event.dart';
// import 'package:entitle_guard/features/Screens/Welcome/Splash_Screen/bloc/state.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SplashScreenAuthenticationBloc
//     extends Bloc<SplashScreenEvent, SplashScreenState> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn();

//   SplashScreenAuthenticationBloc() : super(SplashScreenUnauthenticated()) {
//     on<SplashScreenAppStarted>((event, emit) async {
//       final isFirstTime = await _checkFirstTime();

//       if (isFirstTime) {
//         emit(FirstTimeUser());
//       } else {
//         final currentUser = _auth.currentUser;
//         if (currentUser != null) {
//           final googleSignInAccount = await _googleSignIn.signIn();
//           final email = currentUser.email;
//           if (email != null) {
//             final prefs = await SharedPreferences.getInstance();
//             final storedEmail = prefs.getString('email');
//             if (storedEmail == email) {
//               emit(
//                   SplashScreenAuthenticated(currentUser, googleSignInAccount!));
//             }
//           }
//         } else {
//           emit(SplashScreenUnauthenticated());
//         }
//       }
//     });
//   }

//   Future<bool> _checkFirstTime() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     final isFirstTime = prefs.getBool('isFirstTime') ?? true;
//     if (isFirstTime) {
//       prefs.setBool('isFirstTime', false);
//     }
//     return isFirstTime;
//   }
// }
