import 'dart:async';
import 'package:entitle_guard/features/Screens/Welcome/Splash_Screen/bloc/bloc.dart';
import 'package:entitle_guard/features/Screens/Welcome/Splash_Screen/bloc/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:entitle_guard/features/Screens/Welcome/Signin/widget/Signin.dart';
import 'package:entitle_guard/features/Screens/Welcome/Welcome/widget/welcome.dart';
import 'package:entitle_guard/features/Screens/Dashboard/Dashboard.dart';

class SplashScreenView extends StatefulWidget {
  @override
  _SplashScreenViewState createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {
  late Timer _timer;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _timer = Timer(Duration(seconds: 1), () {});
    _initialize();
  }

  Future<void> _initialize() async {
    _prefs = await SharedPreferences.getInstance();
    bool isFirstTime = _prefs.getBool('isFirstTime') ?? true;

    if (isFirstTime) {
      _prefs.setBool('isFirstTime', false);
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SplashScreenAuthenticationBloc, SplashScreenState>(
        listener: (context, state) {
          if (state is SplashScreenAuthenticated) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Dashboard()),
            );
          } else if (state is SplashScreenUnauthenticated) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Signin()),
            );
          }
        },
        builder: (context, state) {
          if (state is FirstTimeUser) {
            _timer = Timer(
              Duration(seconds: 3),
              () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => Welcome(),
                  ),
                );
              },
            );
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 200, // Adjust size as needed
                  height: 200,
                ),
                SizedBox(height: 20),
                CircularProgressIndicator(),
              ],
            ),
          );
        },
      ),
    );
  }
}
