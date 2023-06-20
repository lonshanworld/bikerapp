import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:signalr_netcore/http_connection_options.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';

import '../constants/txtconstants.dart';

class ChatSignalControlller extends GetxController{
  final box = GetStorage();

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
    await hubConnection.start();
    print("checking hub connection====================================");
    print(hubConnection.state);
    super.onReady();
  }

  Future<void> sendSignal()async{
    await hubConnection.invoke("CreateConnection",args: <Object>[
      {"connectionId" : hubConnection.connectionId,"userId": box.read(TxtConstant.user_id),}
    ]);
  }
}