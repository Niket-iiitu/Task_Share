import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:prototype4/pages/mainPage.dart';
import 'package:prototype4/services/auth.dart';
import 'package:prototype4/services/database.dart';
import 'package:prototype4/widgets/app_widgets.dart';
import 'package:prototype4/widgets/varify.dart';
import 'package:flutter/widgets.dart';
import 'package:prototype4/pages/mainPage.dart';

class signUp extends StatefulWidget {
  final Function toggle;
  signUp(this.toggle);

  @override
  _signUpState createState() => _signUpState();
}

class _signUpState extends State<signUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  Map<String, String> userMap = new Map<String, String>();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  AuthMethods authMethods = new AuthMethods();

  TextEditingController userNameTextEditingController =
      new TextEditingController();
  TextEditingController positionNameTextEditingController =
      new TextEditingController();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();

  signMeUp() {
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      Firebase.initializeApp();
      authMethods
          .signUpEmail(emailTextEditingController.text,
              passwordTextEditingController.text)
          .then((value) {
        userMap["name"] = userNameTextEditingController.text.trim();
        userMap["position"] = positionNameTextEditingController.text.trim();
        userMap["email"] = emailTextEditingController.text.trim();
        userMap["ID"] = FirebaseAuth.instance.currentUser.uid;
        databaseMethods.uploadUser(userMap);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ChatRoom()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(context),
      backgroundColor: Colors.black,
      body: isLoading
          ? Center(
              child: Container(
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(20.0),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              style: blueStyle(context),
                              decoration: fieldInput(context, "Username"),
                              controller: userNameTextEditingController,
                              validator: (val) => usernameVal(val),
                            ),
                            TextFormField(
                              style: blueStyle(context),
                              decoration: fieldInput(context, "Position"),
                              controller: positionNameTextEditingController,
                              validator: (val) => positionVal(val),
                            ),
                            TextFormField(
                              style: blueStyle(context),
                              decoration: fieldInput(context, "Email Address"),
                              controller: emailTextEditingController,
                              validator: (val) => emailVal(val),
                            ),
                            TextFormField(
                              obscureText: true,
                              style: blueStyle(context),
                              decoration: fieldInput(context, "Password"),
                              controller: passwordTextEditingController,
                              validator: (val) => passwordVal(val),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      GestureDetector(
                        //Sign In
                        onTap: () {
                          signMeUp();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            "Sign Up",
                            style: whiteStyle(context),
                          ),
                          decoration: blueButton(context),
                          padding: EdgeInsets.symmetric(vertical: 20),
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            "Sign In with Google",
                            style: blackStyle(context),
                          ),
                          decoration: whiteButton(context),
                          padding: EdgeInsets.symmetric(vertical: 20),
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account ? ",
                            style: whiteStyle(context),
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.toggle();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                "SignIn now",
                                style: whiteStyleU(context),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
