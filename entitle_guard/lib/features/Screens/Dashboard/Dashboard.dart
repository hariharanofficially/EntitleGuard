import 'package:entitle_guard/Utils/fitness_app_theme.dart';
import 'package:entitle_guard/data/Models/tabIcon_data.dart';
import 'package:entitle_guard/features/Components/bottom_bar_view.dart';
import 'package:entitle_guard/features/Screens/Dashboard/Homepage/Homepage.dart';
import 'package:entitle_guard/features/Screens/Dashboard/Homepage/bloc.dart';
import 'package:entitle_guard/features/Screens/Dashboard/profile/bloc.dart';
import 'package:entitle_guard/features/Screens/Dashboard/profile/profile.dart';
import 'package:entitle_guard/features/Screens/Dashboard/search/bloc.dart';
import 'package:entitle_guard/features/Screens/Dashboard/search/search_Screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/Models/apimodels.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  late AnimationController animationController;

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  late Widget tabBody;

  late final HomepageBloc _homepageBloc;
  late final ProfileBloc _profileBloc;
  late final SearchBloc _searchBloc;
  late Bill bill;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  void initializeData() async {
    tabBody = Homepage();
    _homepageBloc = HomepageBloc();
    _profileBloc = ProfileBloc();
    _searchBloc = SearchBloc();

    List<BillItems> items = [];
    BillItems item = new BillItems();
    items.add(item);
    bill = new Bill(billItems: items);

    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;

    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);

    //_homepageBloc.fetchData();
    // You might want to await on the initialization of other blocs if needed

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', true);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: FitnessAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            tabBody,
            bottomBar(),
          ],
        ),
      ),
    );
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
          tabIconsList: tabIconsList,
          addClick: () {},
          bill: bill,
          changeIndex: (int index) {
            if (index == 0) {
              setState(() {
                tabBody = Homepage();
              });
            } else if (index == 1) {
              setState(() {
                tabBody = SearchScreen();
              });
            } else if (index == 3) {
              setState(() {
                // GoogleSignInAccount? user;
                tabBody = Profile(
                    // googleSignInAccount: user!,
                    );
              });
            }
          },
        ),
      ],
    );
  }
}

// import 'package:entitle_guard/Screens/Dashboard/Homepage.dart';
// import 'package:entitle_guard/Screens/Dashboard/profile.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import '../../Components/bottom_bar_view.dart';
// import 'search_Screen.dart';
// import '../../Models/tabIcon_data.dart';
// import '../../Utils/fitness_app_theme.dart';

// class Dashboard extends StatefulWidget {
//   final User user; // Define the user property

//   const Dashboard({Key? key, required this.user}) : super(key: key);

//   @override
//   _DashboardState createState() => _DashboardState();
// }

// class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
//   AnimationController? animationController;

//   List<TabIconData> tabIconsList = TabIconData.tabIconsList;

//   Widget tabBody = Container(
//     color: FitnessAppTheme.background,
//   );
//   late User user;
//   @override
//   void initState() {
//     tabIconsList.forEach((TabIconData tab) {
//       tab.isSelected = false;
//     });
//     tabIconsList[0].isSelected = true;

//     animationController = AnimationController(
//         duration: const Duration(milliseconds: 600), vsync: this);
//     tabBody = Homepage();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     animationController?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: FitnessAppTheme.background,
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         body: FutureBuilder<bool>(
//           future: getData(),
//           builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
//             if (!snapshot.hasData) {
//               return const SizedBox();
//             } else {
//               return Stack(
//                 children: <Widget>[
//                   tabBody,
//                   bottomBar(),
//                 ],
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }

//   Future<bool> getData() async {
//     await Future<dynamic>.delayed(const Duration(milliseconds: 200));
//     return true;
//   }

//   Widget bottomBar() {
//     return Column(
//       children: <Widget>[
//         const Expanded(
//           child: SizedBox(),
//         ),
//         BottomBarView(
//           tabIconsList: tabIconsList,
//           addClick: () {},
//           changeIndex: (int index) {
//             if (index == 0) {
//               animationController?.reverse().then<dynamic>((data) {
//                 if (!mounted) {
//                   return;
//                 }
//                 setState(() {
//                   tabBody = Homepage();
//                 });
//               });
//             } else if (index == 1) {
//               animationController?.reverse().then<dynamic>((data) {
//                 if (!mounted) {
//                   return;
//                 }
//                 setState(() {
//                   tabBody = SearchScreen();
//                 });
//               });
//             } else if (index == 3) {
//               animationController?.reverse().then<dynamic>((data) {
//                 if (!mounted) {
//                   return;
//                 }
//                 setState(() {
//                   tabBody = Profile(
//                     user: widget
//                         .user, // Pass the user property to the Profile widget
//                   );
//                 });
//               });
//             }
//           },
//         ),
//       ],
//     );
//   }
// }
