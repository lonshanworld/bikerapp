import "dart:convert";

import "package:delivery/constants/txtconstants.dart";
import "package:delivery/error_handlers/error_handlers.dart";
import "package:delivery/widgets/loading_widget.dart";
import "package:flutter/material.dart";
import "package:flutter_widget_from_html/flutter_widget_from_html.dart";
import "package:get/get.dart";
import "package:http/http.dart" as http;

class RuleScreen extends StatefulWidget {
  const RuleScreen({Key? key}) : super(key: key);

  @override
  State<RuleScreen> createState() => _RuleScreenState();
}

class _RuleScreenState extends State<RuleScreen> {

  final ErrorHandler errorHandler = ErrorHandler();

  String uri = "${TxtConstant.mainUrl}ruleandregulation?type=application";
  String data = "";


  @override
  void initState() {
    super.initState();
    http.get(Uri.parse(uri),).then((response){
      print("In rules screem");
      setState(() {
        data = json.decode(response.body)["data"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rule and Regulation"),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 28,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: (data == "")
          ?
      const LoadingWidget()
          :
      Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: HtmlWidget(
            data,
          ),
        ),
      )
    );
  }
}
