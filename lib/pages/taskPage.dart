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
  int taskLeft, taskInProcess, taskStall; //TODO: Global Variables
  List<ListItem> dataPending = new List<ListItem>();
  bool isLoaded = false;
  List<int> isExpanded = new List<int>();

  getData() async {
    //TODO: Get Data
    //isLoaded=false;
    isExpanded = new List<int>();
    dataPending = new List<ListItem>();
    TaskMessages taskMessages = new TaskMessages();
    List<ListItem> pending = new List<ListItem>();
    int left = 0, underway = 0, halt = 0;
    List<taskData> onlineData = new List<taskData>();
    onlineData =await taskMessages.getTask();
    for (taskData unit in onlineData) {
      switch (unit.getStatus()) {
        case 'pending':
          {
            left++;
            isExpanded.add(left-1);
            await taskMessages.getName(unit.getSender()).then((res){
              pending.add(
                  ListItem(
                    title: unit.getTitle(),
                    description: unit.getDescription(),
                    senderCredential: unit.getSender(),
                    key: unit.getKey(),
                    isExpanded: false,
                    senderName: res.toString(),
                  ));
              print("getData sender: $res");

            });
          }
          break;
        case 'underway':
          {
            underway++;
          }
          break;
        case 'halt':
          {
            halt++;
          }
          break;
      }

      setState(() {
        taskLeft = left;
        taskInProcess = underway;
        taskStall = halt;
        dataPending=pending;
      });
    }
    print("Task Page: " + taskLeft.toString());
    print("Task Page: " + taskInProcess.toString());
    print("Task Page: " + taskStall.toString());
    isLoaded=true;
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
                  text: "Halted",
                )
              ],
            ),
          ),
          body: TabBarView(
              children: [
                pendingList(),
                Container(
                  child: Text("Underway"),
                ),
                Container(
                  child: Text("Halted"),
                ),
              ],
            ),
          bottomNavigationBar: BottomAppBar(
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                bottomTile(taskLeft, Colors.purple[600], "Left"),
                bottomTile(taskInProcess, Colors.green, "Underway"),
                bottomTile(taskStall, Colors.red, "Stalled"),
              ],
            ),
          )),
    );
  }

  Widget bottomTile(int num, Color color, String s) {
    //TODO: Bottom Tile
    //print("bottomTile $s");
    getData();
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

  Widget pendingList(){
    return (dataPending.isEmpty)?Container():SingleChildScrollView(
      //TODO: Pending fragment
      child: (!isLoaded) ? Align(
        alignment: Alignment.center,
        child: Container(
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
        ),
      )
          : ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            dataPending[index].isExpanded = !isExpanded;
          });
          print('tap ${dataPending[index].isExpanded}');
        },
        children:
        isExpanded.map((index) {
          return ExpansionPanel(
              isExpanded: dataPending[index].getIsExpanded(),
              headerBuilder:
                  (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Text(dataPending[index].getTitle()),
                );
              },
              body: ListTile(
                dense: true,
                onTap: (){
                  setState(() {
                    dataPending[index].isExpanded=!dataPending[index].getIsExpanded();
                  });
                },
                title: Text(dataPending[index].getSenderName()),
                subtitle: Text(dataPending[index].getDescription()),
                trailing: Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector( //TODO: Underway a task
                        onTap: () {
                          dataPending.removeWhere(
                                  (element) => dataPending[index] == element
                          );
                          TaskMessages taskMessages =
                          new TaskMessages();
                          taskMessages.updateTask(
                              dataPending[index].getKey(),
                              'underway',
                              dataPending[index].getTitle(),
                              dataPending[index].getSenderCredential());
                        },
                        child: Container(
                          padding: EdgeInsets.all(5.0),
                          child: Icon(
                            Icons.play_arrow,
                            color: Colors.greenAccent[400],
                          ),
                        ),
                      ),
                      GestureDetector( //TODO: Cancel Task
                        onTap:() {
                          setState(() {
                            dataPending.removeWhere(
                                    (element) => dataPending[index] == element);
                          });
                          TaskMessages taskMessages =
                          new TaskMessages();
                          taskMessages.removeTask(
                              dataPending[index].key,
                              dataPending[index].title,
                              dataPending[index].senderCredential);
                        },
                        child: Container(
                          padding: EdgeInsets.all(5.0),
                          child: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ));
        }).toList(),
      ),
    );
  }


}
