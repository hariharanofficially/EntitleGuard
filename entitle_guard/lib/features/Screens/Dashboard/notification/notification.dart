import 'package:entitle_guard/Utils/colors.dart';
import 'package:entitle_guard/Utils/fitness_app_theme.dart';
import 'package:entitle_guard/Utils/theme.dart';
import 'package:entitle_guard/features/Screens/Dashboard/Dashboard.dart';
import 'package:entitle_guard/features/Screens/Dashboard/notification/bloc/bloc.dart';
import 'package:entitle_guard/features/Screens/Dashboard/notification/bloc/event.dart';
import 'package:entitle_guard/features/Screens/Dashboard/notification/bloc/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late NotificationBloc _notificationBloc;
  double topBarOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    _notificationBloc = NotificationBloc();
    _notificationBloc.add(NotificationEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      bloc: _notificationBloc,
      builder: (context, state) {
        if (state is NotificationLoaded) {
          return _buildNotificationsList(state.notifications);
        }
        return Container(); // Return a placeholder widget while loading
      },
    );
  }

  Widget _buildNotificationsList(List<String> notifications) {
    final themeMode = Provider.of<ThemeProviderNotifier>(context).themeMode;
    final isDarkMode = themeMode == ThemeModeType.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        title: Text(
          'Notifications',
          style: TextStyle(
            fontFamily: FitnessAppTheme.fontName,
            fontWeight: FontWeight.w700,
            fontSize: 22 + 6 - 6 * topBarOpacity,
            letterSpacing: 1.2,
            color: isDarkMode ? Secondary : FitnessAppTheme.darkerText,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: isDarkMode ? Colors.white : Colors.black,
          onPressed: () {
            Navigator.pop(
              context,
              MaterialPageRoute(builder: (context) => Dashboard()),
            );
          },
        ),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return ListTile(
            leading: Icon(Icons.notifications),
            title: Text(
              notification,
              style: TextStyle(
                fontFamily: FitnessAppTheme.fontName,
                fontWeight: FontWeight.w500,
                fontSize: 16,
                letterSpacing: -0.2,
                color: isDarkMode
                    ? FitnessAppTheme.deactivatedText
                    : FitnessAppTheme.darkText,
              ),
            ),
            subtitle: Text(
              'This is a notification message.',
              style: TextStyle(
                fontFamily: FitnessAppTheme.fontName,
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: isDarkMode
                    ? FitnessAppTheme.dismissibleBackground
                    : FitnessAppTheme.grey.withOpacity(0.5),
              ),
            ),
            onTap: () {
              // Handle notification tap
              // You can navigate to a detailed notification screen here
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _notificationBloc.close();
    super.dispose();
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: NotificationScreen(),
  ));
}
// import 'package:entitle_guard/Utils/colors.dart';
// import 'package:entitle_guard/Utils/theme.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../Utils/fitness_app_theme.dart';
// import 'Dashboard.dart';

// class NotificationScreen extends StatefulWidget {
//   const NotificationScreen({super.key});

//   @override
//   State<NotificationScreen> createState() => _NotificationScreenState();
// }

// class _NotificationScreenState extends State<NotificationScreen> {
//   late User user; // Initialize user variable
//   double topBarOpacity = 0.0;
//   @override
//   void initState() {
//     super.initState();
//     user = FirebaseAuth.instance.currentUser!; // Initialize user variable
//   }

//   @override
//   Widget build(BuildContext context) {
//     final themeMode = Provider.of<ThemeProviderNotifier>(context).themeMode;
//     final isDarkMode = themeMode == ThemeModeType.dark;
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         backgroundColor: isDarkMode ? Colors.black : Colors.white,
//         appBar: AppBar(
//           backgroundColor: isDarkMode ? Colors.black : Colors.white,
//           title: Text(
//             'Notifications',
//             style: TextStyle(
//               fontFamily: FitnessAppTheme.fontName,
//               fontWeight: FontWeight.w700,
//               fontSize: 22 + 6 - 6 * topBarOpacity,
//               letterSpacing: 1.2,
//               color: isDarkMode ? Secondary : FitnessAppTheme.darkerText,
//             ),
//           ),
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back),
//             color: isDarkMode ? Colors.white : Colors.black,
//             onPressed: () {
//               Navigator.pop(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => Dashboard(
//                           user: user,
//                         )),
//               );
//             },
//           ),
//         ),
//         body: ListView.builder(
//           itemCount: 10, // Replace with the actual number of notifications
//           itemBuilder: (context, index) {
//             return ListTile(
//               leading: Icon(
//                 Icons.notifications,
//                 color: FitnessAppTheme.grey,
//               ),
//               title: Text(
//                 'Notification ${index + 1}',
// style: TextStyle(
//   fontFamily: FitnessAppTheme.fontName,
//   fontWeight: FontWeight.w500,
//   fontSize: 16,
//   letterSpacing: -0.2,
//   color: isDarkMode
//       ? FitnessAppTheme.deactivatedText
//       : FitnessAppTheme.darkText,
// ),
//               ),
//               subtitle: Text(
//                 'This is a notification message.',
// style: TextStyle(
//   fontFamily: FitnessAppTheme.fontName,
//   fontWeight: FontWeight.w600,
//   fontSize: 12,
//   color: isDarkMode
//       ? FitnessAppTheme.dismissibleBackground
//       : FitnessAppTheme.grey.withOpacity(0.5),
// ),
//               ),
//               onTap: () {
//                 // Handle notification tap
//                 // You can navigate to a detailed notification screen here
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
