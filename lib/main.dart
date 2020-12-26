import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:goaltracker/screens/auth/welcome.dart';
import 'package:goaltracker/style/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: themeData,
      home: WelcomeScreen(),
    );
  }
}
