import 'package:entitle_guard/features/Components/Latestpurchase.dart';
import 'package:entitle_guard/features/Screens/Dashboard/Homepage/bloc.dart';
import 'package:entitle_guard/features/Screens/Dashboard/notification/notification.dart';
import 'package:entitle_guard/Utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../Utils/fitness_app_theme.dart';
import '../../../../Utils/theme.dart';
import '../../../Components/Morepurchase.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key, this.animationController, this.animation})
      : super(key: key);
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  HomepageBloc _homepageBloc = HomepageBloc(); // Initialize _homepageBloc
  double topBarOpacity = 0.0;
  int? userId = 0;
  @override
  void initState() {
    super.initState();
    _homepageBloc = HomepageBloc();
    setUserId();
  }

  void setUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = await prefs.getInt('userId');
    _homepageBloc.fetchData(userId!);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    final themeMode = Provider.of<ThemeProviderNotifier>(context).themeMode;
    final isDarkMode = themeMode == ThemeModeType.dark;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        body: SafeArea(
          child: ChangeNotifierProvider(
            create: (context) => _homepageBloc,
            child: Consumer<HomepageBloc>(
              builder: (context, homepageBloc, _) {
                return Container(
                  child: Column(
                    children: [
                      getAppBarUI(isDarkMode),
                      Padding(
                        padding: const EdgeInsets.only(left: 24, right: 24),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                'Latest Purchase',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: FitnessAppTheme.fontName,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  letterSpacing: 0.5,
                                  color: isDarkMode
                                      ? FitnessAppTheme.deactivatedText
                                      : FitnessAppTheme.lightText,
                                ),
                              ),
                            ),
                            InkWell(
                              highlightColor: Colors.transparent,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4.0)),
                              onTap: () {
                                if (homepageBloc.billDetailsList.isNotEmpty) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Morepurchase(
                                        bill: homepageBloc.billDetailsList,
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'More',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontFamily: FitnessAppTheme.fontName,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16,
                                        letterSpacing: 0.5,
                                        color: FitnessAppTheme.nearlyDarkBlue,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 38,
                                      width: 26,
                                      child: Icon(
                                        Icons.arrow_forward,
                                        color: FitnessAppTheme.darkText,
                                        size: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: homepageBloc.billDetailsList.isEmpty
                              ? Center(child: Text('No data available'))
                              : ListView.builder(
                                  itemCount:
                                      homepageBloc.billDetailsList.length,
                                  itemBuilder: (context, index) {
                                    return Latestpurchase(
                                        //userId: userId!,
                                        bill: homepageBloc
                                            .billDetailsList[index]);
                                  },
                                ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget getAppBarUI(bool isDarkMode) {
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
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Dashboard',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: FitnessAppTheme.fontName,
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                        letterSpacing: 1.2,
                        color:
                            isDarkMode ? Secondary : FitnessAppTheme.darkerText,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 38,
                  width: 38,
                  child: InkWell(
                    highlightColor: Colors.transparent,
                    borderRadius: const BorderRadius.all(Radius.circular(32.0)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NotificationScreen()),
                      );
                    },
                    child: Center(
                      child: Icon(
                        Icons.notifications,
                        color: isDarkMode
                            ? FitnessAppTheme.deactivatedText
                            : FitnessAppTheme.grey,
                        size: 30,
                      ),
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
