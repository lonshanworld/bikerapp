import "dart:convert";
import "dart:io";

import "package:delivery/constants/txtconstants.dart";
import "package:get_storage/get_storage.dart";
import "package:http/http.dart" as http;

class ChatService{
  final box = GetStorage();

  Future<String> convertImageToBase64(File imageFile) async {
    List<int> imageBytes = await imageFile.readAsBytes();
    return base64Encode(imageBytes);
  }

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

  Future<http.Response?> sendImage(File imageFile)async{
    String url = "${TxtConstant.mainUrl}chat/conversations/image-attach";
    String imageString = await convertImageToBase64(imageFile);
    try{
      http.Response response = await http.post(Uri.parse(url),headers: {
        "Authorization" : "bearer ${box.read(TxtConstant.accesstoken)}"
      },body: {
        "imageBase64" : imageString,
      });
      if(response.statusCode < 299){
        return response;
      }else{
        return null;
      }
    }catch(err){
      print(err);
      return null;

    }
  }
}