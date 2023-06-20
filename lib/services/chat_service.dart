import "package:delivery/constants/txtconstants.dart";
import "package:firebase_messaging/firebase_messaging.dart";
import "package:get_storage/get_storage.dart";
import "package:http/http.dart" as http;

class ChatService{
  final box = GetStorage();

  Future getchatList({required String conversationId, required int pagesize, required int pagerow})async{
    String url = "${TxtConstant.mainUrl}chat/conversations/${conversationId}?pagesize=${pagesize}&pagerows=${20}";
    try{
      http.Response response = await http.get(Uri.parse(url),headers: {
        "Authorization" : "bearer ${box.read(TxtConstant.accesstoken)}"
      });
      return response;
    }catch(err){
      print(err);
    }
  }
}