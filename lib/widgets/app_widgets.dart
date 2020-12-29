import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

AppBar mainAppBar(BuildContext context) {
  return AppBar(
    title: Text(
      "Task Share",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    backgroundColor: Colors.blue[600],
  );
}

InputDecoration fieldInput(BuildContext context, String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(
      color: Colors.white54,
    ),
    focusedBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue[700])),
    enabledBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
  );
}

InputDecoration alertInput(BuildContext context, String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(
      color: Colors.white54,
    ),
    focusedBorder:
    UnderlineInputBorder(borderSide: BorderSide(color: Colors.amber[600])),
    enabledBorder:
    UnderlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
  );
}

TextStyle whiteStyle(BuildContext context) {
  return TextStyle(
    color: Colors.white70,
    //fontWeight: FontWeight.bold,
    fontStyle: FontStyle.italic,
    fontSize: 17.0,
  );
}

TextStyle whiteStyleU(BuildContext context) {
  return TextStyle(
    color: Colors.white70,
    fontWeight: FontWeight.bold,
    fontSize: 17.0,
    decoration: TextDecoration.underline,
    decorationThickness: 3.0,
  );
}

TextStyle whiteStyleL(BuildContext context) {
  return TextStyle(
    color: Colors.white70,
    fontWeight: FontWeight.bold,
    fontSize: 25.0,
  );
}

TextStyle whiteStyleS(BuildContext context) {
  return TextStyle(
    color: Colors.white70,
    fontStyle: FontStyle.italic,
    fontSize: 18.0,
  );
}

TextStyle whiteStyleW(BuildContext context) {
  return TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 20.0,
  );
}

TextStyle blackStyle(BuildContext context) {
  return TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 17.0,
  );
}

TextStyle blueStyle(BuildContext context) {
  return TextStyle(
    color: Colors.blueAccent[400],
    fontWeight: FontWeight.bold,
  );
}

TextStyle amberStyle(BuildContext context) {
  return TextStyle(
    color: Colors.amber,
    fontWeight: FontWeight.bold,
  );
}

BoxDecoration blueButton(BuildContext context) {
  return BoxDecoration(
    gradient: LinearGradient(
      colors: [const Color(0xff007EF4), const Color(0xff2A75BC)],
    ),
    borderRadius: BorderRadius.circular(30.0),
  );
}

BoxDecoration whiteButton(BuildContext context) {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(30.0),
  );
}

AppBar chatAppBar(BuildContext context, String name, String position) {
  return AppBar(
    title: Text(
      name + "(" + position + ")",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    backgroundColor: Colors.blue[600],
  );
}

BoxDecoration leftChatBox(){
  return BoxDecoration(
    color: Colors.greenAccent[700],
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(15),
      topRight: Radius.circular(15),
      bottomRight: Radius.circular(15),
      bottomLeft: Radius.circular(0)
    ),
  );
}

BoxDecoration rightChatBox(){
  return BoxDecoration(
    color: Colors.blueAccent[700],
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(15),
      topRight: Radius.circular(15),
      bottomRight: Radius.circular(0),
      bottomLeft: Radius.circular(15)
    ),
  );
}

TextStyle chatStyle(BuildContext context) {
  return TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 15.0,
  );
}

TextStyle imageStyle(BuildContext context) {
  return TextStyle(
    color: Colors.amber[300],
    fontWeight: FontWeight.bold,
    fontSize: 15.0,
  );
}