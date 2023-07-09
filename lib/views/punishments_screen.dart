
import "package:delivery/controllers/useraccount_controller.dart";
import "package:delivery/widgets/loading_widget.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:intl/intl.dart";

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
    print(Get.currentRoute);
    userAccountController.getPunishment().then((value){
      punishmentList = value;
      if(mounted){
        setState(() {
          isloading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("punishment".tr),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 24,
          ),
          onPressed: () {
            // Get.offAllNamed("/home");
            Get.back();
          },
        ),
      ),
      body: isloading
          ?
        LoadingWidget()
          :
        Center(
          child: SizedBox(
            width: deviceWidth > 500 ? deviceWidth * 0.8 : deviceWidth,
            child: ListView(
            padding: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 20,
            ),
            children: [
              if(punishmentList.isEmpty)NoItemListWidget(
                txt: "nopunishment".tr,
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
          ),
        ),
    );
  }
}
