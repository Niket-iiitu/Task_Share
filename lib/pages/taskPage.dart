import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prototype4/widgets/app_widgets.dart';

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  int taskLeft=0,taskInProcess=0,taskStall=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(context),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            bottomTile(taskLeft, Colors.purple[600], "Left"),
            bottomTile(taskInProcess, Colors.green, "Underway"),
            bottomTile(taskStall, Colors.red , "Stalled"),
          ],
        ),
      ),
      body: Container(),
    );
  }

  Widget bottomTile(int num,Color color,String s){
    print("bottomTile $s");
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            num.toString(),
            style: TextStyle(
              fontSize: 25,
              color: color,
              fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(width: 8,),
          Text(
            s,
            style: TextStyle(
                fontSize: 18,
                color: color,
                fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
