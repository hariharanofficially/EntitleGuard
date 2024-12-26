import 'package:entitle_guard/features/Screens/Welcome/Signup/bloc/bloc.dart';
import 'package:entitle_guard/features/Screens/Welcome/Signup/view/Signup_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Signup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => SignupBloc(),
        child: SignupContent(),
      ),
    );
  }
}
// import 'package:entitle_guard/Screens/Welcome/Signin.dart';
// import 'package:entitle_guard/Screens/Welcome/confirm.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:provider/provider.dart';
// import '../../Utils/theme.dart';

// class Signup extends StatefulWidget {
//   const Signup({super.key});

//   @override
//   State<Signup> createState() => _SignupState();
// }

// class _SignupState extends State<Signup> {
//   final GoogleSignIn _googleSignIn = GoogleSignIn();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   Future<User?> _handleSignIn() async {
//     try {
//       final GoogleSignInAccount? googleSignInAccount =
//           await _googleSignIn.signIn();
//       final GoogleSignInAuthentication googleSignInAuthentication =
//           await googleSignInAccount!.authentication;

//       final AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleSignInAuthentication.accessToken,
//         idToken: googleSignInAuthentication.idToken,
//       );

//       final UserCredential authResult =
//           await _auth.signInWithCredential(credential);
//       final User? user = authResult.user;

//       return user;
//     } catch (error) {
//       print(error);
//       return null;
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
//               child: Column(
//                 children: [
//                   SizedBox(
//                     height: 70,
//                   ),
//                   Column(
//                     children: [
//                       Image(
//                           image: AssetImage("assets/images/Signup.jpg"),
//                           width: 300,
//                           height: 500,
//                           fit: BoxFit.scaleDown,
//                           alignment: FractionalOffset.center),
//                       OutlinedButton.icon(
//                         onPressed: () async {
//                           // signInWithGoogle();
//                           User? user = await _handleSignIn();
//                           if (user != null) {
//                             // Navigate to the next screen to show user information
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => confirmdetails(user)),
//                             );
//                           } else {
//                             // Show an error message or handle the sign-in failure
//                           }
//                         },
//                         icon: Padding(
//                           padding: const EdgeInsets.only(right: 20),
//                           child: Container(
//                             margin: EdgeInsets.fromLTRB(40, 5, 0, 0),
//                             child: FaIcon(
//                               FontAwesomeIcons.google,
//                               color: Color.fromARGB(255, 212, 9, 9),
//                             ),
//                           ),
//                         ),
//                         style: ButtonStyle(
//                           fixedSize: MaterialStateProperty.all<Size>(
//                             Size(330.0,
//                                 60.0), // Set the desired width and height
//                           ),

//                           side: MaterialStateProperty.all<BorderSide>(
//                             BorderSide(
//                               color: Colors
//                                   .lightGreenAccent, // Change the border color here
//                               width: 2.0, // Change the border width here
//                             ),
//                           ),

//                           elevation: MaterialStateProperty.all<double>(
//                               10.0), // Shadow elevation
//                           backgroundColor: MaterialStateProperty.all<Color>(
//                               Colors.white), // Button background color
//                           shadowColor: MaterialStateProperty.all<Color>(
//                               Colors.grey), // Shadow color
//                         ),
//                         label: Padding(
//                           padding: const EdgeInsets.only(right: 18),
//                           child: Container(
//                             margin: EdgeInsets.fromLTRB(0, 3, 20, 0),
//                             child: Text(
//                               '    Sign Up with Google',
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 14,
//                                 fontFamily: 'Karla',
//                                 fontWeight: FontWeight.w700,
//                                 height: 0.26,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.fromLTRB(80, 0, 0, 0),
//                         child: Row(
//                           children: [
//                             Text(
//                               "Already have an account?",
//                               style: TextStyle(
//                                 color: isDarkMode ? Colors.white : Colors.black,
//                               ),
//                             ),
//                             TextButton(
//                               onPressed: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => Signin()),
//                                 );
//                               },
//                               child: Padding(
//                                 padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
//                                 child: Text('Sign In'),
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         )));
//   }
// }
