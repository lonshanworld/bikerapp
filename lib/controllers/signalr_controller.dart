import 'package:delivery/error_handlers/error_handlers.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:signalr_netcore/http_connection_options.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'package:signalr_netcore/itransport.dart';

import '../constants/txtconstants.dart';
import 'location_controller.dart';

class SignalRController extends GetxController{

  final LocationController locationController = Get.find<LocationController>();
  final box = GetStorage();
  final ErrorHandler errorHandler = ErrorHandler();
  HubConnection hubConnection = HubConnectionBuilder().withUrl(TxtConstant.serverUrl,
    options: HttpConnectionOptions(
      requestTimeout: 60000,
    )
  ).withAutomaticReconnect().build();

  @override
  void onReady()async{
    print("on ready in signalR");
    hubConnection.onclose(({error}) {
      print(error);
    });
    // await hubConnection.start();
    super.onReady();
  }

  Future startSignalR()async{
    await hubConnection.start()?.then((_){
      print("This is success in signalR");
    },onError: (Object) async{
      print("This is error in signalR ${Object.toString()}");
      await hubConnection.start();
    });

    if(hubConnection.connectionId == null){
      throw errorHandler.handleNullError("Notification Server is not connected");
    }
    print(hubConnection.state);
    hubConnection.on("LocationRequest", (res){
      print(res);
      print(hubConnection.state);
      if(hubConnection.state == HubConnectionState.Connected){
        locationController.getPermission().then((permit) {
          if(permit){
            locationController.getcurLagLong().then((point)async{
              print("This working ...");
              await hubConnection.invoke("LocationSend", args: <Object>[
                {"userid": box.read(TxtConstant.user_id),"lat" : point.latitude,"lng" : point.longitude},
              ]).then((res){
                print("heytyyyy");
                print(res);
              });
            });
          }
        });
      }else{
        print("connection state == ${hubConnection.state}");
      }
    });
  }
}