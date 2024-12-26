import 'package:entitle_guard/features/Screens/Welcome/Splash_Screen/widget/Splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:entitle_guard/Utils/theme.dart';
// import 'package:entitle_guard/controller/check_google_authentication.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
// import 'sam.dart';
import 'package:entitle_guard/data/Services/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // final Auth_Service authService = Auth_Service();
  // final User? user = await authService.checkCurrentUser();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: user != null ? Dashboard() : MyApp(),
      home: MyApp(),
    ),
  );
}

//codess
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProviderNotifier(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Entitle Guard',
          home: SplashScreen()),
    );
  }
}
