import 'dart:async';
import 'dart:convert';

import 'dart:typed_data';


import 'package:delivery/constants/txtconstants.dart';
import 'package:delivery/routehelper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart' as GEO;

import "package:geolocator/geolocator.dart";
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import "package:flutter_polyline_points/flutter_polyline_points.dart";
import "package:image/image.dart" as IMG;
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';

import '../error_handlers/error_screen.dart';
import '../models/listofplaces_model.dart';


class LocationController extends GetxController{


  // @override
  // void onReady(){
  //   getLocationStream();
  //   super.onReady();
  // }
  final box = GetStorage();
  static const String Apikey = "AIzaSyB-m8EmkEroNVsQha_T90UANoQZ9dlCTVY";

  // Location location = new Location();
  late LocationSettings _locationSettings;
  // var streamPosition = <Position>[].obs;
  final RxList<Position> streamPosition = List<Position>.empty().obs;
  final RxList<LatLng> polypointStream = List<LatLng>.empty().obs;
  final RxString bikerplaceName = "".obs;

  StreamSubscription<Position>? locationstream;
  // HubConnection hubConnection = HubConnectionBuilder().withUrl(TxtConstant.serverUrl).withAutomaticReconnect().build();


  // static const serverUrl = "http://192.168.0.116/hub/locations";
  // HubConnection hubConnection = HubConnectionBuilder().withUrl(serverUrl).build();


  // @override
  // void onReady()async{
  //   getLocationStream();
  //   super.onReady();
  // }


  Future<void> getPermission() async{
    bool _serviceEnabled;
    LocationPermission _permission;

    _serviceEnabled = await Geolocator.isLocationServiceEnabled();
    print("In permission controller");
    print(_serviceEnabled);

    if (!_serviceEnabled) {
      Get.toNamed(RouteHelper.getLocationErrorPage(turnOn: false));
      throw Exception("Location is not turned on.");
    }
    _permission = await Geolocator.checkPermission();
    print(_permission);
    if (_permission == LocationPermission.denied || _permission == LocationPermission.deniedForever || _permission == LocationPermission.unableToDetermine) {
      LocationPermission finalpermission = await Geolocator.requestPermission();
      if(finalpermission == LocationPermission.denied || finalpermission == LocationPermission.deniedForever || finalpermission == LocationPermission.unableToDetermine){
        Get.toNamed(RouteHelper.getLocationErrorPage(turnOn: true));
        throw Exception("Location Permission must be allowed.");
      }
    }
    // else if(_permission == LocationPermission.whileInUse){
    //   late bool openappvalue;
    //   await showDialog(barrierDismissible: false,context: Get.context!, builder:(ctx){
    //     return ErrorScreen(
    //       title: "Location Permission",
    //       txt: "Location Permission should be allowed all the time. Please go to app setting",
    //       btntxt: 'Go to app setting',
    //       Func: ()async{
    //         await Geolocator.openAppSettings();
    //
    //         if(_permission == LocationPermission.always){
    //           openappvalue = true;
    //         }else{
    //           openappvalue = false;
    //         }
    //       },
    //     );
    //   } );
    //   return openappvalue;
    // }else{
    //   return true;
    // }

    // return true;

    // bool serviceenabled = await Geolocator.isLocationServiceEnabled();
    // if(!serviceenabled){
    //   await showDialog(barrierDismissible: false,context: Get.context!, builder: (ctx){
    //     return ErrorScreen(
    //       title: "Location Error",
    //       txt: txt,
    //       btntxt: btntxt,
    //       Func: Func,
    //     );
    //   },);
    // }

  }


  Future<Position> getcurLagLong()async{
    late Position _locationData;
    try{
      _locationData = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);

      return _locationData;
    }catch(err){
      print("Err $err");
      rethrow;
    }

  }


  Future <GEO.Placemark> getplacemark(double lat, double long) async{
    List<GEO.Placemark> list = await GEO.placemarkFromCoordinates(lat, long);
    List<String> placeStringList = [];
    print("This is in getplacemark");
    list.forEach((element) {
      String txt = "${element.thoroughfare}, ${element.subAdministrativeArea}, ${element.administrativeArea}";
      print(txt);
      placeStringList.add(txt);
    });
    bikerplaceName.value = placeStringList[0];
    return list[0];
  }


  Future<List<PlaceListModel>> getListofplaces(String input)async {
    String uri = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&language=my&components=country:MM&key=$Apikey";
    List<PlaceListModel> placelists = [];
    try{
      http.Response response = await http.get(Uri.parse(uri));
      var body = json.decode(response.body);
      var predictions = body["predictions"];
      for(int a = 0; a < predictions.length; a++){
        PlaceListModel _place = PlaceListModel(
          placename: predictions[a]["description"],
          placeId: predictions[a]["place_id"],
        );
        placelists.add(_place);
      }
      return placelists;

    }catch(err){
      print("Err $err");
      rethrow;
    }
  }


  Future<LatLng> getplaceDetailfromId(String placeid)async{
    String uri = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeid&&language=my&components=country:MM&key=$Apikey";
    try{
      http.Response response = await http.get(Uri.parse(uri));
      var body = json.decode(response.body);
      var address = body["result"]["geometry"]["location"];
      LatLng _latlng = LatLng(address["lat"], address["lng"]);
      return _latlng;
    }catch(err){
      print("err $err");
      rethrow;
    }
  }


  Future<List<LatLng>> getpolyPointList(LatLng firstlatlong, LatLng secondlatlong) async{
    PolylinePoints _polypoints = PolylinePoints();
    try{
      PolylineResult _result = await _polypoints.getRouteBetweenCoordinates(
        Apikey,
        PointLatLng(firstlatlong.latitude, firstlatlong.longitude),
        PointLatLng(secondlatlong.latitude, secondlatlong.longitude),
        travelMode: TravelMode.walking,
      );
      List<LatLng> _listpoint = [];
      print("This is in polypoint list start*********************************** length is ${_result.points.length}");
      for (var element in _result.points) {
        _listpoint.add(LatLng(element.latitude, element.longitude));
        print("This is in polypoint list ${element.latitude} ${element.longitude}------------------------------------------");
      }
      polypointStream.assignAll(_listpoint.map((e) => e).toList());
      return _listpoint;
    }catch(err){
      rethrow;
    }
  }


  Future<Uint8List> getmarkerIcon(String imagekey) async {

    Uint8List resizeImage(Uint8List data, width, height) {
      Uint8List? resizedData = data;
      IMG.Image? img = IMG.decodeImage(data);
      IMG.Image resized = IMG.copyResize(img!, width: width, height: height);
      resizedData = Uint8List.fromList(IMG.encodePng(resized));
      return resizedData;
    }

    final ByteData bytes = await rootBundle.load(imagekey);
    final Uint8List list = bytes.buffer.asUint8List();

    Uint8List _marker = resizeImage(list, 65, 75);

    return _marker;
  }


  void getLocationStream(LatLng randomlatlng)async{
    // await hubConnection.start();
    if (defaultTargetPlatform == TargetPlatform.android) {
      _locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.bestForNavigation,
          distanceFilter: 0,
          intervalDuration: const Duration(seconds: 15),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS) {
      _locationSettings = AppleSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        activityType: ActivityType.fitness,
        distanceFilter: 0,
        pauseLocationUpdatesAutomatically: true,
        // Only set to true if our app will be started up in the background.
        showBackgroundLocationIndicator: true,
      );
    } else {
      _locationSettings = LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 0,
      );
    }

    locationstream = Geolocator.getPositionStream(locationSettings: _locationSettings).listen((event) async{
      print("location stream");
      print(event);
      streamPosition.clear();
      streamPosition.add(event);

      await getplacemark(event.latitude, event.longitude);
      print("This is inside location stream-.................................");
      await getpolyPointList(LatLng(event.latitude, event.longitude), randomlatlng);
      // print("This is in controller");
    });
  }

  void stopLocationStream()async{
    if(locationstream != null){
      await locationstream!.cancel();
    }
  }
}