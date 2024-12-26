import 'package:entitle_guard/features/Screens/Welcome/Splash_Screen/bloc/bloc.dart';
import 'package:entitle_guard/features/Screens/Welcome/Splash_Screen/bloc/event.dart';
import 'package:entitle_guard/features/Screens/Welcome/Splash_Screen/view/Splash_screen_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';


class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SplashScreenAuthenticationBloc()..add(SplashScreenAppStarted()),
      child: SplashScreenView(),
    );
  }
}

// import 'dart:async';
// import 'package:entitle_guard/Screens/Welcome/welcome.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:entitle_guard/Screens/Welcome/Signin.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../Services/check_google_authentication.dart';
// import '../Dashboard/Dashboard.dart';

// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   late Timer _timer;
//   late SharedPreferences _prefs;

//   @override
//   void initState() {
//     super.initState();
//     _timer = Timer(Duration(seconds: 1), () {
//       // Your initialization code here
//     });
//     _initialize();
//   }

//   Future<void> _initialize() async {
//     _prefs = await SharedPreferences.getInstance();
//     bool isFirstTime = _prefs.getBool('isFirstTime') ?? true;

//     if (isFirstTime) {
//       _prefs.setBool('isFirstTime', false);
//       _navigateToWelcomePage();
//     } else {
//       checkLoggedInUser();
//     }
//   }

//   void _navigateToWelcomePage() {
//     _timer = Timer(
//       Duration(seconds: 3),
//       () {
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(
//             builder: (context) => Welcome(),
//           ),
//         );
//       },
//     );
//   }

//   Future<void> checkLoggedInUser() async {
//     final Auth_Service authService = Auth_Service();
//     final User? user = await authService.checkCurrentUser();

//     await Future.delayed(Duration(seconds: 3)); // Simulate splash screen delay

//     if (user != null) {
//       // User is already logged in, navigate to dashboard
//       // Navigator.pushReplacement(
//       //   context,
//       //   MaterialPageRoute(builder: (context) => Dashboard(user)),
//       // );
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => Dashboard(user: user)),
//       );
//     } else {
//       // User not logged in, navigate to login or signup page
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => Signin()),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     // Dispose the timer when the widget is disposed
//     _timer.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             FlutterLogo(
//               size: 200,
//             ),
//             SizedBox(height: 20),
//             CircularProgressIndicator(), // Add a loading animation
//           ],
//         ),
//       ),
//     );
//   }
// }