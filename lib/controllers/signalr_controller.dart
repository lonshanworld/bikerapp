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

  final LocationController locationController = Get.put(LocationController());
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
    await hubConnection.start()?.then((_)async{
      print("This is success in signalR");
      await hubConnection.invoke("SaveConnection", args: [
        hubConnection.connectionId!,
        box.read(TxtConstant.user_id),
      ]);
    },onError: (Object) async{
      print("This is error in signalR ${Object.toString()}");

    });

    hubConnection.onreconnected(({connectionId})async{
      await hubConnection.invoke("SaveConnection", args: [
        hubConnection.connectionId!,
        box.read(TxtConstant.user_id),
      ]);
    });

    if(hubConnection.connectionId == null){
      throw errorHandler.handleNoSignalRerror("Notification Server is not connected");
    }else{

    }
    print(hubConnection.state);
    hubConnection.on("GeoPointRequest", (res){

      print(hubConnection.state);
      if(hubConnection.state == HubConnectionState.Connected){

        locationController.getPermission().then((_) {
            // if(permit){
            //   locationController.getcurLagLong().then((point)async{
            //     print("This working ...");
            //     await hubConnection.invoke("LocationSend", args: <Object>[
            //       {"userid": box.read(TxtConstant.user_id),"lat" : point.latitude,"lng" : point.longitude},
            //     ]).then((res){
            //       print("heytyyyy");
            //       print(res);
            //     });
            //   });
            // }
          locationController.getcurLagLong().then((point)async{
              print("This working ...");
              await hubConnection.invoke("SendingGeoPoint", args: <Object>[res![0]!,
                {
                  // "userid": box.read(TxtConstant.user_id),
                  "lat" : point.latitude,
                  "lng" : point.longitude
                },
              ]).then((response){
                print(response);
              });
            });
          });
     }else{
          print("connection state == ${hubConnection.state}");
     }
    });
  }

  Future<void> stopSignal()async{
    await hubConnection.stop();
  }
}