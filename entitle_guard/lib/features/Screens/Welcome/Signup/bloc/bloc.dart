// Define the sign-in BLoC
// ignore_for_file: unnecessary_null_comparison

import 'package:entitle_guard/data/Models/apimodels.dart';
import 'package:entitle_guard/data/Services/api.dart';
import 'package:entitle_guard/features/Screens/Welcome/Signup/bloc/event.dart';
import 'package:entitle_guard/features/Screens/Welcome/Signup/bloc/state.dart';

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  Logger logger = new Logger();
  GoogleSignInAccount? _googleSignInAccount; // Add this property

  // Constructor
  SignupBloc() : super(SignupState.initial) {
    on<SignupEvent>((event, emit) async {
      await loginUser(emit, event);
    });
  }

  // Method to sign in with Google
  loginUser(
    Emitter<SignupState> emit,
    SignupEvent event,
  ) async {
    if (event == SignupEvent.signInWithGoogle) {
      emit(SignupState.loading); // Emit loading state when signing in
      try {
        await _googleSignIn.signOut();
        // Sign in with Google
        final GoogleSignInAccount? googleSignInAccount =
            await _googleSignIn.signIn();

        if (googleSignInAccount == null) {
          // User canceled Google Sign-In
          emit(SignupState.initial);
          return;
        }

        // Set the GoogleSignInAccount property
        logger.d(googleSignInAccount);
        _googleSignInAccount = googleSignInAccount;
        final email = googleSignInAccount.email;
        final name = googleSignInAccount.displayName;
        final photo = googleSignInAccount.photoUrl;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_email', email ?? '');
        await prefs.setString('user_name', name ?? '');
        await prefs.setString('user_photo', photo ?? '');
        if (googleSignInAccount != null) {
          final Login? loginResp = await signup_POST(
              googleSignInAccount.email, googleSignInAccount.displayName!);
          // SharedPreferences prefs = await SharedPreferences.getInstance();
          // await prefs.setBool('isLoggedIn', true);
          if (loginResp?.jwt != null) {
            await _saveTokenLocally(loginResp!.jwt, loginResp!.userId);
            emit(SignupState.navigateToDashboard);
          } else {
            emit(SignupState.errormessage);
          }
        }
        // Navigate to the appropriate screen based on whether the user is new or existing
        // emit(SignupState.navigateToDashboard);
      } catch (e) {
        print('Error signing in with Google: $e');
        emit(SignupState.initial);
      }
    }
  }

  // Getter to access the GoogleSignInAccount instance
  GoogleSignInAccount? get googleSignInAccount => _googleSignInAccount;
}

// Function to save JWT token locally
Future<void> _saveTokenLocally(String token, int userId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('jwtToken', token);
  await prefs.setInt('userId', userId);
}
// Future<bool> checkEmailMatch(String email) async {
//   final snapshot =
//       await FirebaseFirestore.instance.collection('users').doc(email).get();
//   return snapshot.exists;
// }
