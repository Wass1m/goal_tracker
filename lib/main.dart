import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:goaltracker/models/profile.dart';
import 'package:goaltracker/screens/auth/welcome.dart';
import 'package:goaltracker/services/fire/auth.dart';
import 'package:goaltracker/services/fire/global.dart';
import 'package:goaltracker/style/theme.dart';
import 'package:goaltracker/wrapp_user.dart';
import 'package:goaltracker/wrapper.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        StreamProvider<User>.value(value: AuthService().user),
        StreamProvider<Profile>.value(value: Global.profileRef.documentStream),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: themeData,
      home: WrapperUser(),
    );
  }
}
