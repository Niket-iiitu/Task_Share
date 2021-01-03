import 'dart:core';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:prototype4/services/user.dart';
import 'package:intl/intl.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:image_picker_saver/image_picker_saver.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

class DatabaseMethods {
  final databaseReference = FirebaseDatabase.instance.reference();
  getUserByUsername(String username) async { //TODO Search User
    Map<int, Map<String, String>> friends = new Map();
    int position = 0;
    await databaseReference.child("users").once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        print(values['name'].toString());
        if (username == values["name"].toString() ||
            username == values["email"].toString()) {
          Map<String, String> us = new Map();
          us['name'] = values['name'].toString();
          us['email'] = values['email'].toString();
          us['position'] = values['position'].toString();
          us['ID'] = values['ID'].toString();
          friends[position] = us;
          position += 1;
        }
      });
    });
    print("##########################################################");
    //print(friends);
    return friends;
  }

  uploadUser(userMap) {
    databaseReference
        .child("users")
        .child(FirebaseAuth.instance.currentUser.uid)
        .set(userMap);
  }
}

Future<void> AddFriend( //TODO Add Friends
    String friendCredential, String name, String position) async {
  Firebase.initializeApp();
  String currentUser = FirebaseAuth.instance.currentUser.uid.toString();
  await FirebaseDatabase.instance
      .reference()
      .child('friend')
      .child(currentUser)
      .child(friendCredential)
      .child("name")
      .set(name);
  await FirebaseDatabase.instance
      .reference()
      .child('friend')
      .child(currentUser)
      .child(friendCredential)
      .child("position")
      .set(position);
}

class AccessFriends {
  GetFriends() async { //TODO get Friends
    final Map<String, Map<String, String>> data =
        new Map<String, Map<String, String>>();
    await FirebaseDatabase.instance
        .reference()
        .child('friend')
        .child(FirebaseAuth.instance.currentUser.uid.toString())
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        Map<String, String> temp = new Map();
        temp['name'] = values['name'].toString();
        temp['position'] = values['position'].toString();
        data[key.toString()] = temp;
      });
    });
    print('AccessFriend');
    print(data.length);
    return data;
  }
}

class ChatListMessage {
  String meCredential = FirebaseAuth.instance.currentUser.uid.toString();

  sendMessage(String message, String friendCredential) async { //TODO send Messages
    await FirebaseDatabase.instance
        .reference()
        .child('chats')
        .child(getDateTime())
        .set({
      'sender': meCredential,
      'receiever': friendCredential,
      'text': message,
      'type': 'text'
    });
  }

  GetMessages(String friendCredential) async { //TODO get Messages
    final List<textData> finalData = new List<textData>();
    final Map<String, textData> chats = new Map<String, textData>();
    await FirebaseDatabase.instance
        .reference()
        .child('chats')
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        print('GetMessages ${key.toString()}');
        if (values['sender'].toString() == friendCredential &&
            values['receiever'].toString() == meCredential) {
          chats[key.toString()] = new textData(
              receiever: 'me',
              sender: 'friend',
              text: values['text'].toString(),
              type: values['type'].toString());
          print("GetMessage Scanner: ${values['text'].toString()}");
        }
        if (values['receiever'].toString() == friendCredential &&
            values['sender'].toString() == meCredential) {
          chats[key.toString()] = new textData(
              receiever: 'friend',
              sender: 'me',
              text: values['text'].toString(),
              type: values['type'].toString());
          print("GetMessage Scanner: ${values['text'].toString()}");
        }
      });
    });
    var sortedKeys = (chats.keys.toList()
      ..sort()).reversed.toList();
    for (int i = 0; i < sortedKeys.length; i++) {
      finalData.add(chats[sortedKeys[i]]);
      //print("database: ${finalData[i].getSender()} ${finalData[i].getType()} ${finalData[i].getText()}");
    }
    return finalData;
  }

  uploadFile(File file) async { //TODO upload File
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference reference = storage.ref().child(getDateTime());
      UploadTask uploadTask = reference.putFile(file);
      var imageUrl = await (await uploadTask).ref.getDownloadURL();
      return imageUrl.toString();
    } catch (e) {
      print("uploadImage error: ${e.toString()}");
    }
  }

  sendFile(String url, String name, String friendCredential) async { //TODO send File
    await FirebaseDatabase.instance
        .reference()
        .child('chats')
        .child(getDateTime())
        .set({
      'sender': meCredential,
      'receiever': friendCredential,
      'text': url,
      'type': name ,
    });
  }
}

String getDateTime() { //TODO get Date And Time
  String day = DateTime.now().day.toString().padLeft(2, '0');
  print(day);

  String month = DateTime.now().month.toString().padLeft(2, '0');
  print(month);

  String year = DateTime.now().year.toString().padLeft(4, '0');
  print(year);

  String hour = DateTime.now().hour.toString().padLeft(2, '0');
  print(hour);

  String minute = DateTime.now().minute.toString().padLeft(2, '0');
  print(minute);

  String second = DateTime.now().second.toString().padLeft(2, '0');
  print(second);

  String millisecond = DateTime.now().millisecond.toString().padLeft(4, '0');
  print(millisecond);

  String micresecond = DateTime.now().microsecond.toString().padLeft(7, '0');
  print(micresecond);

  String dateTime =
      year + month + day + hour + minute + second + millisecond + micresecond;
  print(dateTime);
  return dateTime;
}

downloadImageFromURL(String url) async { //TODO Download file from URL
  var response = await http.get(url);
  var filePath = await ImagePickerSaver.saveFile(fileData: response.bodyBytes);
  print(filePath);
}

class TaskMessages{
  String meCredential = FirebaseAuth.instance.currentUser.uid.toString();
  assignTask(String title,String description,String friendCredential) async { //TODO Assign Task
    String dateTime = getDateTime();
    await FirebaseDatabase.instance.reference().child('task').child(dateTime).set({
      'sender':meCredential,
      'receiver':friendCredential,
      'title':title,
      'description':description,
      'status':'pending',
      'key':dateTime,
    });
    messageTask(friendCredential, title,'Pending', dateTime);
  }

  messageTask(String friendCredential,String title,String status,String dateTime) async { //TODO Message Task
    await FirebaseDatabase.instance.reference().child('chats').child(dateTime).set({
      'sender': meCredential,
      'receiever': friendCredential,
      'text': "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} ${DateTime.now().hour}:${DateTime.now().minute} $title $status",
      'type': 'task',
    });
  }
  
  updateTask(String key,String newStatus,String title,String friendCredential) async { //TODO: Update Task
    await FirebaseDatabase.instance.reference().child('task').child(key).child('status').set(newStatus);
    await messageTask(friendCredential, title, newStatus, getDateTime());
  }
  
  getName(String credential) async { //TODO: Get Name of Sender
    await FirebaseDatabase.instance.reference().child('users').child(credential).once().then((DataSnapshot snapshot){
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        if(key.toString()=='name'){
          String res= values.toString();
          print("getName $res");
          return res;
        }
      });
    });
  }

  getTask() async {
    //TODO: Get Task
    final Map<String, taskData> unit = new Map<String, taskData>();
    final List<taskData> data = new List<taskData>();
    await FirebaseDatabase.instance
        .reference()
        .child('task')
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        print("getTask ${key.toString()}");
        if (values['receiver'].toString() == meCredential) {
          unit[key.toString()] = taskData(
            description: values['description'].toString(),
            key: values['key'].toString(),
            receiver: values['receiver'].toString(),
            sender: values['sender'].toString(),
            status: values['status'].toString(),
            title: values['title'].toString(),
          );
        }
      });
    });
    print("getTask unit:${unit.length}");
    var sortedKeys = (unit.keys.toList()
      ..sort()).reversed.toList();
    for (int i = 0; i < sortedKeys.length; i++) {
      data.add(unit[sortedKeys[i]]);
    }
    print("getTask data: ${data.length}");
    List<taskData> finalData = data;
    return finalData;
  }
  
  removeTask(String key,String title,String friendCredential) async {
    await FirebaseDatabase.instance.reference().child('task').child(key).set(null);
    await messageTask(friendCredential, title, 'Canceled', getDateTime());
  }
}