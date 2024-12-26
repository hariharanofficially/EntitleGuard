import 'package:entitle_guard/Utils/fitness_app_theme.dart';
import 'package:entitle_guard/Utils/theme.dart';
import 'package:entitle_guard/features/Screens/Dashboard/profile/bloc.dart';
import 'package:entitle_guard/Utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  // final GoogleSignInAccount googleSignInAccount;

  const Profile({
    Key? key,
    // required this.googleSignInAccount,
  }) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late ProfileBloc _profileBloc;
  double topBarOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    _profileBloc = ProfileBloc();
    // Fetch user data from SharedPreferences when the widget initializes
    fetchUserData();
  }

  // Function to fetch user data from SharedPreferences
  void fetchUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // Fetch email, name, and photo URL from SharedPreferences
      String? email = prefs.getString('user_email');
      String? name = prefs.getString('user_name');
      String? photoUrl = prefs.getString('user_photo');

      // Update the state with fetched data
      setState(() {
        _profileBloc.setEmail(email!);
        _profileBloc.setName(name!);
        _profileBloc.setPhotoUrl(photoUrl!);
      });
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _profileBloc,
      child: Consumer<ProfileBloc>(
        builder: (context, profileBloc, _) {
          final themeMode =
              Provider.of<ThemeProviderNotifier>(context).themeMode;
          final isDarkMode = themeMode == ThemeModeType.dark;

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: isDarkMode ? Colors.black : Colors.white,
              body: Center(
                child: Column(
                  children: [
                    getAppBarUI(),
                    SizedBox(
                      height: 10,
                    ),
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(profileBloc.photoUrl ?? ''),
                    ),
                    Text(
                      profileBloc.name ?? '',
                      style: TextStyle(
                        fontFamily: FitnessAppTheme.fontName,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        letterSpacing: 0.0,
                        color: isDarkMode
                            ? Colors.white
                            : FitnessAppTheme.grey.withOpacity(0.5),
                      ),
                    ),
                    Text(
                      profileBloc.email ?? '',
                      style: TextStyle(
                        fontFamily: FitnessAppTheme.fontName,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        letterSpacing: 0.0,
                        color: isDarkMode
                            ? Colors.white
                            : FitnessAppTheme.grey.withOpacity(0.5),
                      ),
                    ),
                    ProfileRow(
                      title: 'My Profile',
                      icon: FontAwesomeIcons.user,
                      onPress: () {},
                    ),
                    ProfileRow(
                      title: 'Privacy Policy',
                      icon: FontAwesomeIcons.userShield,
                      onPress: () {},
                    ),
                    ProfileRow(
                      title: 'About us',
                      icon: FontAwesomeIcons.infoCircle,
                      onPress: () {},
                    ),
                    ProfileRow(
                      title: 'Dark Mode',
                      icon: Icons.brightness_medium,
                      onPress: () {
                        profileBloc.toggleDarkMode(context);
                      },
                      hasSwitch: true, // Add this line
                      switchValue:
                          isDarkMode, // Assuming isDarkMode is a boolean for dark mode
                      onSwitchChanged: (value) {
                        profileBloc.toggleDarkMode(context);
                      },
                    ),
                    ProfileRow(
                      title: 'Sign Out',
                      icon: FontAwesomeIcons.signOut,
                      onPress: () {
                        profileBloc.signOut(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget getAppBarUI() {
    final themeMode = Provider.of<ThemeProviderNotifier>(context).themeMode;
    final isDarkMode = themeMode == ThemeModeType.dark;
    return Container(
      decoration: BoxDecoration(
        color: FitnessAppTheme.white.withOpacity(topBarOpacity),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32.0),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: FitnessAppTheme.grey.withOpacity(0.4 * topBarOpacity),
            offset: const Offset(1.1, 1.1),
            blurRadius: 10.0,
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).padding.top,
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 0 - 8.0 * topBarOpacity,
              bottom: 12 - 8.0 * topBarOpacity,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Profile',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: FitnessAppTheme.fontName,
                          fontWeight: FontWeight.w700,
                          fontSize: 22,
                          letterSpacing: 1.2,
                          color: isDarkMode
                              ? Secondary
                              : FitnessAppTheme.darkerText),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileRow extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColour;
  // Additional field for switch
  final bool hasSwitch;
  final bool switchValue;
  final ValueChanged<bool>? onSwitchChanged;

  const ProfileRow({
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColour,
    // Additional parameters for switch
    this.hasSwitch = false,
    this.switchValue = false,
    this.onSwitchChanged,
  });

  @override
  Widget build(BuildContext context) {
    final themeMode = Provider.of<ThemeProviderNotifier>(context).themeMode;
    final isDarkMode = themeMode == ThemeModeType.dark;
    return ListTile(
        onTap: onPress,
        leading: Icon(
          icon,
          color: FitnessAppTheme.nearlyBlack,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: FitnessAppTheme.fontName,
                fontWeight: FontWeight.w500,
                fontSize: 16,
                letterSpacing: -0.1,
                color: isDarkMode ? Colors.white : FitnessAppTheme.darkText,
              ),
            ),
            if (hasSwitch) // Conditionally show switch
              Switch(
                value: switchValue,
                onChanged: onSwitchChanged,
              ),
          ],
        ),
        trailing: endIcon
            ? Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.grey.withOpacity(0.0),
                ),
                child: FaIcon(
                  FontAwesomeIcons.angleRight,
                  size: 20.0,
                  color: Colors.grey,
                ),
              )
            : null);
  }
}
// import 'package:entitle_guard/Screens/Welcome/Signin.dart';
// import 'package:entitle_guard/Utils/colors.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:provider/provider.dart';
// import '../../Utils/fitness_app_theme.dart';
// import '../../Utils/theme.dart';
// import 'dart:async';

// class Profile extends StatefulWidget {
//   final User user;
//   const Profile({super.key, required this.user});

//   @override
//   State<Profile> createState() => _ProfileState();
// }

// class _ProfileState extends State<Profile> {
//   final GoogleSignIn _googleSignIn = GoogleSignIn();
//   double topBarOpacity = 0.0;
//   // Function to sign out
//   Future<void> signOut() async {
//     await FirebaseAuth.instance.signOut();
//     await _googleSignIn.signOut();

//     // Navigate to the sign-in screen
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => Signin()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final themeMode = Provider.of<ThemeProviderNotifier>(context).themeMode;
//     final isDarkMode = themeMode == ThemeModeType.dark;
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         backgroundColor: isDarkMode ? Colors.black : Colors.white,
//         body: Center(
//           child: Column(
//             children: [
//               getAppBarUI(),
//               SizedBox(
//                 height: 10,
//               ),
//               CircleAvatar(
//                 radius: 50,
//                 backgroundImage: NetworkImage(widget.user.photoURL!),
//               ),
//               Text(
//                 '${widget.user.displayName}',
//                 style: TextStyle(
//                   fontFamily: FitnessAppTheme.fontName,
//                   fontWeight: FontWeight.w500,
//                   fontSize: 14,
//                   letterSpacing: 0.0,
//                   color: isDarkMode
//                       ? Colors.white
//                       : FitnessAppTheme.grey.withOpacity(0.5),
//                 ),
//               ),
//               Text(
//                 '${widget.user.email}',
//                 style: TextStyle(
//                   fontFamily: FitnessAppTheme.fontName,
//                   fontWeight: FontWeight.w500,
//                   fontSize: 14,
//                   letterSpacing: 0.0,
//                   color: isDarkMode
//                       ? Colors.white
//                       : FitnessAppTheme.grey.withOpacity(0.5),
//                 ),
//               ),
//               ProfileRow(
//                 title: 'My Profile',
//                 icon: FontAwesomeIcons.user,
//                 onPress: () {},
//               ),
//               ProfileRow(
//                 title: 'Privacy Policy',
//                 icon: FontAwesomeIcons.userShield,
//                 onPress: () {},
//               ),
//               ProfileRow(
//                 title: 'About us',
//                 icon: FontAwesomeIcons.infoCircle,
//                 onPress: () {},
//               ),
//               ProfileRow(
//                 title: 'Dark Mode',
//                 icon: Icons.brightness_medium,
//                 onPress: () {},
//                 hasSwitch: true, // Add this line
//                 switchValue:
//                     isDarkMode, // Assuming isDarkMode is a boolean for dark mode
//                 onSwitchChanged: (value) {
//                   Provider.of<ThemeProviderNotifier>(context, listen: false)
//                       .toggleThemeMode();
//                 },
//               ),
//               ProfileRow(
//                 title: 'Sign Out',
//                 icon: FontAwesomeIcons.signOut,
//                 onPress: () {
//                   signOut();
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget getAppBarUI() {
//     final themeMode = Provider.of<ThemeProviderNotifier>(context).themeMode;
//     final isDarkMode = themeMode == ThemeModeType.dark;
//     return Container(
//       decoration: BoxDecoration(
//         color: FitnessAppTheme.white.withOpacity(topBarOpacity),
//         borderRadius: const BorderRadius.only(
//           bottomLeft: Radius.circular(32.0),
//         ),
//         boxShadow: <BoxShadow>[
//           BoxShadow(
//             color: FitnessAppTheme.grey.withOpacity(0.4 * topBarOpacity),
//             offset: const Offset(1.1, 1.1),
//             blurRadius: 10.0,
//           ),
//         ],
//       ),
//       child: Column(
//         children: <Widget>[
//           SizedBox(
//             height: MediaQuery.of(context).padding.top,
//           ),
//           Padding(
//             padding: EdgeInsets.only(
//               left: 16,
//               right: 16,
//               top: 0 - 8.0 * topBarOpacity,
//               bottom: 12 - 8.0 * topBarOpacity,
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(
//                       'Profile',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontFamily: FitnessAppTheme.fontName,
//                         fontWeight: FontWeight.w700,
//                         fontSize: 22 + 6 - 6 * topBarOpacity,
//                         letterSpacing: 1.2,
//                         color:
//                             isDarkMode ? Secondary : FitnessAppTheme.darkerText,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ProfileRow extends StatelessWidget {
//   final String title;
//   final IconData icon;
//   final VoidCallback onPress;
//   final bool endIcon;
//   final Color? textColour;

//   // Additional field for switch
//   final bool hasSwitch;
//   final bool switchValue;
//   final ValueChanged<bool>? onSwitchChanged;

//   const ProfileRow({
//     required this.title,
//     required this.icon,
//     required this.onPress,
//     this.endIcon = true,
//     this.textColour,
//     // Additional parameters for switch
//     this.hasSwitch = false,
//     this.switchValue = false,
//     this.onSwitchChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final themeMode = Provider.of<ThemeProviderNotifier>(context).themeMode;
//     final isDarkMode = themeMode == ThemeModeType.dark;
//     return ListTile(
//       onTap: onPress,
//       leading: Container(
//         width: 40,
//         height: 40,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(100),
//           color: Colors.amber,
//         ),
//         child: Icon(
//           icon,
//           color: FitnessAppTheme.nearlyBlack,
//         ),
//       ),
//       title: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: TextStyle(
//               fontFamily: FitnessAppTheme.fontName,
//               fontWeight: FontWeight.w500,
//               fontSize: 16,
//               letterSpacing: -0.1,
//               color: isDarkMode ? Colors.white : FitnessAppTheme.darkText,
//             ),
//           ),
//           if (hasSwitch) // Conditionally show switch
//             Switch(
//               value: switchValue,
//               onChanged: onSwitchChanged,
//             ),
//         ],
//       ),
//       trailing: endIcon
//           ? Container(
//               height: 20,
//               width: 20,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(100),
//                 color: Colors.grey.withOpacity(0.0),
//               ),
//               child: FaIcon(
//                 FontAwesomeIcons.angleRight,
//                 size: 20.0,
//                 color: Colors.grey,
//               ),
//             )
//           : null,
//     );
//   }
// }
