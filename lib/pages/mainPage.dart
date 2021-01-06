import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:prototype4/helper/authenticate.dart';
import 'package:prototype4/pages/search.dart';
import 'package:prototype4/pages/taskPage.dart';
import 'package:prototype4/services/auth.dart';
import 'package:flutter/widgets.dart';
import 'package:prototype4/services/database.dart';
import 'package:prototype4/widgets/app_widgets.dart';

import 'chat_room.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  Map<String, Map<String, String>> data =
      new Map<String, Map<String, String>>();
  AuthMethods authMethods = new AuthMethods();
  bool isLoading = false;
  getData() async {
    AccessFriends accessFriends = new AccessFriends();
    data = await accessFriends.GetFriends();
  }

  Widget UserTile(String userName, String position, String credential) {
    return GestureDetector(
      onTap: () {
        isLoading = true;
        AddFriend(credential, userName, position);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatArea(
                      friendName: userName,
                      friendPosition: position,
                      friendCredential: credential,
                    )));
      },
      onLongPress: (){
        showDialog(
          context: context,
          builder: (context) => removeFriendDialog(credential, userName)
        );
      },
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: whiteStyleL(context),
                ),
                Text(
                  position,
                  style: whiteStyle(context),
                ),
              ],
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Task Share",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue[600],
        actions: [
          GestureDetector(
            onTap: () {
              authMethods.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Container(
              child: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              padding: EdgeInsets.symmetric(horizontal: 16),
            ),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  heroTag: null,
                  backgroundColor: Colors.greenAccent[700],
                  child: Icon(Icons.library_add_check_outlined),
                  onPressed: (){
                    Navigator.push(context,MaterialPageRoute(builder: (context) => TaskScreen()));
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  heroTag: null,
                  backgroundColor: Colors.orange[800],
                  child: Icon(Icons.person_add_rounded),
                  onPressed: () {
                    Navigator.push(
                      context, MaterialPageRoute(builder: (context) => SearchScreen()));
                    },
                ),
              ),
            ]
          ),
      ),
      // floatingActionButton: FloatingActionButton(
      //         backgroundColor: Colors.orange[800],
      //         child: Icon(Icons.person_add_rounded),
      //         onPressed: () {
      //           Navigator.push(
      //             context, MaterialPageRoute(builder: (context) => SearchScreen()));
      //           },
      //       ),
      body: isLoading
          ? Align(
            alignment: Alignment.center,
                      child: Container(child: CircularProgressIndicator())
          )
          : SingleChildScrollView(
              child: FutureBuilder(
                future: getData(),
                builder: (BuildContext ctx, snapshot) =>
                    snapshot.connectionState == ConnectionState.waiting
                        ? Align(
                            alignment: Alignment.center,
                            child: Container(
                                height: MediaQuery.of(context).size.height,
                                alignment: Alignment.center,
                                child: Container(child: CircularProgressIndicator())
                            ))
                        : ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              Map<String, String> oneData =
                                  new Map<String, String>();

                              print(data.length);
                              oneData = data.values.elementAt(index);

                              return UserTile(
                                  oneData['name'],
                                  oneData['position'],
                                  data.keys.elementAt(index));
                            },
                          ),
              ),
            ),
    );
  }

  Widget getList() {
    print(data.length);
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: data.length,
      itemBuilder: (context, index) {
        Map<String, String> oneData = new Map<String, String>();

        print(data.length);
        oneData = data.values.elementAt(index);

        return UserTile(
            oneData['name'], oneData['position'], data.keys.elementAt(index));
      },
    );
  }

  AlertDialog removeFriendDialog(String credential,String name){
    return AlertDialog(
      backgroundColor: Colors.black54,
      title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children:[
            Text(
              "Remove Person",
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 21.0,
              ),
            ),
            Text(
              "Do you want to remove $name ?",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ],
      ),
      actions: [
        RaisedButton(
            onPressed: (() {
              Navigator.of(context).pop();
            }),
            elevation: 2.0,
            //highlightColor: Colors.white54,
            color: Colors.transparent,
            child: Text(
              "Close",
              style: TextStyle(
                color: Colors.redAccent,
                fontStyle: FontStyle.italic,
                fontSize: 18.0,
              ),
            )),
        RaisedButton(
            onPressed: (() {
              AccessFriends accessFriendsDialog = new AccessFriends();
              setState(() {
                accessFriendsDialog.removeFriend(credential);
              });
              Navigator.of(context).pop();
            }),
            elevation: 2.0,
            //highlightColor: Colors.white54,
            color: Colors.transparent,
            child: Text(
              "OK",
              style: TextStyle(
                color: Colors.blueAccent,
                fontStyle: FontStyle.italic,
                fontSize: 18.0,
              ),
            ))
      ],
    );
  }
}
