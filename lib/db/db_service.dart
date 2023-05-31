import 'dart:convert';

import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/noti_model.dart';

@pragma('vm:entry-point')
class DBservices{
  static Database? _db;
  static const int _version = 1;
  static const String _tablename = "importantNoti_table";

  @pragma('vm:entry-point')
  static Future<void> initDB() async{
    var databasepath = await getDatabasesPath();
    // String path = "$databasepath$_tablename";
    String path = join(databasepath, _tablename);
    print("This is db path -----------------------------------------------------------$path");
    if(_db != null){
      // await deleteDatabase(path);
      return ;
    }

    try{
      // await deleteDatabase(path);
      _db = await openDatabase(
          path,
          version: _version,
          onCreate: (db, version){
            return db.execute(
                "CREATE TABLE $_tablename("
                    "id INTEGER PRIMARY KEY AUTOINCREMENT,"
                    "notiTitle STRING,"
                    "orderId STRING,"
                    "notiBody STRING,"
                    "notiData TEXT,"
                    "detailDate STRING,"
                    "Date STRING,"
                    "showFlag STRING,"
                    "NotiType STRING)"
            );
          }
      );
    }catch(err){
      rethrow;
    }
  }

  @pragma('vm:entry-point')
  static Future<int> insertNotiOrderdata(NotiOrderModel _notimodel)async{

    String notiTitle = _notimodel.title!;
    String notiBody = _notimodel.body!;
    String notiData = json.encode(_notimodel.notiBodyModel);
    String detailDate = _notimodel.date.toString();
    String date = DateFormat("y-MMM-d").format(DateTime.now());
    String type = _notimodel.type!;
    String showFlag = _notimodel.showFlag!;
    String orderId = _notimodel.notiBodyModel!.orderId!;

    return await _db!.rawInsert(
        'INSERT INTO $_tablename (notiTitle, orderId, notiBody, notiData ,detailDate , Date, showFlag, NotiType) VALUES(?,?,?,?,?,?,?,?)',
        [notiTitle, orderId,notiBody, notiData, detailDate ,date, showFlag, type]
    );
  }

  @pragma('vm:entry-point')
  static Future<List<Map<String,dynamic>>> allQuery()async{
    return await _db!.query(_tablename);
  }

  @pragma('vm:entry-point')
  static Future<List<Map<String,dynamic>>> queryFilterbyType(String type)async{
    String date = DateFormat("y-MMM-d").format(DateTime.now());
    return await _db!.rawQuery(
        'SELECT * FROM $_tablename WHERE Date=? and NotiType=? and showFlag=?',
        [date,type,'true']
    );
  }

  @pragma('vm:entry-point')
  static Future<List<Map<String,dynamic>>> queryFilterbyshowFlag()async{
    String date = DateFormat("y-MMM-d").format(DateTime.now());
    return await _db!.rawQuery(
        'SELECT * FROM $_tablename WHERE Date=? and showFlag=?',
        [date,'true']
    );
  }

  @pragma('vm:entry-point')
  static insertRandomNoti(RandomNotiModel randomNotiModel) async{
    return await _db!.rawInsert("INSERT INTO $_tablename(notiTitle, notiBody, detailDate) VALUES(?,?,?)",[randomNotiModel.title, randomNotiModel.body, randomNotiModel.date]);
  }

  @pragma('vm:entry-point')
  static updateshowFlag(String orderId)async{
    var data = await _db!.rawUpdate("UPDATE $_tablename SET showFlag=? WHERE orderId=?",['false',orderId]);
    return data;
  }

  @pragma('vm:entry-point')
  static deleteAllNoti()async{
    // return await _db!.execute("DELETE FROM $_tablename");
    var databasepath = await getDatabasesPath();
    String path = join(databasepath, _tablename);
    return await deleteDatabase(path);
  }
}