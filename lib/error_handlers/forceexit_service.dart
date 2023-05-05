import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';

class ForceExitAppService{

  exitApp(){
    print(defaultTargetPlatform);
    if(defaultTargetPlatform == TargetPlatform.iOS){
      FlutterExitApp.exitApp(iosForceExit: true);
      SystemNavigator.pop();
    }if(defaultTargetPlatform ==  TargetPlatform.android){
      SystemNavigator.pop();
    }else{
      SystemNavigator.pop();
    }
  }
}