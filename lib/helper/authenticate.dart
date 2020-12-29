import 'package:flutter/material.dart';
import 'package:prototype4/pages/sign_in.dart';
import 'package:prototype4/pages/sign_up.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;

  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }


  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return signIn(toggleView);
    } else {
      return signUp(toggleView);
    }
  }
}
