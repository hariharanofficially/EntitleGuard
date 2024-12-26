
import 'package:entitle_guard/features/Screens/Welcome/Signin/bloc/bloc.dart';
import 'package:entitle_guard/features/Screens/Welcome/Signin/view/Signin_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Signin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => SigninBloc(),
        child: SigninContent(),
      ),
    );
  }
}

// import 'dart:async';

// import 'package:entitle_guard/Screens/Welcome/Signup.dart';
// import 'package:entitle_guard/Screens/Dashboard/Dashboard.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:provider/provider.dart';
// import '../../Utils/theme.dart';

// class Signin extends StatefulWidget {
//   const Signin({
//     super.key,
//   });

//   @override
//   State<Signin> createState() => _SigninState();
// }

// class _SigninState extends State<Signin> {
//   final GoogleSignIn _googleSignIn = GoogleSignIn();
//   bool loading = false;

//   Future<void> signInWithGoogle() async {
//     setState(() {
//       loading = true; // Set loading state to true when signing in
//     });

//     // Sign out from previous Google sign-in
//     await _googleSignIn.signOut();

//     try {
//       // Sign in with Google
//       final GoogleSignInAccount? googleSignInAccount =
//           await _googleSignIn.signIn();

//       if (googleSignInAccount == null) {
//         // User canceled Google Sign-In
//         setState(() {
//           loading =
//               false; // Set loading state to false when sign-in process is complete
//         });
//         return;
//       }

//       final GoogleSignInAuthentication googleSignInAuthentication =
//           await googleSignInAccount.authentication;

//       final AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleSignInAuthentication.accessToken,
//         idToken: googleSignInAuthentication.idToken,
//       );

//       final UserCredential userCredential =
//           await FirebaseAuth.instance.signInWithCredential(credential);

//       final User user = userCredential.user!;

//       // Navigate to the appropriate screen based on whether the user is new or existing
//       if (userCredential.additionalUserInfo?.isNewUser ?? false) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => Signup()),
//         );
//       } else {
//         // Navigator.push(
//         //   context,
//         //   MaterialPageRoute(builder: (context) => Dashboard(user)),
//         // );
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => Dashboard(user: user)),
//         );
//       }
//     } catch (e) {
//       print('Error signing in with Google: $e');
//     } finally {
//       setState(() {
//         loading =
//             false; // Set loading state to false when sign-in process is complete
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
//     final themeMode = Provider.of<ThemeProviderNotifier>(context).themeMode;
//     final isDarkMode = themeMode == ThemeModeType.dark;
//     return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         home: SafeArea(
//             child: Scaffold(
//           backgroundColor: isDarkMode ? Colors.black : Colors.white,
//           body: SingleChildScrollView(
//             child: Center(
//               child: Stack(children: [
//                 Column(
//                   children: [
//                     SizedBox(
//                       height: 70,
//                     ),
//                     Column(
//                       children: [
//                         Image(
//                             image: AssetImage("assets/images/Login.jpg"),
//                             width: 300,
//                             height: 500,
//                             fit: BoxFit.scaleDown,
//                             alignment: FractionalOffset.center),
//                         OutlinedButton.icon(
//                           onPressed: () {
//                             signInWithGoogle();
//                           },
//                           icon: Padding(
//                             padding: const EdgeInsets.only(right: 20),
//                             child: Container(
//                               margin: EdgeInsets.fromLTRB(40, 5, 0, 0),
//                               child: FaIcon(
//                                 FontAwesomeIcons.google,
//                                 color: Color.fromARGB(255, 212, 9, 9),
//                               ),
//                             ),
//                           ),
//                           style: ButtonStyle(
//                             fixedSize: MaterialStateProperty.all<Size>(
//                               Size(300.0,
//                                   60.0), // Set the desired width and height
//                             ),
//                             side: MaterialStateProperty.all<BorderSide>(
//                               BorderSide(
//                                 color: Colors
//                                     .lightGreenAccent, // Change the border color here
//                                 width: 2.0, // Change the border width here
//                               ),
//                             ),

//                             elevation: MaterialStateProperty.all<double>(
//                                 10.0), // Shadow elevation
//                             backgroundColor: MaterialStateProperty.all<Color>(
//                                 Colors.white), // Button background color
//                             shadowColor: MaterialStateProperty.all<Color>(
//                                 Colors.grey), // Shadow color
//                           ),
//                           label: Padding(
//                             padding: const EdgeInsets.only(right: 18),
//                             child: Container(
//                               margin: EdgeInsets.fromLTRB(0, 5, 10, 0),
//                               child: Text(
//                                 '    Login with Google',
//                                 style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 14,
//                                   fontFamily: 'Karla',
//                                   fontWeight: FontWeight.w700,
//                                   height: 0.26,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.fromLTRB(80, 0, 0, 0),
//                           child: Row(
//                             children: [
//                               Text(
//                                 "Don't have an account?",
//                                 style: TextStyle(
//                                   color:
//                                       isDarkMode ? Colors.white : Colors.black,
//                                 ),
//                               ),
//                               TextButton(
//                                 onPressed: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) => Signup()),
//                                   );
//                                 },
//                                 child: Padding(
//                                   padding:
//                                       const EdgeInsets.fromLTRB(0, 0, 0, 0),
//                                   child: Text('New Register'),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//                 if (loading) // Show CircularProgressIndicator when loading is true
//                   Center(child: CircularProgressIndicator()),
//               ]),
//             ),
//           ),
//         )));
//   }
// }
