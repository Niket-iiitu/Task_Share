import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prototype4/services/database.dart';
import 'package:prototype4/services/user.dart';
import 'package:prototype4/taskList/pending.dart';
import 'package:prototype4/taskList/taskClass.dart';
import 'package:prototype4/widgets/app_widgets.dart';

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  int taskPending, taskUnderway, taskStall; //TODO: Global Variables
  List<ListItem> dataPending = new List<ListItem>();
  List<ListItem> dataUnderway = new List<ListItem>();
  List<ListItem> dataStalled = new List<ListItem>();
  List<taskData> onlineData = new List<taskData>();
  List<int> isExpandedPending = new List<int>();
  List<int> isExpandedUnderway = new List<int>();
  List<int> isExpandedStalled = new List<int>();
  bool isLoaded = false;

  getData() async {
    //TODO: Get Data
    TaskMessages taskMessages = new TaskMessages();
    onlineData = await taskMessages.getTask();
    isLoaded = true;
    dataPending = new List<ListItem>();
    dataUnderway = new List<ListItem>();
    dataStalled = new List<ListItem>();

    int p = 0,
        u = 0,
        s = 0;

    for (int i = 0; i < onlineData.length; i++) {
      switch (onlineData[i].getStatus()) {
        case 'pending':
          {
            isExpandedPending.add(p);
            p++;
            dataPending.add(ListItem(
              title: onlineData[i].title,
              description: onlineData[i].description,
              senderCredential: onlineData[i].sender,
              isExpanded: false,
              key: onlineData[i].key,
              senderName: onlineData[i].name,
            ));
          }
          break;
        case 'underway':
          {
            isExpandedUnderway.add(u);
            u++;
            dataUnderway.add(ListItem(
              title: onlineData[i].title,
              description: onlineData[i].description,
              senderCredential: onlineData[i].sender,
              isExpanded: false,
              key: onlineData[i].key,
              senderName: onlineData[i].name,
            ));
          }
          break;
        case 'stall':
          {
            isExpandedStalled.add(s);
            s++;
            dataStalled.add(ListItem(
              title: onlineData[i].title,
              description: onlineData[i].description,
              senderCredential: onlineData[i].sender,
              isExpanded: false,
              key: onlineData[i].key,
              senderName: onlineData[i].name,
            ));
          }
          break;
      }
    }
    taskPending = p;
    taskUnderway = u;
    taskStall = s;

    print("taskPage getData $taskPending $taskUnderway $taskStall");
  }

  @override
  Widget build(BuildContext context) {
    //TODO: Page Builder
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Task Share",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.blue[600],
            bottom: TabBar(
              indicator: BoxDecoration(color: Colors.lightBlue),
              //isScrollable: true,
              tabs: <Widget>[
                Tab(
                  text: "Pending",
                ),
                Tab(
                  text: "Underway",
                ),
                Tab(
                  text: "Stalled",
                )
              ],
            ),
          ),
          body: TabBarView(
            children: [
              FutureBuilder(
                  future: getData(),
                  builder: (BuildContext ctx, snapshot) =>
                  (snapshot.connectionState == ConnectionState.waiting) ?
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      child: CircularProgressIndicator(),
                    ),
                  ) : fragmentList(dataPending,Colors.purple[600],'pending')
              ),
              FutureBuilder(
                  future: getData(),
                  builder: (BuildContext ctx, snapshot) =>
                  (snapshot.connectionState == ConnectionState.waiting) ?
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      child: CircularProgressIndicator(),
                    ),
                  ) : fragmentList(dataUnderway,Colors.green,'underway')
              ),
              FutureBuilder(
                  future: getData(),
                  builder: (BuildContext ctx, snapshot) =>
                  (snapshot.connectionState == ConnectionState.waiting) ?
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      child: CircularProgressIndicator(),
                    ),
                  ) : fragmentList(dataStalled,Colors.red,'stall')
              ),
            ],
          ),
          bottomNavigationBar: BottomAppBar(
            color: Colors.black,
            child: FutureBuilder(
              future: getData(),
              builder: (BuildContext ctx, snapshot) =>
              (snapshot.connectionState == ConnectionState.waiting)
                  ? Container()
                  :
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  bottomTile(taskPending, Colors.purple[600], "PENDING"),
                  bottomTile(taskUnderway, Colors.green, "UNDERWAY"),
                  bottomTile(taskStall, Colors.red, "STALLED"),
                ],
              ),
            ),
          )),
    );
  }

  Widget bottomTile(int num, Color color, String s) {
    //TODO: Bottom Tile
    //print("bottomTile $s");
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            num.toString(),
            style: TextStyle(
                fontSize: 25, color: color, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: 8,
          ),
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

  Widget fragmentList(List<ListItem> data,Color color,String state) {
    //TODO: Pending List Builder
    return (data.isEmpty) ? Container() : new ListView.separated(
        itemCount: taskPending,
        separatorBuilder: (context, index) => Divider(
          color: color,
          thickness: 2.5,
        ),
        itemBuilder: (context, i) =>
            ExpansionTile(
              title: Text(
                data[i].getTitle(),
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 21.0,
                ),
              ),
              subtitle: Text(
                data[i].getSenderName(),
                style: TextStyle(
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                  fontSize: 15.0,
                ),
              ),
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            data[i].getDescription(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                            maxLines: 5,
                          ),
                        )
                    ),
                    GestureDetector(
                      onTap: () {
                        print('tap');
                        showDialog(
                            context: context,
                            builder: (context) => changeStatus(data[i].getTitle(), state));
                      },
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.title,
                          color: Colors.blue,
                          size: 20,
                        ),
                      ),
                    )
                  ],
                )
              ],
            )
    );
  }

  AlertDialog changeStatus(String title,String state){ //TODO: Change Status Dialog
    return AlertDialog(
      backgroundColor: Colors.black54,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.bold,
              fontSize: 21.0,
            ),
          ),
          Text(
            "Current State : $state",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          Row(
            children: [
              GestureDetector(
                child: Text('Underway')
              ),
              GestureDetector(
                child: Text('Delete'),
              )
            ],
          )
        ],
      ),
    );
  }
}
