import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:prototype4/widgets/app_widgets.dart';
import 'package:prototype4/services/database.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ImageCapture extends StatefulWidget {
  final String friendCredential;
  ImageCapture({Key key, this.friendCredential}) : super(key: key);
  @override
  _ImageCaptureState createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  // List<File> file = new List<File>();
  List<String> name = new List<String>();
  List<PlatformFile> platformFile = new List<PlatformFile>();
  TextEditingController fileName = new TextEditingController();
  bool isLoading=false;

  getFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if(result != null) {
      setState(() {
        //file = result.paths.map((path) => File(path)).toList();
        //print("getFile file: ${file.length}");
        platformFile.addAll(result.files.toList());
        name=new List<String>();
        for(int i=0;i<platformFile.length;i++) {name.add(platformFile[i].name);}
        print("getFile PlatformFile: ${platformFile.length} name:${name.length}");
      });
    } else {
      print("takeImage: No file Taken");
    }
  }

  sendFile() async {
    if(platformFile!=null){
      ChatListMessage chatListMessage = new ChatListMessage();
      isLoading=true;
      for(int i=0;i<platformFile.length;i++) {
        await chatListMessage.uploadFile(File(platformFile[i].path)).then((
            url) async {
          await chatListMessage.sendFile(
              url.toString(), name[i], widget.friendCredential);
        });
      }
      isLoading=false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: chatAppBar(context, "Select File", platformFile.length.toString()),
        bottomNavigationBar: BottomAppBar(
            color: Colors.indigoAccent[400],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(
                      Icons.note_add,
                      color: Colors.lightBlue[400]
                  ),
                  onPressed:getFile,
                  iconSize: 40,
                ),
                IconButton(
                  icon: Icon(
                      Icons.cloud_upload_outlined,
                      color: Colors.red
                  ),
                  onPressed: sendFile,
                  iconSize: 40,
                ),
              ],
            )
        ),
        body: (isLoading)?Align(
            alignment: Alignment.center,
            child: Container(
              child: CircularProgressIndicator(),
            ),
          ):ListView.builder(
              shrinkWrap: true,
              itemCount: platformFile.length,
              itemBuilder: (context,index){
                return fileTile(platformFile[index],index);
              },
            )

    );
  }

  Widget fileTile(PlatformFile data,int index){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(width: 8,),
        Text(
        (index+1).toString(),
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20
          ),

        ),
        Expanded(
          child: FlatButton(
            onPressed:(){
              showDialog(
                  context: context,
                  builder: (context) => showImage(File(data.path),index)
              );
            },
            child:Container(
              padding: EdgeInsets.all(5),
              child: Text(
              name[index],
              maxLines: 1,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20
              ),
              ),
            ),
          ),
        ),
        FlatButton(
            onPressed: (){
              setState(() {
                platformFile.removeAt(index);
              });
            },
            child: Container(
              padding: EdgeInsets.all(5),
              child: Icon(
                  Icons.delete_outlined,
                color: Colors.red,
                size: 20,
              ),
            )
        ),
      ],
    );
  }

  AlertDialog showImage(File file,int index) {
    return new AlertDialog(
      title: SingleChildScrollView(
        child: Column(children: [
          // Container(
          //   child: Text(
          //     "Preview",
          //     style: whiteStyleW(context),
          //   ),
          //   padding: EdgeInsets.all(8.0),
          // ),
          Center(
            child: Column(
              children: [
                Image.file(
                  file,
                  fit: BoxFit.cover,
                  height: 250,
                  width: 200,
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: alertInput(context, platformFile[index].name),
                    style: amberStyle(context),
                    textAlign: TextAlign.center,
                    controller: fileName,
                  ),
                )
              ],
            ),
          ),
        ]),
      ),
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
              "Close",
              style: TextStyle(
                color: Colors.redAccent,
                fontStyle: FontStyle.italic,
                fontSize: 18.0,
              ),
            )),
        RaisedButton(
            onPressed: (() {
              setState(() {
                if(fileName.text.trim().length>2)name[index] = fileName.text.trim();
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
            )),
      ],
    );
  }
}
