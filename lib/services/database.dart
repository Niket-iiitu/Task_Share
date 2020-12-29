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
  getUserByUsername(String username) async {
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

Future<void> AddFriend(
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
  GetFriends() async {
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

  sendMessage(String message, String friendCredential) async {
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

  GetMessages(String friendCredential) async {
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
        }
        if (values['receiever'].toString() == friendCredential &&
            values['sender'].toString() == meCredential) {
          chats[key.toString()] = new textData(
              receiever: 'friend',
              sender: 'me',
              text: values['text'].toString(),
              type: values['type'].toString());
        }
      });
    });
    var sortedKeys = (chats.keys.toList()
      ..sort()).reversed.toList();
    for (int i = 0; i < sortedKeys.length; i++) {
      finalData.add(chats[sortedKeys[i]]);
      print("database: ${finalData[i].getSender()} ${finalData[i].getType()}");
    }
    return finalData;
  }

  uploadFile(File file) async {
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

  sendFile(String url, String friendCredential) async {
    String name = getDateTime();
    await FirebaseDatabase.instance
        .reference()
        .child('chats')
        .child(name)
        .set({
      'sender': meCredential,
      'reciever': friendCredential,
      'text': url,
      'type': name + " TaskShare",
    });
  }
}

String getDateTime() {
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

downloadImageFromURL(String url) async {
  var response = await http.get(url);
  var filePath = await ImagePickerSaver.saveFile(fileData: response.bodyBytes);
  print(filePath);
}