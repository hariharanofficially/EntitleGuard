// // ignore_for_file: unnecessary_null_comparison

// import 'package:entitle_guard/features/Screens/Welcome/Signin/bloc/event.dart';
// import 'package:entitle_guard/features/Screens/Welcome/Signin/bloc/state.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// // Define the sign-in BLoC
// class SigninBloc extends Bloc<SigninEvent, SigninState> {
//   final GoogleSignIn _googleSignIn = GoogleSignIn();
//   GoogleSignInAccount? _googleSignInAccount; // Add this property

//   // SigninBloc() : super(SigninState.initial);
//   SigninBloc() : super(SigninState.initial) {
//     on<SigninEvent>((event, emit) async {
//       await loginUser(emit, event);
//     });
//   }

//   loginUser(Emitter<SigninState> emit, SigninEvent event) async {
//     if (event == SigninEvent.signInWithGoogle) {
//       emit(SigninState.loading); // Emit loading state when signing in
//       try {
//         // Sign in with Google
//         final GoogleSignInAccount? googleSignInAccount =
//             await _googleSignIn.signIn();

//         if (googleSignInAccount == null) {
//           // User canceled Google Sign-In
//           emit(SigninState.initial);
//           return;
//         }
//         // Set the GoogleSignInAccount property
//         _googleSignInAccount = googleSignInAccount;

//         final String? googleEmail = googleSignInAccount.email;
//         print(googleEmail);
//         // final FirebaseAuth auth = FirebaseAuth.instance;
//         // final User? user = auth.currentUser;
//         // final String? firebaseEmail = user?.email;

//         Future<void> fetchUserData(String uid) async {
//           print(fetchUserData(uid));
//           print('object');
//           try {
//             UserCredential userCredential =
//                 await FirebaseAuth.instance.signInAnonymously();
//             User? user = userCredential.user;
//             print('Successfully fetched user data: ${user?.uid}');
//           } catch (e) {
//             print('Failed to fetch user data: $e');
//           }
//         }

//         FirebaseAuth.instance.authStateChanges().listen((User? user) {
//           if (user != null) {
//             print(user.uid);
//           }
//         });
//         // Check if both emails are available
//         if (googleEmail != null && fetchUserData != null) {
//           if (googleEmail == fetchUserData) {
//             emit(SigninState.navigateToDashboard);
//           } else {
//             emit(SigninState.navigateToSignup);
//           }
//         } else {
//           // If any of the emails are null, handle the error accordingly
//           print('Error: Google or Firebase email is null');
//           emit(SigninState.initial);
//         }
//       } catch (e) {
//         print('Error signing in with Google: $e');
//         emit(SigninState.initial);
//       }
//     }
//   }

//   // Getter to access the GoogleSignInAccount instance
//   GoogleSignInAccount? get googleSignInAccount => _googleSignInAccount;
// }

// import 'package:entitle_guard/features/Screens/Welcome/Signin/bloc/event.dart';
// import 'package:entitle_guard/features/Screens/Welcome/Signin/bloc/state.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences package for local storage

// class SigninBloc extends Bloc<SigninEvent, SigninState> {
//   final GoogleSignIn _googleSignIn = GoogleSignIn();
//   GoogleSignInAccount? _googleSignInAccount;

//   SigninBloc() : super(SigninState.initial) {
//     on<SigninEvent>((event, emit) async {
//       await loginUser(emit, event);
//     });
//   }

//   loginUser(Emitter<SigninState> emit, SigninEvent event) async {
//     if (event == SigninEvent.signInWithGoogle) {
//       emit(SigninState.loading);
//       try {
//         final GoogleSignInAccount? googleSignInAccount =
//             await _googleSignIn.signIn();

//         if (googleSignInAccount == null) {
//           emit(SigninState.initial);
//           return;
//         }

//         _googleSignInAccount = googleSignInAccount;

//         // Get user's email from GoogleSignInAccount
//         final String? email = googleSignInAccount.email;

//         if (email != null) {
//           // Get stored email from SharedPreferences
//           final prefs = await SharedPreferences.getInstance();
//           final storedEmail = prefs.getString('email');

//           if (storedEmail == email) {
//             // Navigate to dashboard if the stored email matches the signed-in email
//             emit(SigninState.navigateToDashboard);
//           } else {
//             // If the emails don't match or no email is stored, store the signed-in email
//             // await prefs.setString('email', email);
//             emit(SigninState.navigateToSignup);
//           }
//         } else {
//           print('Error: Email is null');
//           emit(SigninState.initial);
//         }
//       } catch (e) {
//         print('Error signing in with Google: $e');
//         emit(SigninState.initial);
//       }
//     }
//   }

//   GoogleSignInAccount? get googleSignInAccount => _googleSignInAccount;
// }

// ignore_for_file: unnecessary_null_comparison


import 'package:entitle_guard/data/Models/apimodels.dart';
import 'package:entitle_guard/data/Services/api.dart';
import 'package:entitle_guard/features/Screens/Welcome/Signin/bloc/event.dart';
import 'package:entitle_guard/features/Screens/Welcome/Signin/bloc/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Define the sign-in BLoC
class SigninBloc extends Bloc<SigninEvent, SigninState> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _googleSignInAccount; // Add this property

  SigninBloc() : super(SigninState.initial) {
    on<SigninEvent>((event, emit) async {
      await loginUser(emit, event);
    });
  }

  loginUser(Emitter<SigninState> emit, SigninEvent event) async {
    if (event == SigninEvent.signInWithGoogle) {
      emit(SigninState.loading); // Emit loading state when signing in
      try {
        await _googleSignIn.signOut();
        // Sign in with Google
        final GoogleSignInAccount? googleSignInAccount =
            await _googleSignIn.signIn();

        if (googleSignInAccount == null) {
          // User canceled Google Sign-In
          emit(SigninState.initial);
          return;
        }
        // Set the GoogleSignInAccount property
        _googleSignInAccount = googleSignInAccount;
        final email = googleSignInAccount.email;
        final name = googleSignInAccount.displayName;
        final photo = googleSignInAccount.photoUrl;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_email', email ?? '');
        await prefs.setString('user_name', name ?? '');
        await prefs.setString('user_photo', photo ?? '');
        // Check if the email is already in use

        if (googleSignInAccount != null) {
          final Login? loginResp = await login_POST(
              googleSignInAccount.email); // Save JWT token locally
          if (loginResp?.jwt != null) {
            await _saveTokenLocally(loginResp!.jwt, loginResp!.userId);
            print('JWT Token: ${loginResp.jwt}');
            print('UserId: ${loginResp.userId}');
            emit(SigninState.navigateToDashboard);
          } else {
            emit(SigninState.navigateToSignup);
          }
          // // SharedPreferences prefs = await SharedPreferences.getInstance();
          // // await prefs.setBool('isLoggedIn', true);
          // if (isEmailMatch != null) {
          //   emit(SigninState.navigateToDashboard);
          // } else {
          //   emit(SigninState.navigateToSignup);
          // }
        }
      } catch (e) {
        print('Error signing in with Google: $e');
        emit(SigninState.initial);
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
  int? userId1= await prefs.getInt('userId');
  print("userid from shared pref $userId1");
}
// Future<bool> checkEmailMatch(String email) async {
//   final snapshot =
//       await FirebaseFirestore.instance.collection('users').doc(email).get();
//   return snapshot.exists;
// }
