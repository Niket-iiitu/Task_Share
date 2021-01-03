import 'package:flutter/material.dart';
import 'package:prototype4/services/database.dart';
import 'package:prototype4/services/user.dart';
import 'package:prototype4/taskList/taskClass.dart';
import 'package:prototype4/widgets/app_widgets.dart';

class PendingListMaker {

  List<ListItem> dataPending = new List<ListItem>(); //TODO: Variables
  getPendingData() {
    TaskMessages taskMessages = new TaskMessages();
    List<taskData> onlinePendingData = taskMessages.getTask();
    for (taskData unit in onlinePendingData)
      if (unit.getStatus() == 'pending') {
        dataPending.add(
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

  Widget taskList() {
    return SingleChildScrollView(
      child: Container(
        child: ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              //setState(() {
                dataPending[index].isExpanded = !isExpanded;
              //});
            },
            children: dataPending.map<ExpansionPanel>((ListItem listItem) {
              return ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
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
                              onPressed: () {
                                dataPending.removeWhere((element) => listItem == element);
                                TaskMessages taskMessages = new TaskMessages();
                                taskMessages.updateTask(listItem.getKey(),
                                    'underway', listItem.title,
                                    listItem.senderCredential);
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
                              onPressed: () {
                                dataPending.removeWhere((element) => listItem == element);
                                TaskMessages taskMessages = new TaskMessages();
                                taskMessages.removeTask(
                                    listItem.key, listItem.title,
                                    listItem.senderCredential);
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
            }).toList()
        ),
      ),
    );
  }


}