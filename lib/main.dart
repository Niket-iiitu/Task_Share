import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:prototype4/helper/authenticate.dart';
import 'package:prototype4/pages/mainPage.dart';
import 'package:prototype4/pages/sign_in.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    String currentUser="";
    try {
       currentUser= FirebaseAuth.instance.currentUser.uid;
    } catch (e) {
      print(e);
    }
    print(currentUser);

    return MaterialApp(
      title: "Task Share",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Color(0xff1F1F1F),
        primaryColor: Color(0xff145C9E),
      ),
      home: currentUser.isEmpty ? Authenticate() : ChatRoom(),
      //ToDO Home
    );
  }
}
