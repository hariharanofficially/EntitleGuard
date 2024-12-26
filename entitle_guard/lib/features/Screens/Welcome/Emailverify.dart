// ignore_for_file: unused_local_variable

import 'package:entitle_guard/Utils/theme.dart';
import 'package:entitle_guard/data/Services/api.dart';
import 'package:entitle_guard/features/Screens/Dashboard/Dashboard.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class emailverify extends StatelessWidget {
  const emailverify({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: emailverifyScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class emailverifyScreen extends StatefulWidget {
  emailverifyScreen({Key? key}) : super(key: key);

  @override
  _emailverifyScreenState createState() => _emailverifyScreenState();
}

class _emailverifyScreenState extends State<emailverifyScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController _otpController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Color?> digitColors = [null, null, null, null, null, null];
  GoogleSignInAccount? user;

  @override
  Widget build(BuildContext context) {
    final themeMode = Provider.of<ThemeProviderNotifier>(context).themeMode;
    final isDarkMode = themeMode == ThemeModeType.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Verify your Email",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Please enter the verification code \nsent to your Email",
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 60),
              Text(
                'Enter 4-digit OTP',
                style: TextStyle(
                    fontSize: 18,
                    color: isDarkMode ? Colors.white : Colors.black),
              ),
              Padding(
                padding: EdgeInsets.only(left: 40, top: 20, right: 40),
                child: Form(
                  key: _formKey,
                  child: PinCodeTextField(
                    appContext: context,
                    key: ValueKey(
                      "otpField",
                    ),
                    controller: _otpController,
                    length: 4,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      fieldHeight: 50,
                      fieldWidth: 40,
                      inactiveFillColor: Colors.transparent,
                      activeFillColor: Colors.transparent,
                      activeColor: isDarkMode ? Colors.white : Colors.black,
                      inactiveColor: Colors.grey,
                    ),
                    validator: (value) {
                      if (value == null || value.length != 4) {
                        return "Invalid OTP";
                      }
                      return null;
                    },
                  ),
                ),
              ),
              SizedBox(height: 100),
              ElevatedButton(
                onPressed: () async {
                  final GoogleSignIn googleSignIn = GoogleSignIn();
                  final GoogleSignInAccount? user = await googleSignIn.signIn();
                  // Store email and OTP from text controller
                  String email =
                      user!.email; // Replace with actual email retrieval logic
                  String otp = _otpController.text.trim();
                  // Validate OTP input
                  if (_formKey.currentState!.validate()) {
                    // Perform OTP verification
                    final otpResponse = await OTP_POST(email, otp, context);
                    print('otpResponse');
                    print(otpResponse);
                    if (otpResponse == null) {
                      // OTP verification successful
                      // String? firstName = user.displayName;
                      // String? lastName = '';
                      // // Proceed with the signup process
                      // final signupResponse = await signup_POST(
                      //   email,
                      //   firstName!,
                      //   lastName!,
                      //   context,
                      // );
                      // Handle signup response if needed

                      // Navigate to the dashboard page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Dashboard(),
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  //primary: Colors.lightGreen,
                  padding: EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Verify OTP',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
