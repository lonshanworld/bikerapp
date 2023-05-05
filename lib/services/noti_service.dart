import '../db/db_service.dart';
import '../models/noti_model.dart';

class NotiService{

  Future<List<Map<String,dynamic>>> getAllNotis()async{
    print('This is from getall noti service.........................');
    List<Map<String,dynamic>> values = await DBservices.allQuery();
    print(values);
    // notiList.assignAll(_values.map((e) {
    //   NotiModel _notimodel = new NotiModel();
    //   _notimodel.title = e["notiTitle"];
    //   _notimodel.body = e["notiBody"];
    //   _notimodel.date = e["Date"];
    //   _notimodel.type = e["NotiType"];
    //   _notimodel.showFlag = e["showFlag"];
    //   var data = json.decode(e["notiData"]);
    //   _notimodel.notiBodyModel = NotiBodyModel(
    //     orderTitle: data["orderTitle"],
    //     orderId: data["orderId"],
    //     refNo: data["refNo"],
    //     earning: data["earning"],
    //     shopName: data["shopName"],
    //     lat: data["lat"],
    //     long: data["long"],
    //     photo: data["photo"],
    //     distanceMeter: data["distanceMeter"],
    //     type: data["type"],
    //   );
    //   print(_notimodel.showFlag);
    //   return _notimodel;
    // }).toList());

    return values;
  }


  Future<List<Map<String,dynamic>>> getAllNotisByAlert()async{
    List<Map<String,dynamic>> values = await DBservices.queryFilterbyType("orderalert");
    // print('This is from noti controller.........................withalert');
    // notiListByAlert.assignAll(_values.map((e) {
    //   NotiModel _notimodel = new NotiModel();
    //   _notimodel.title = e["notiTitle"];
    //   _notimodel.body = e["notiBody"];
    //   _notimodel.date = e["Date"];
    //   _notimodel.type = e["NotiType"];
    //   _notimodel.showFlag = e["showFlag"];
    //   var data = json.decode(e["notiData"]);
    //   _notimodel.notiBodyModel = NotiBodyModel(
    //     orderTitle: data["orderTitle"],
    //     orderId: data["orderId"],
    //     refNo: data["refNo"],
    //     earning: data["earning"],
    //     shopName: data["shopName"],
    //     lat: data["lat"],
    //     long: data["long"],
    //     photo: data["photo"],
    //     distanceMeter: data["distanceMeter"],
    //     type: data["type"],
    //   );
    //   // print(_notimodel.title);
    //   return _notimodel;
    // }).toList());

    return values;
  }

  Future<List<Map<String,dynamic>>> getAllNotisByshowFlag()async{
    List<Map<String,dynamic>> values = await DBservices.queryFilterbyshowFlag();
    // print('This is from noti controller.........................withshowFlag');
    // notiListByshowFlag.assignAll(_values.map((e) {
    //   NotiModel _notimodel = new NotiModel();
    //   _notimodel.title = e["notiTitle"];
    //   _notimodel.body = e["notiBody"];
    //   _notimodel.date = e["Date"];
    //   _notimodel.type = e["NotiType"];
    //   _notimodel.showFlag = e["showFlag"];
    //   var data = json.decode(e["notiData"]);
    //   _notimodel.notiBodyModel = NotiBodyModel(
    //     orderTitle: data["orderTitle"],
    //     orderId: data["orderId"],
    //     refNo: data["refNo"],
    //     earning: data["earning"],
    //     shopName: data["shopName"],
    //     lat: data["lat"],
    //     long: data["long"],
    //     photo: data["photo"],
    //     distanceMeter: data["distanceMeter"],
    //     type: data["type"],
    //   );
    //   // print(_notimodel.title);
    //   return _notimodel;
    // }).toList());

    return values;
  }

  Future<void> updateshowFlag(String orderId)async{
    await DBservices.updateshowFlag(orderId);
    // getAllNotis();
    // getAllNotisByAlert();
    // getAllNotisByshowFlag();
  }

  Future<void> addNotiData({required NotiOrderModel notimodel})async{
    // List<String> orderIdList = [];
    //
    // notiList.forEach((element) {
    //   orderIdList.add(element.notiBodyModel!.orderId);
    // });
    //
    // if(!orderIdList.contains(notimodel.notiBodyModel!.orderId)){
    //   await DBservices.insertdata(notimodel);
    //   getAllNotis();
    //   getAllNotisByAlert();
    //   getAllNotisByshowFlag();
    // }else{
    //   return;
    // }
    await DBservices.insertNotiOrderdata(notimodel);
    // getAllNotis();
    // getAllNotisByAlert();
    // getAllNotisByshowFlag();
  }

  Future<void>insertRandomNoti(RandomNotiModel randomNotiModel)async{
    await DBservices.insertRandomNoti(randomNotiModel);
  }

  Future<void>deleteAll()async{
    await DBservices.deleteAllNoti();
  }
}