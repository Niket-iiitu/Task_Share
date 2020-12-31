class UserID {
  final String userID;

  UserID({this.userID});
}

class textData {
  final String receiever;
  final String sender;
  final String text;
  final String type;

  textData({this.receiever, this.sender, this.text, this.type});

  String getReceiever() {
    return receiever;
  }

  String getSender() {
    return sender;
  }

  String getText() {
    return text;
  }

  String getType() {
    return type;
  }
}

class taskData{
  final String description;
  final String key;
  final String receiver;
  final String sender;
  final String title;
  final String status;

  taskData({this.description, this.key, this.receiver, this.sender, this.title,this.status});

  String getDescription(){
    return description;
  }

  String getKey(){
    return key;
  }

  String getReceiver(){
    return receiver;
  }

  String getSender(){
    return sender;
  }

  String getTitle(){
    return title;
  }

  String getStatus(){
    return status;
  }
}

// class chatsData {
//   final String key;
//   final textData data;
//   chatsData({this.key, this.data});
  
//   getKey() {
//     return key;
//   }

//   getData() {
//     return data;
//   }
// }
