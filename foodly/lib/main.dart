import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodly/services/UID_tracker.dart';
import 'package:foodly/workflows/home_flow/screens/main_home_nav.dart';
import 'package:foodly/workflows/login_flow/screens/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/cart.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final bool debugLogin = false;
  Widget getEntryScreen() {
    if (debugLogin) {
      UIDTracker.userUID = "2jeiG2tK6Dy6ESDvSHM3";
      return MainHomeNav(
        phoneNumber: "+919994818238",
      );
    }
    if (FirebaseAuth.instance.currentUser == null) {
      SharedPreferences.getInstance().then((value) => value.clear());
      return WelcomeScreen();
    } else {
      UIDTracker.userUID = FirebaseAuth.instance.currentUser!.uid;
      return MainHomeNav(
        phoneNumber: FirebaseAuth.instance.currentUser!.phoneNumber!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => Cart(),
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: "Gilroy",
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        title: 'Foodly',
        home: getEntryScreen(),
      ),
    );
  }
}
