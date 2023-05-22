
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/uiconstants.dart';
import 'available_schedule.dart';
import 'next_schedule.dart';

class ScheduleTabbar extends StatefulWidget {
  const ScheduleTabbar({Key? key}) : super(key: key);

  @override
  _ScheduleTabbarState createState() => _ScheduleTabbarState();
}

class _ScheduleTabbarState extends State<ScheduleTabbar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  int activetapindex = 0;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabIndex);
    super.initState();
  }

  void _handleTabIndex() {
    setState(() {
      activetapindex = _tabController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 24,
            ),
            onPressed: () {
              // Get.offAllNamed("/home");
              Get.back();
            },
          ),
          title: Text(
            "schedule".tr,
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(40),
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                // border: Border(
                //   bottom: BorderSide(
                //     width: 1,
                //     color: Colors.grey
                //   ),
                // ),
              ),
              child: TabBar(
                indicatorColor: Colors.deepOrange[400],
                indicatorWeight: 4.0,
                controller: _tabController,
                labelColor: UIConstant.orange,
                // labelPadding: EdgeInsets.only(top: 10.0),
                unselectedLabelColor: Theme.of(context).primaryColor,
                tabs: [
                  Tab(
                    text: "${"next".tr} ${"schedule".tr}",
                  ),
                  //child: Image.asset('images/android.png'),

                  Tab(
                    text: "${"available".tr} ${"schedule".tr}",
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            NextSchedule(),
            AvailableSchedule(),
          ],
        ),
      ),
    );
  }
}
