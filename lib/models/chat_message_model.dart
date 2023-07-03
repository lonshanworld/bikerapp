class ChatMessageModel{
  String? userId;
  String? messageId;
  String? fullname;
  String? message;
  String? sentOn;
  String? chatAttachment;
  bool? isBiker;

  ChatMessageModel({
    required this.userId,
    required this.messageId,
    required this.fullname,
    required this.message,
    required this.sentOn,
    required this.chatAttachment,
    required this.isBiker,
});

  ChatMessageModel.fromJson(Map<String, dynamic>json,{required String bikerId}){
    userId = json["userId"];
    messageId = json["messageId"];
    fullname = json["fullName"];
    message = json["message"];
    sentOn = json["sentOn"];
    chatAttachment = json["chatAttachment"];
    isBiker = (bikerId == json["userId"]) ? true : false;
  }
}