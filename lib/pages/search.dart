import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matcher/matcher.dart';
import 'package:prototype4/pages/chat_room.dart';
import 'package:prototype4/services/database.dart';
import 'package:prototype4/widgets/app_widgets.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  //DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchTextEditingController =
      new TextEditingController();
  bool haveUserSearched = false;

  Map<int, Map<String, String>> friends = new Map<int, Map<String, String>>();
  initiateSearch() async {
    DatabaseMethods databaseMethods = new DatabaseMethods();
    friends = await databaseMethods
        .getUserByUsername(searchTextEditingController.text);
    haveUserSearched = true;
    return friends;
  }

  Widget searchList() {
    return new ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: friends.length,
      itemBuilder: (context, index) {
        String nameV = friends[index]['name'];
        String positionV = friends[index]['position'];
        String emailV = friends[index]['email'];
        String credentialV = friends[index]['ID'];
        print("####################################@@@@@@@@@@@@@@@@@@@@@@@@@");
        print(friends.length);
        return SearchTile(nameV, positionV, emailV, credentialV);
      },
    );
  }

  Widget SearchTile(
      String userName, String position, String email, String credential) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: whiteStyleL(context),
                  ),
                  Text(
                    email,
                    style: whiteStyle(context),
                  ),
                  Text(
                    position,
                    style: whiteStyle(context),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                AddFriend(credential, userName, position);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChatArea(
                              friendName: userName,
                              friendPosition: position,
                              friendCredential: credential,
                            )));
              },
              child: Container(
                decoration: blueButton(context),
                child: Text(
                  "ADD",
                  style: whiteStyle(context),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
          ],
        ));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(context),
      body: new Container(
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            Container(
              color: Colors.grey[800],
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                    child: TextField(
                      style: whiteStyle(context),
                      decoration: fieldInput(context, "Search"),
                      controller: searchTextEditingController,
                    ),
                  )),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        initiateSearch();
                      });
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        gradient: LinearGradient(colors: [
                          const Color(0x36FFFFFF),
                          const Color(0x0FFFFFFF)
                        ]),
                      ),
                      child: Icon(
                        Icons.search_rounded,
                        size: 35.0,
                        color: Colors.blue,
                      ),
                    ),
                  )
                ],
              ),
            ),
            FutureBuilder(
              future: initiateSearch(),
              builder: (BuildContext ctx, snapshot) =>
                  snapshot.connectionState == ConnectionState.waiting
                      ? Container(
                        child: CircularProgressIndicator(),
                        alignment: Alignment.center,
                        ): searchList(),
            ),
            //friends.isEmpty ? Container() : searchList(),
          ],
        ),
      ),
    );
  }
}
