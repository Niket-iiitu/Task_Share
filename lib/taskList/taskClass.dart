class ListItem{
  String title;
  String description;
  String senderCredential;
  String senderName;
  String key;
  bool isExpanded;

  ListItem({this.title, this.description, this.senderCredential, this.isExpanded,this.key,this.senderName});

  String getTitle() {
   return title;
  }
  String getDescription() {
    return description;
  }
  String getSenderCredential() {
    return senderCredential;
  }
  String getSenderName() {
    return senderName;
  }
  String getKey() {
    return key;
  }
  bool getIsExpanded() {
    return isExpanded;
  }
}