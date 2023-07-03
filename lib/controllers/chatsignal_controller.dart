import 'dart:convert';
import "dart:io";
import 'package:delivery/models/chat_message_model.dart';
import 'package:delivery/services/chat_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:signalr_netcore/http_connection_options.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import "package:http/http.dart" as http;
import '../constants/txtconstants.dart';

class ChatSignalControlller extends GetxController{
  final box = GetStorage();
  final chatService = ChatService();

  final RxList<ChatMessageModel> chatlist = List<ChatMessageModel>.empty().obs;
  final RxString orderId = "".obs;
  final RxString conversationId = "".obs;

  HubConnection hubConnection = HubConnectionBuilder().withUrl(TxtConstant.chatserverUrl,
      options: HttpConnectionOptions(
        requestTimeout: 60000,
      )
  ).withAutomaticReconnect().build();

  @override
  void onReady() async{
    hubConnection.onclose(({error}) {
      print(error);
    });

    super.onReady();
  }

  Future<void> sendSignal()async{
    print("conecting chat signal");
    if(hubConnection.state != HubConnectionState.Connected){
      await hubConnection.start()?.then((value) async {
        await hubConnection.invoke("SaveConnection", args: [
          hubConnection.connectionId!,
          box.read(TxtConstant.user_id),
        ]);
      });
    }
    hubConnection.on("Status", (res) {
      // print(res);
    });
    hubConnection.on("ReceivedMessage", (res) {
      print("Recievedmessage triggered======================");
      List<Object?>? rawdata = res;
      var data = rawdata![0]  as Map<String, dynamic>;
      assignDataList(data);
    });
    hubConnection.onreconnected(({connectionId}) async{
      print("on reconnected =================");
      await hubConnection.invoke("SaveConnection", args: [
        hubConnection.connectionId!,
        box.read(TxtConstant.user_id),
      ]);
    });
  }

  assignDataList(dynamic data)async{
    var userId = data["userId"];
    var messageId = data["messageId"];
    var fullname = data["fullName"];
    var message = data["message"];
    var sentOn = data["sentOn"];
    var fileattachment = data["chatAttachment"]["filePath"];
    var isuser = data["userId"] == box.read(TxtConstant.user_id) ? true : false;
    //

    print("get data from recieve message");
    print(userId);
    print(messageId);
    print(fullname);
    print(message);
    print(sentOn);
    print(fileattachment);
    print(isuser);
    bool imageexist = await checkIfImageExists(fileattachment);

    ChatMessageModel chat = ChatMessageModel(
        userId: userId,
        messageId: messageId,
        fullname: fullname,
        message: message,
        sentOn: sentOn,
        chatAttachment: imageexist ? fileattachment : null,
        isBiker: isuser,
    );

    final messageidlist= [];
    chatlist.map((element){
      print(element.messageId);
      messageidlist.add(element.messageId);
    });
    if(!messageidlist.contains(chat.messageId)){
      chatlist.insert(0, chat);
    }
  }

  Future<dynamic> startconversation({required String orderId, required String initialMessage,})async{
    final conversationID = await hubConnection.invoke("CreateConversation",args: [
      hubConnection.connectionId!,
      box.read(TxtConstant.user_id),
      "Hi Customer",
      orderId,
      // "",
    ]);
    return conversationID;
  }

  Future sendMessage({required String conversationId,required String? txt, required File? file})async{
    return await hubConnection.invoke("SendMessage",args: [
      hubConnection.connectionId!,
      box.read(TxtConstant.user_id),
      conversationId,
      txt!,
      file == null ? "" : file.path,
    ]);
    // print("this is send message data");
    // print(data);
  }

  Future<void> getchatList({required String conversationId, required int pagenum})async{
    http.Response response = await chatService.getchatList(conversationId: conversationId, pagesize: pagenum, pagerow: 20);
    dynamic rawdata = json.decode(response.body);
    if(pagenum > 0){
      for(dynamic data in rawdata["data"]["messages"]){
        ChatMessageModel chat = ChatMessageModel.fromJson(data, bikerId: box.read(TxtConstant.user_id));
        chatlist.insert(0,chat);
      }
    }else{
      chatlist.clear();
      for(dynamic data in rawdata["data"]["messages"]){
        print(data);
        ChatMessageModel chat = ChatMessageModel.fromJson(data, bikerId: box.read(TxtConstant.user_id));
        chatlist.insert(0,chat);
      }
    }
  }

  Future<void> closehub()async{
    if(hubConnection.state == HubConnectionState.Connected){
      chatlist.clear();
      orderId.value = "";
      conversationId.value = "";
      await hubConnection.stop();
    }
  }



  Future<bool> checkIfImageExists(String url) async {
    try{
      final response = await http.get(Uri.parse(url));
      if(response.statusCode == 200){
        return true;
      }else{
        return false;
      }
    }catch(err){
      return false;
    }
  }

}