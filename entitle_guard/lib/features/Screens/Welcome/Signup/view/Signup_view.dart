import 'package:entitle_guard/features/Screens/Welcome/Emailverify.dart';
import 'package:entitle_guard/features/Screens/Welcome/Signin/widget/Signin.dart';
import 'package:entitle_guard/features/Screens/Welcome/Signup/bloc/bloc.dart';
import 'package:entitle_guard/features/Screens/Welcome/Signup/bloc/event.dart';
import 'package:entitle_guard/features/Screens/Welcome/Signup/bloc/state.dart';
import 'package:entitle_guard/Utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class SignupContent extends StatefulWidget {
  const SignupContent({Key? key}) : super(key: key);

  @override
  _SignupContentState createState() => _SignupContentState();
}

class _SignupContentState extends State<SignupContent> {
  late SignupBloc _bloc;
  bool alreadySignedUp = false; // Track whether the user has already signed up

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<SignupBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = Provider.of<ThemeProviderNotifier>(context).themeMode;
    final isDarkMode = themeMode == ThemeModeType.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: BlocConsumer<SignupBloc, SignupState>(
        listener: (context, state) {
          if (state == SignupState.navigateToDashboard) {
            // Navigate to the 'confirmdetails' page and pass the user information
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const emailverify(),
              ),
            );
          } else if (state == SignupState.errormessage) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    'Already have account. please choose different account'),
              ),
            );
            alreadySignedUp = true; // Set alreadySignedUp to true
          }
        },
        builder: (context, state) {
          if (state == SignupState.loading) {
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
                            _bloc.add(SignupEvent.signInWithGoogle);
                          },
                          icon: Container(
                            // margin: EdgeInsets.fromLTRB(40, 5, 0, 0),
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
                            // margin: EdgeInsets.fromLTRB(0, 5, 10, 0),
                            child: Text(
                              'Sign Up with Google',
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
                                "Already have an account?",
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
                                        builder: (context) => Signin()),
                                  );
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: Text('Sign In'),
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
