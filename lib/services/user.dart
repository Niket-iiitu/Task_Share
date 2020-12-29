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
