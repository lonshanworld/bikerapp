import 'dart:async';
import 'dart:convert';

import 'dart:typed_data';


import 'package:delivery/constants/txtconstants.dart';
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
  StreamSubscription<Position>? locationstream;
  // HubConnection hubConnection = HubConnectionBuilder().withUrl(TxtConstant.serverUrl).withAutomaticReconnect().build();


  // static const serverUrl = "http://192.168.0.116/hub/locations";
  // HubConnection hubConnection = HubConnectionBuilder().withUrl(serverUrl).build();


  // @override
  // void onReady()async{
  //   getLocationStream();
  //   super.onReady();
  // }


  Future<bool> getPermission() async{
    bool _serviceEnabled;
    LocationPermission _permission;

    // _serviceEnabled = await location.serviceEnabled();
    // if (!_serviceEnabled) {
    //   _serviceEnabled = await location.requestService();
    //   if (!_serviceEnabled) {
    //     return false;
    //   }
    // }
    //
    // _permission = await location.hasPermission();
    // if (_permission == PermissionStatus.denied) {
    //   _permission = await location.requestPermission();
    //   if (_permission == PermissionStatus.granted || _permission == PermissionStatus.grantedLimited) {
    //     return true;
    //   }else{
    //     return false;
    //   }
    // }
    _serviceEnabled = await Geolocator.isLocationServiceEnabled();
    print("In permission controller");
    print(_serviceEnabled);

    if (!_serviceEnabled) {
      throw showDialog(context: Get.context!, builder:(ctx){
        return ErrorScreen(
          title: "Location Permission",
          txt: "Location Permission is required. Please enable GPS and allow Location Permission.",
          btntxt: 'Go to location Setting',
          Func: () async{
            await Geolocator.openLocationSettings();
          },
        );
      } );
    }
    _permission = await Geolocator.checkPermission();
    print(_permission);
    if (_permission == LocationPermission.denied || _permission == LocationPermission.deniedForever || _permission == LocationPermission.unableToDetermine) {
      _permission = await Geolocator.requestPermission();
      if (_permission == LocationPermission.denied || _permission == LocationPermission.deniedForever || _permission == LocationPermission.unableToDetermine) {
        return false;
      }
    }

    return true;
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
    List<GEO.Placemark> _list = await GEO.placemarkFromCoordinates(lat, long);
    return _list[0];
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


  Future<List<LatLng>> getpolyPointList(LatLng shoplatlang, LatLng cuslatlang) async{
    PolylinePoints _polypoints = PolylinePoints();
    try{
      PolylineResult _result = await _polypoints.getRouteBetweenCoordinates(
        Apikey,
        PointLatLng(shoplatlang.latitude, shoplatlang.longitude),
        PointLatLng(cuslatlang.latitude, cuslatlang.longitude),
        travelMode: TravelMode.transit,
      );
      List<LatLng> _listpoint = [];
      for (var element in _result.points) {
        _listpoint.add(LatLng(element.latitude, element.longitude));
      }
      return _listpoint;
    }catch(err){
      rethrow;
    }
  }


  Future<Uint8List> getmarkerIcon() async {

    Uint8List resizeImage(Uint8List data, width, height) {
      Uint8List? resizedData = data;
      IMG.Image? img = IMG.decodeImage(data);
      IMG.Image resized = IMG.copyResize(img!, width: width, height: height);
      resizedData = Uint8List.fromList(IMG.encodePng(resized));
      return resizedData;
    }

    final ByteData bytes = await rootBundle.load("assets/images/ic_launcher.png");
    final Uint8List list = bytes.buffer.asUint8List();

    Uint8List _marker = resizeImage(list, 80, 80);

    return _marker;
  }

  // forsignalr()async{
  //   await hubConnection.start();
  //   print(hubConnection.state);
  //   print("Signal R function ...");
  //   hubConnection.on("LocationRequest", (res){
  //     print(res);
  //     print(hubConnection.state);
  //     if(hubConnection.state == HubConnectionState.Connected){
  //       getPermission().then((permit) {
  //         if(permit){
  //           getcurLagLong().then((point)async{
  //             print("This working ...");
  //             await hubConnection.invoke("LocationSend", args: <Object>[
  //               {"userid": box.read("id"),"lat" : point.latitude,"lng" : point.longitude},
  //             ]).then((res){
  //               print("heytyyyy");
  //               print(res);
  //             });
  //           });
  //         }
  //       });
  //     }else{
  //       print("connection state == ${hubConnection.state}");
  //     }
  //   });
  // }


  void getLocationStream()async{
    // await hubConnection.start();
    if (defaultTargetPlatform == TargetPlatform.android) {
      _locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.bestForNavigation,
          distanceFilter: 0,
          intervalDuration: const Duration(seconds: 1),
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

    // print(hubConnection.state);
    //
    // hubConnection.on("LocationRequest", (res) {
    //   print(res);
    // });
    //
    locationstream = Geolocator.getPositionStream(locationSettings: _locationSettings).listen((event) async{
      print("location stream");
      print(event);
      streamPosition.clear();
      streamPosition.add(event);
      // print("This is in controller");
    });
  }

  void stopLocationStream()async{
    await locationstream!.cancel();
  }
}