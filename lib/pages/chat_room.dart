import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:prototype4/pages/takeImage.dart';
import 'package:prototype4/services/user.dart';
import 'package:prototype4/widgets/app_widgets.dart';
import 'package:prototype4/services/database.dart';

//Message exchange goes here
class ChatArea extends StatefulWidget {
  final String friendName, friendPosition, friendCredential;
  ChatArea(
      {Key key, this.friendName, this.friendPosition, this.friendCredential})
      : super(key: key);
  @override
  _ChatAreaState createState() => _ChatAreaState();
}

class _ChatAreaState extends State<ChatArea> {
  TextEditingController messageController = new TextEditingController();

  List<textData> finalData = new List<textData>();

  getmessages(String friendCredential) async {
    ChatListMessage chatListMessage = new ChatListMessage();
    finalData = await chatListMessage.GetMessages(friendCredential);
    for (int index = 0; index < finalData.length; index++) {
      print(index);
      print(finalData[index].getSender());
      print(finalData[index].getText());
      print(finalData[index].getType());
    }
    print("finalData length: ${finalData.length}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: chatAppBar(context, widget.friendName, widget.friendPosition)
     appBar: AppBar(
                title: Text(widget.friendName + "(" +  widget.friendPosition + ")",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
       backgroundColor: Colors.blue[600],
       actions: [
         GestureDetector(
           onTap: (){
             showDialog(
                 context: context,
                 builder: (context) => taskDialog());
           },
           child: Container(
             padding: EdgeInsets.all(8.0),
             child: Icon(
               Icons.design_services
             ),
           ),
         )
       ],
      ),
      body: Align(
        alignment: Alignment.center,
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: getmessages(widget.friendCredential),
                builder: (BuildContext ctx, snapshot) =>
                    snapshot.connectionState == ConnectionState.waiting
                        ? Align(
                            alignment: Alignment.center,
                            child: Container(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : SafeArea(child: chatListBuild()),
              ),
            ),
            SafeArea(
              child: Container(
                alignment: Alignment.bottomCenter,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 10.0,
                      width: 8.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ImageCapture(
                                      friendCredential: widget.friendCredential,
                                    )));
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          gradient: LinearGradient(colors: [
                            const Color(0x0FFFFFFF),
                            const Color(0x36FFFFFF)
                          ]),
                        ),
                        child: Icon(
                          Icons.note_add_rounded,
                          size: 28.0,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                      width: 10.0,
                    ),
                    Expanded(
                      child: TextField(
                        style: whiteStyle(context),
                        decoration: fieldInput(context, "Message"),
                        controller: messageController,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                      width: 10.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        ChatListMessage chatListMessage = new ChatListMessage();
                        if (messageController.text.trim().isNotEmpty) {
                          chatListMessage.sendMessage(
                              messageController.text.trim(),
                              widget.friendCredential);
                        }
                        messageController.clear();
                        FocusScopeNode currentFocus = FocusScope.of(context); //Minimize keyboard on press
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
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
                          Icons.send_rounded,
                          size: 28.0,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                      width: 8.0,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget chatListBuild() {
    return finalData.isEmpty
        ? Container()
        : ListView.builder(
            dragStartBehavior: DragStartBehavior.start,
            reverse: true,
            itemCount: finalData.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              print(
                  "chatListBuilder ${finalData[index].getSender()} at index $index");
              print("type: ${finalData[index].getType()}");
              if (finalData[index].getType() == 'text') {
                return (finalData[index].getSender() == 'friend')
                    ? Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 20.0,
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  finalData[index].getText(),
                                  style: chatStyle(context),
                                ),
                              ),
                              decoration: leftChatBox(),
                              padding: EdgeInsets.all(12),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              alignment: Alignment.centerRight,
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  finalData[index].getText(),
                                  style: chatStyle(context),
                                ),
                              ),
                              decoration: rightChatBox(),
                              padding: EdgeInsets.all(12),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                          ],
                        ),
                      );
              } else{
                return (finalData[index].getSender() == 'friend')
                    ? Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 20),
                            child: GestureDetector(
                              onTap: (() {
                                showDialog(
                                    context: context,
                                    builder: (context) =>
                                        showImage(finalData[index].text));
                              }),
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        finalData[index].getType(),
                                        style: imageStyle(context),
                                      ),
                                    ),
                                    Icon(
                                      Icons.download_outlined,
                                      size: 25,
                                      color: Colors.blue,
                                    ),
                                  ],
                                ),
                                decoration: leftChatBox(),
                                padding: EdgeInsets.all(12),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 10.0,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 10),
                            child: GestureDetector(
                              onTap: (() {
                                showDialog(
                                    context: context,
                                    builder: (context) =>
                                        showImage(finalData[index].text));
                              }),
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(
                                      Icons.download_outlined,
                                      size: 25,
                                      color: Colors.amberAccent,
                                    ),
                                    Text(
                                      finalData[index].getType(),
                                      style: imageStyle(context),
                                    ),
                                  ],
                                ),
                                decoration: rightChatBox(),
                                padding: EdgeInsets.all(12),
                              ),
                            ),
                          ),
                        ],
                      );
              }
              return Container();
            },
          );
  }

  AlertDialog showImage(String url) {
    return new AlertDialog(
      title: Column(children: [
        Container(
          child: Text(
            "Download Image?",
            style: whiteStyleW(context),
          ),
          padding: EdgeInsets.all(8.0),
        ),
        Image.network(
          url,
          fit: BoxFit.cover,
          // height: double.infinity,
          // width: double.infinity,
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes
                    : null,
              ),
            );
          },
        ),
      ]),
      backgroundColor: Colors.black,
      actions: [
        RaisedButton(
            onPressed: (() {
              Navigator.of(context).pop();
            }),
            elevation: 2.0,
            //highlightColor: Colors.white54,
            color: Colors.transparent,
            child: Text(
              "Cancel",
              style: whiteStyleS(context),
            )),
        RaisedButton(
            onPressed: () {
              downloadImageFromURL(url);
              Navigator.of(context).pop();
            },
            color: Colors.transparent,
            elevation: 2.0,
            //highlightColor: Colors.white54,
            child: Text(
              "Download",
              style: whiteStyleS(context),
            )),
      ],
    );
  }

  AlertDialog taskDialog(){
    return new AlertDialog(
      backgroundColor: Colors.blueGrey[600],
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Assign Task",
            style: whiteStyleW(context),
            textAlign: TextAlign.center,
          ),
          TextField(
            decoration: alertInput(context, "Title"),
            style: amberStyle(context),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.0,),
          TextField(
            decoration: fieldInput(context, "Details"),
            style: blueStyle(context),
            textAlign: TextAlign.justify,
            maxLines: 5,
          )
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
              "Cancel",
              style: TextStyle(
                color: Colors.redAccent,
                fontStyle: FontStyle.italic,
                fontSize: 18.0,
              ),
            )),
        RaisedButton(
            onPressed: (() {
              //add task
              Navigator.of(context).pop();
            }),
            elevation: 2.0,
            //highlightColor: Colors.white54,
            color: Colors.transparent,
            child: Text(
              "Send",
              style: TextStyle(
                color: Colors.blueAccent,
                fontStyle: FontStyle.italic,
                fontSize: 18.0,
              ),
            )),
      ],
    );
  }
}
