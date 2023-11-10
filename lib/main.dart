import 'package:flutter/material.dart';
import 'package:pharmacy/Presentation/homepage.screen/widgets/bottom.navigation.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Presentation/onboarding.screen/main.onboarding.dart';
import 'Presentation/signup-login.screen/login/main.login.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // GET THE USER'S ID...
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var userID = preferences.getString('id');
  runApp(
      MaterialApp(
        home: userID == null? const MainOnboardingScreen() :  const BottomNavigationWidget(),
        debugShowCheckedModeBanner: false,
        routes: {
          'login': (context) => const MainLoginScreen()
        },
  ));
}
