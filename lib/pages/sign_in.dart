import 'package:flutter/material.dart';
import 'package:prototype4/pages/mainPage.dart';
import 'package:prototype4/services/auth.dart';
import 'package:prototype4/widgets/app_widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:prototype4/widgets/varify.dart';

class signIn extends StatefulWidget {
  final Function toggle;
  signIn(this.toggle);

  @override
  _signInState createState() => _signInState();
}

class _signInState extends State<signIn> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  AuthMethods authMethods = new AuthMethods();

  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();

  signMeIn() {
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      Firebase.initializeApp();
      authMethods
          .signInEmail(emailTextEditingController.text,
              passwordTextEditingController.text)
          .then((value) => {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => ChatRoom()))
              });
    }
  }

  GoogleMeIn() {
    isLoading = true;
    Firebase.initializeApp();
    authMethods.signInWithGoogle(context);
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
                height: MediaQuery.of(context).size.height,
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
                              decoration: fieldInput(context, "Email Address"),
                              validator: (val) => emailVal(val),
                              controller: emailTextEditingController,
                            ),
                            TextFormField(
                              obscureText: true,
                              style: blueStyle(context),
                              decoration: fieldInput(context, "Password"),
                              validator: (val) => passwordVal(val),
                              controller: passwordTextEditingController,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        child: Text(
                          "Forgot Password ?",
                          style: whiteStyle(context),
                        ),
                        padding: EdgeInsets.all(8.0),
                        alignment: Alignment.centerRight,
                      ),
                      SizedBox(
                        height: 120.0,
                      ),
                      GestureDetector(
                        onTap: () {
                          signMeIn();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            "Sign In",
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
                        onTap: (() {
                          GoogleMeIn();
                        }),
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
                            "Dont have an account ? ",
                            style: whiteStyle(context),
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.toggle();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                "Register now",
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
