import "dart:isolate";
import "dart:ui";


import "package:delivery/constants/uiconstants.dart";
import "package:delivery/models/chat_message_model.dart";
import "package:flutter/material.dart";
import "package:flutter_downloader/flutter_downloader.dart";
import "package:intl/intl.dart";

import "package:path_provider/path_provider.dart";
import "package:percent_indicator/circular_percent_indicator.dart";

class MessageWidget extends StatefulWidget {

  final ChatMessageModel item;
  // final String? videoUrl;
  const MessageWidget({
    super.key,
    required this.item,
    // required this.videoUrl,
  });

  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {

  // int percentage = 0;
  // bool showdownloadIndicator = false;
  bool showComplete = false;
  bool showdate = false;
  bool showimage = true;
  ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();

    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = DownloadTaskStatus(data[1]);
      int progress = data[2];
      setState((){
        print("This is in download init");
        print(id);
        print(status);
        print(progress);
      });
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, int status, int progress) {
    final SendPort send = IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }

  downloadfileFunc(String fileurl)async{
    print("Inside downloadfile func");
    final directory = await getApplicationDocumentsDirectory();
    final taskId = await FlutterDownloader.enqueue(
      url: fileurl,
      savedDir: directory.path,
      showNotification: true, // show download progress in status bar (for Android)
      openFileFromNotification: true, // click on notification to open downloaded file (for Android)
      allowCellular: true,
      timeout: 30000,
      saveInPublicStorage: true,
    );
    setState(() {
      print(taskId);
      showComplete = true;
    });
    await FlutterDownloader.registerCallback(downloadCallback); // callback is a top-level or static function
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> generalwidgetfordownload = [
     // CircularPercentIndicator(
     //    radius: 20,
     //    lineWidth: 5,
     //    percent: percentage/100,
     //    progressColor: UIConstant.orange,
     //    backgroundColor: Colors.grey.withOpacity(0.5),
     //    center: Text(
     //      "$percentage%",
     //      style: UIConstant.tinytext.copyWith(
     //        fontWeight: FontWeight.bold,
     //      ),
     //    ),
     //  ),
      Icon(
        Icons.check_circle_outline,
        size: 24,
        color: Colors.green,
      ),
    ];

    Widget widgetsforimage(){
      return Column(
        children: [
          PopupMenuButton(
            tooltip: "Information",
            icon: Icon(
              Icons.info_outline,
              size: 24,
              color: Theme.of(context).primaryColor,
            ),
            elevation: 5,
            surfaceTintColor: Theme.of(context).appBarTheme.backgroundColor,
            itemBuilder: (BuildContext context){
              return [
                PopupMenuItem(
                  child: Text(
                    widget.item.chatAttachment!,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 13,
                    ),
                  ),
                  enabled: false,
                ),
              ];
            },
          ),
          // if(showComplete == false && showdownloadIndicator == false)IconButton(
          //   tooltip: "Download",
          //   onPressed: (){
          //     downloadfileFunc(widget.imageUrl!);
          //   },
          //   icon: Icon(
          //     Icons.download_for_offline_outlined,
          //     size: 24,
          //     color: Theme.of(context).primaryColor,
          //   ),
          // ),
          if(showComplete == false)IconButton(
            tooltip: "Download",
            onPressed: (){
              downloadfileFunc(widget.item.chatAttachment!);
            },
            icon: Icon(
              Icons.download_for_offline_outlined,
              size: 24,
              color: Theme.of(context).primaryColor,
            ),
          ),
          // if(showdownloadIndicator)generalwidgetfordownload[0],
          if(showComplete)generalwidgetfordownload[0],
        ],
      );
    }

    // List<Widget> widgetsforfile = [
    //   IconButton(
    //     tooltip: "Download",
    //     onPressed: (){
    //       downloadfileFunc(widget.fileUrl!);
    //     },
    //     icon: Icon(
    //       Icons.download_for_offline_outlined,
    //       size: 24,
    //       color: Theme.of(context).primaryColor,
    //     ),
    //   ),
    //   generalwidgetfordownload[0],
    //   generalwidgetfordownload[1],
    // ];

    // List<Widget> widgetsforvideo = [
    //   IconButton(
    //     tooltip: "Download",
    //     onPressed: (){
    //       downloadfileFunc(widget.videoUrl!);
    //     },
    //     icon: Icon(
    //       Icons.download_for_offline_outlined,
    //       size: 24,
    //       color: Theme.of(context).primaryColor,
    //     ),
    //   ),
    //   generalwidgetfordownload[0],
    //   generalwidgetfordownload[1],
    // ];

    return InkWell(
      onTap: (){
        setState(() {
          showdate = !showdate;
        });
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: Column(
          children: [
            if(widget.item.message != null && widget.item.message != "")Row(
              mainAxisAlignment: widget.item.isBiker! ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                if(!widget.item.isBiker!)Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(
                        "assets/images/profile.png",
                      ),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                if(widget.item.message != null)Container(
                  constraints: BoxConstraints(
                    maxWidth: 280,
                    minWidth: 10,
                  ),
                  decoration: BoxDecoration(
                      color: widget.item.isBiker! ?  Theme.of(context).brightness == Brightness.dark ? UIConstant.orange.withOpacity(0.5) : UIConstant.pink.withOpacity(0.5) : Colors.grey.withOpacity(0.5),
                      borderRadius: BorderRadius.only(
                        topRight:  Radius.circular(widget.item.isBiker! ? 3 : 20),
                        topLeft: Radius.circular(widget.item.isBiker! ? 20 : 3),
                        bottomLeft:  Radius.circular(widget.item.isBiker! ? 20 : 3),
                        bottomRight:  Radius.circular(widget.item.isBiker! ? 3 : 20),
                      )
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 15,
                  ),
                  child: Text(
                    widget.item.message!,
                  ),
                ),
              ],
            ),
            if(widget.item.chatAttachment != null && widget.item.chatAttachment != "")Row(
              mainAxisAlignment: widget.item.isBiker! ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                if(!showimage)if(!widget.item.isBiker!)Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(
                        "assets/images/profile.png",
                      ),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                if(!showimage)Row(
                  children: [
                    if(widget.item.isBiker!)widgetsforimage(),
                    Container(
                      constraints: BoxConstraints(
                        maxHeight: 200,
                        maxWidth: 200,
                        minHeight: 10,
                        minWidth: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).appBarTheme.backgroundColor,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).brightness == Brightness.light ? Colors.grey.shade300 : Colors.grey.shade900,
                            blurRadius: 5.0,
                            spreadRadius: 2.0,
                            offset: Offset(1.0, 1.0),
                          ),
                        ],
                      ),
                      child:ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: Image.network(
                          widget.item.chatAttachment!,
                          errorBuilder: (ctx, object, stacktrace){
                            if(mounted){
                              setState(() {
                                showimage = false;
                              });
                            }
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Cannot display image",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    if(!widget.item.isBiker!)widgetsforimage(),
                  ],
                ),
                // if(widget.fileUrl != null)Row(
                //   children: [
                //     // if(widget.isBiker)IconButton(
                //     //   tooltip: "Download",
                //     //   onPressed: (){
                //     //     downloadfileFunc(widget.fileUrl!);
                //     //   },
                //     //   icon: Icon(
                //     //     Icons.download_for_offline_outlined,
                //     //     size: 24,
                //     //     color: Theme.of(context).primaryColor,
                //     //   ),
                //     // ),
                //     if(widget.isBiker && showComplete == false && showdownloadIndicator == false)widgetsforfile[0],
                //     if(widget.isBiker && showdownloadIndicator == true)widgetsforfile[1],
                //     if(widget.isBiker && showComplete == true)widgetsforfile[2],
                //     Container(
                //       constraints: BoxConstraints(
                //         maxWidth: 230,
                //         minWidth: 10,
                //         maxHeight: 70,
                //       ),
                //       decoration: BoxDecoration(
                //           color: widget.isBiker ? Colors.greenAccent.withOpacity(0.5) : Colors.blueAccent.withOpacity(0.5),
                //           borderRadius: BorderRadius.all(
                //             Radius.circular(5),
                //           )
                //       ),
                //       padding: EdgeInsets.symmetric(
                //         vertical: 8,
                //         horizontal: 15,
                //       ),
                //       child: Row(
                //         children: [
                //           Icon(
                //             Icons.file_copy,
                //             size: 45,
                //             color: widget.isBiker ? Colors.greenAccent.shade700 : Colors.blueAccent.shade700,
                //           ),
                //           Expanded(
                //             child: Text(
                //               widget.fileUrl!,
                //               style: TextStyle(
                //                 fontSize: 13,
                //                 decoration: TextDecoration.underline,
                //                 fontWeight: FontWeight.bold,
                //                 overflow: TextOverflow.fade
                //               ),
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //     // if(!widget.isBiker)IconButton(
                //     //   tooltip: "Download",
                //     //   onPressed: (){
                //     //     downloadfileFunc(widget.fileUrl!);
                //     //   },
                //     //   icon: Icon(
                //     //     Icons.download_for_offline_outlined,
                //     //     size: 24,
                //     //     color: Theme.of(context).primaryColor,
                //     //   ),
                //     // ),
                //     if(!widget.isBiker && showdownloadIndicator == false && showComplete ==false)widgetsforfile[0],
                //     if(!widget.isBiker && showdownloadIndicator == true)widgetsforfile[1],
                //     if(!widget.isBiker && showComplete == true)widgetsforfile[2],
                //   ],
                // ),
                // if(widget.videoUrl != null)Row(
                //   children: [
                //     if(widget.isBiker && showdownloadIndicator == false && showComplete == false)widgetsforvideo[0],
                //     if(widget.isBiker && showdownloadIndicator == true)widgetsforvideo[1],
                //     if(widget.isBiker && showComplete == true)widgetsforvideo[2],
                //     Container(
                //       constraints: BoxConstraints(
                //         maxWidth: 230,
                //         minWidth: 10,
                //         maxHeight: 70,
                //       ),
                //       decoration: BoxDecoration(
                //           color: widget.isBiker ? Colors.greenAccent.withOpacity(0.5) : Colors.blueAccent.withOpacity(0.5),
                //           borderRadius: BorderRadius.all(
                //             Radius.circular(5),
                //           )
                //       ),
                //       padding: EdgeInsets.symmetric(
                //         vertical: 8,
                //         horizontal: 15,
                //       ),
                //       child: Row(
                //         children: [
                //           Icon(
                //             Icons.video_collection,
                //             size: 45,
                //             color: widget.isBiker ? Colors.greenAccent.shade700 : Colors.blueAccent.shade700,
                //           ),
                //           Expanded(
                //             child: Text(
                //               widget.videoUrl!,
                //               style: TextStyle(
                //                 fontSize: 13,
                //                 decoration: TextDecoration.underline,
                //                 fontWeight: FontWeight.bold,
                //                 overflow: TextOverflow.fade,
                //               ),
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //     if(!widget.isBiker && showdownloadIndicator == false && showComplete == false)widgetsforvideo[0],
                //     if(!widget.isBiker && showdownloadIndicator == true)widgetsforvideo[1],
                //     if(!widget.isBiker && showComplete == true)widgetsforvideo[2],
                //   ],
                // )
              ],
            ),
            if(showdate)Row(
              mainAxisAlignment: widget.item.isBiker! ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: widget.item.isBiker! ? 0 : 35,
                    right: widget.item.isBiker! ? 5 : 0,
                  ),
                  child: Text(
                    DateFormat("MMM-dd-yyyy  H:mm:ss a").format(DateTime.parse(widget.item.sentOn!)),
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
