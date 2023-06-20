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
    await hubConnection.start()?.then((value) async {
      print("Hub coneection success=====");
      print(hubConnection.connectionId);
      print(box.read(TxtConstant.user_id));
      await hubConnection.invoke("SaveConnection", args: [
        hubConnection.connectionId!,
        box.read(TxtConstant.user_id),
      ]);
    });
    print("checking hub connection====================================");
    print(hubConnection.state);
    hubConnection.on("Status", (res) {
      print(res);
    });
    hubConnection.on("Receivemessage", (res) {
      if(orderId.value != "" && conversationId.value != ""){
        getchatList(conversationId: conversationId.value, pagenum: 0);
      }
    });
  }

  Future<dynamic> startconversation({required String orderId, required String initialMessage,})async{
    print("start conversation");
    final conversationID = await hubConnection.invoke("CreateConversation",args: [
      hubConnection.connectionId!,
      box.read(TxtConstant.user_id),
      "",
      orderId,
    ]);
    print(conversationID);
    return conversationID;
  }

  Future sendMessage({required String conversationId,required String? txt, required File? file})async{
    return await hubConnection.invoke("SendMessage",args: [
      hubConnection.connectionId!,
      box.read(TxtConstant.user_id),
      conversationId,
      txt!,
    ]);
  }

  Future<void> getchatList({required String conversationId, required int pagenum})async{
    http.Response response = await chatService.getchatList(conversationId: conversationId, pagesize: pagenum, pagerow: 20);
    dynamic rawdata = json.decode(response.body);
    print(rawdata["data"]["messages"].length);
    if(pagenum > 0){
      print("Inside more chat list");
      for(dynamic data in rawdata["data"]["messages"]){

        ChatMessageModel chat = ChatMessageModel.fromJson(data, bikerId: box.read(TxtConstant.user_id));
        chatlist.add(chat);
      }
    }else{
      print("Inside more chat list but int is -");
      chatlist.clear();
      for(dynamic data in rawdata["data"]["messages"]){
        ChatMessageModel chat = ChatMessageModel.fromJson(data, bikerId: box.read(TxtConstant.user_id));
        chatlist.add(chat);
      }
    }
  }

}