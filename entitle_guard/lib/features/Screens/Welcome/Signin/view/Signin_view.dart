import 'package:entitle_guard/Utils/theme.dart';
import 'package:entitle_guard/features/Screens/Welcome/Signin/bloc/event.dart';
import 'package:entitle_guard/features/Screens/Welcome/Signin/bloc/state.dart';
import 'package:entitle_guard/features/Screens/Welcome/Signup/widget/Signup.dart';
import 'package:entitle_guard/features/Screens/Dashboard/Dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:local_auth/local_auth.dart';
import 'package:entitle_guard/features/Screens/Welcome/Signin/bloc/bloc.dart';

class SigninContent extends StatefulWidget {
  const SigninContent({Key? key}) : super(key: key);

  @override
  _SigninContentState createState() => _SigninContentState();
}

class _SigninContentState extends State<SigninContent> {
  late SigninBloc _bloc;
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<SigninBloc>(context);
  }

  Future<bool> _isBiometricEnabled() async {
    try {
      return await _localAuthentication.canCheckBiometrics;
    } on PlatformException catch (e) {
      print("Error checking biometric availability: $e");
      return false;
    }
  }

  Future<bool> _authenticateWithBiometrics() async {
    try {
      return await _localAuthentication.authenticate(
          localizedReason: 'Please authenticate to proceed',
          options: const AuthenticationOptions(
            biometricOnly: true,
            stickyAuth: false,
            useErrorDialogs: true,
            sensitiveTransaction: false,
          ));
    } on PlatformException catch (e) {
      print("Error authenticating with biometrics: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = Provider.of<ThemeProviderNotifier>(context).themeMode;
    final isDarkMode = themeMode == ThemeModeType.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: BlocConsumer<SigninBloc, SigninState>(
        listener: (context, state) {
          if (state == SigninState.navigateToDashboard) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Dashboard(),
              ),
            );
          } else if (state == SigninState.navigateToSignup) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Signup()),
            );
          }
        },
        builder: (context, state) {
          if (state == SigninState.loading) {
            return Center(child: CircularProgressIndicator());
          } else {
            return SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 70,
                    ),
                    Column(
                      children: [
                        Image(
                          image: AssetImage("assets/images/Login.jpg"),
                          width: 300,
                          height: 500,
                          fit: BoxFit.scaleDown,
                          alignment: FractionalOffset.center,
                        ),
                        OutlinedButton.icon(
                          onPressed: () {
                            _bloc.add(SigninEvent.signInWithGoogle);
                          },
                          icon: Container(
                            //  margin: EdgeInsets.fromLTRB(40, 5, 0, 0),
                            child: FaIcon(
                              FontAwesomeIcons.google,
                              color: Color.fromARGB(255, 212, 9, 9),
                            ),
                          ),
                          style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all<Size>(
                              Size(300.0, 60.0),
                            ),
                            side: MaterialStateProperty.all<BorderSide>(
                              BorderSide(
                                color: Colors.lightGreenAccent,
                                width: 2.0,
                              ),
                            ),
                            elevation: MaterialStateProperty.all<double>(10.0),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            shadowColor:
                                MaterialStateProperty.all<Color>(Colors.grey),
                          ),
                          label: Container(
                            //  margin: EdgeInsets.fromLTRB(0, 5, 10, 0),
                            child: Text(
                              '    Login with Google',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Karla',
                                fontWeight: FontWeight.w700,
                                height: 0.26,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(80, 0, 0, 0),
                          child: Row(
                            children: [
                              Text(
                                "Don't have an account?",
                                style: TextStyle(
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Signup()),
                                  );
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: Text('New Register'),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
