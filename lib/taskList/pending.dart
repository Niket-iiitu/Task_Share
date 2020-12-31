import 'package:flutter/material.dart';
import 'package:prototype4/services/database.dart';
import 'package:prototype4/services/user.dart';
import 'package:prototype4/taskList/taskClass.dart';
import 'package:prototype4/widgets/app_widgets.dart';

class PendingExpansionList extends StatefulWidget {
  @override
  _PendingExpansionListState createState() => _PendingExpansionListState();
}

class _PendingExpansionListState extends State<PendingExpansionList> {
  List<ListItem> data = new List<ListItem>(); //TODO: Variables

  getData(){
    TaskMessages taskMessages = new TaskMessages();
    List<taskData> onlineData = taskMessages.getTask();
    for(taskData unit in onlineData)
      if(unit.getStatus()=='pending'){
        data.add(
            ListItem(
                title: unit.getTitle(),
                description: unit.getDescription(),
                senderCredential: unit.getSender(),
                key: unit.getKey(),
                isExpanded: false,
                senderName: taskMessages.getName(unit.getSender())),
        );
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }

  Widget taskList(){
    return ExpansionPanelList(
      expansionCallback: (int index,bool isExpanded){
        setState(() {
          data[index].isExpanded=!isExpanded;
        });
      },
      children: data.map<ExpansionPanel>((ListItem listItem){
        return ExpansionPanel(
            headerBuilder: (BuildContext context,bool  isExpanded){
              return ListTile(
                title: Text(listItem.getTitle()),
              );
            },
            body: ListTile(
              title: Text(listItem.description),
              subtitle: Text(listItem.senderName),
              trailing: Container(
                child: Row(
                  children: [
                    FlatButton( //TODO: Underway a task
                        onPressed: (){
                          data.removeWhere((element) => listItem == element);
                          TaskMessages taskMessages = new TaskMessages();
                          taskMessages.updateTask(listItem.getKey(), 'underway', listItem.title, listItem.senderCredential);
                        },
                        child: Text(
                          "START",
                          style: TextStyle(
                            color: Colors.greenAccent[400],
                            fontStyle: FontStyle.italic
                          ),
                        )
                    ),
                    FlatButton( //TODO: Cancel Task
                        onPressed: (){
                          data.removeWhere((element) => listItem == element);
                          TaskMessages taskMessages = new TaskMessages();
                          taskMessages.removeTask(listItem.key, listItem.title, listItem.senderCredential);
                        },
                        child: Text(
                          "CANCEL",
                          style: TextStyle(
                              color: Colors.red,
                              fontStyle: FontStyle.italic
                          ),
                        )
                    )
                  ],
                ),
              ),
            )
        );
      })
    );
  }
}

