
import "package:delivery/controllers/useraccount_controller.dart";
import "package:delivery/widgets/loading_widget.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:intl/intl.dart";
import "package:sizer/sizer.dart";

import "../models/punishment_model.dart";
import "../widgets/no_item_widget.dart";
import "../widgets/punishment_widget.dart";


class PunishmentScreen extends StatefulWidget {

  const PunishmentScreen({Key? key}) : super(key: key);

  @override
  State<PunishmentScreen> createState() => _PunishmentScreenState();
}

class _PunishmentScreenState extends State<PunishmentScreen> {

  final UserAccountController userAccountController = Get.find<UserAccountController>();

  bool isloading = true;
  List<PunishmentModel> punishmentList = [];


  @override
  void initState() {
    super.initState();
    userAccountController.getPunishment().then((value){
      punishmentList = value;
      setState(() {
        isloading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Punishments"),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: (){
            Get.offAllNamed("/home");
          },
        ),
      ),
      body: isloading
          ?
        LoadingWidget()
          :
        ListView(
        padding: EdgeInsets.symmetric(
          vertical: 1.5.h,
          horizontal: 3.h,
        ),
        children: [
          if(punishmentList.isEmpty)NoItemListWidget(
            txt: "There is no punishment for this biker.",
          ),
          if(punishmentList.isNotEmpty)for(PunishmentModel item in punishmentList)PunishmentWidget(
              date: DateFormat('y-MM-d').format(item.date!),
              itemname: item.itemNameMm!,
              shopname: item.shopName!,
              quantity: item.damageQty!.toInt(),
              punishmentAmount: item.punishAmount!.toDouble(),
              isSatisfied: item.statementId == null ? false : true,
              supportname: item.supportName,
              supportremark: item.supportRemark,
          ),
        ],
      ),
    );
  }
}