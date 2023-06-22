import "package:delivery/controllers/cameraImage_controller.dart";
import "package:delivery/controllers/chatsignal_controller.dart";
import "package:delivery/controllers/file_controller.dart";
import "package:delivery/models/chat_message_model.dart";
import "package:delivery/widgets/message_widget.dart";
import "package:file_picker/file_picker.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "../constants/uiconstants.dart";
import "dart:io";

import "../widgets/loading_widget.dart";

class ChatScreen extends StatefulWidget {

  final String orderId;
  const ChatScreen({
    super.key,
    required this.orderId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final CameraImageControlller cameraImageControlller = Get.put(CameraImageControlller());
  final FileController fileController = Get.put(FileController());
  final ChatSignalControlller chatSignalControlller = Get.find<ChatSignalControlller>();

  final TextEditingController textEditingController = TextEditingController();

  File? newImage;
  // File? newVideo;
  // PlatformFile? newFile;
  String? conversationId;
  bool isloading = true;

  clearFiles(){
    // newFile = null;
    newImage = null;
    // newVideo = null;
  }


  getImage(){
    cameraImageControlller.getGalleryImage().then((value){
      if(value != null){
        if(mounted){
          clearFiles();
          if(mounted){
            setState(() {
              newImage = value;
            });
          }
        }
      }
    });
  }

  // getVideo(){
  //   cameraImageControlller.getGalleryVideo().then((value){
  //     if(value != null){
  //
  //       if(mounted){
  //         clearFiles();
  //
  //         setState(() {
  //           newVideo = value;
  //           print("This is video path =---------------------------------------------");
  //
  //         });
  //       }
  //     }
  //   });
  // }
  //
  // getFile(){
  //   fileController.getFile().then((value){
  //     if(value != null){
  //       if(mounted){
  //         clearFiles();
  //         setState(() {
  //           newFile = value;
  //         });
  //       }
  //     }
  //   });
  //
  // }

  Widget cusIconBtn(IconData icondata, VoidCallback func){
    return IconButton(
      onPressed: func,
      icon: Icon(
        icondata,
        color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade300 : Colors.grey.shade600,
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    chatSignalControlller.startconversation(orderId: widget.orderId, initialMessage: "").then((value) async {
      chatSignalControlller.orderId.value = widget.orderId;
      chatSignalControlller.conversationId.value = value;
      await chatSignalControlller.getchatList(conversationId: value, pagenum: 0);
      if(mounted){
        setState(() {
          conversationId =value;
          isloading = false;
        });
      }
    });
  }


  @override
  void dispose() {
    chatSignalControlller.chatlist.clear();
    chatSignalControlller.orderId.value = "";
    chatSignalControlller.conversationId.value = "";
    textEditingController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async => false,
      child: Scaffold(
        appBar: AppBar(
          shape: Border(
              bottom: BorderSide(
                color: Theme.of(context).brightness == Brightness.dark ? UIConstant.pink : UIConstant.orange,
                width: 2,
              )
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
          toolbarHeight: 50,
          elevation: 0,
          backgroundColor:  Theme.of(context).scaffoldBackgroundColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Customer Name : ",
                style: UIConstant.normal,
              ),
              Text(
                "Kyaw Kyaw",
                style: UIConstant.minititle.copyWith(
                  color: UIConstant.orange,
                ),
              ),
            ],
          ),
        ),
        body: isloading
            ?
        const LoadingWidget()
            :
        Stack(
          children: [
            Positioned(
              top: 0,
              bottom: 70,
              left: 0,
              right: 0,
              child: Obx((){
                return ListView(
                  padding: EdgeInsets.symmetric(
                      horizontal: 10
                  ),
                  reverse: true,
                  children: List.generate(chatSignalControlller.chatlist.length, (index){
                    ChatMessageModel item = chatSignalControlller.chatlist[index];
                    // print("this is list message");
                    // print(item.chatAttachment);
                    return MessageWidget(
                        isBiker: item.isBiker!,
                        txt: item.message,
                        imageUrl: item.chatAttachment,
                    );
                  }),
                );
              }),
            ),
            // Positioned(
            //   top: 0,
            //   bottom: 70,
            //   left: 0,
            //   right: 0,
            //   child: ListView(
            //     padding: EdgeInsets.symmetric(
            //         horizontal: 10
            //     ),
            //     reverse: true,
            //     children: [
            //       MessageWidget(
            //         isBiker: false,
            //         txt: null,
            //         imageUrl: "https://www.shutterstock.com/image-vector/free-sample-outline-glyph-icon-600w-1798019332.jpg",
            //       ),
            //       MessageWidget(
            //         isBiker: true,
            //         txt: null,
            //         imageUrl: "https://www.shutterstock.com/image-vector/free-sample-outline-glyph-icon-600w-1798019332.jpg",
            //       ),
            //     ],
            //   ),
            // ),
            // if(newFile != null || newImage != null || newVideo != null)Positioned(
            //   bottom: 70,
            //   left: 0,
            //   right: 0,
            //   child: Stack(
            //     children: [
            //       Align(
            //         alignment: Alignment.centerRight,
            //         child: Container(
            //           constraints: BoxConstraints(
            //             maxWidth: 300,
            //             minHeight: 10,
            //             minWidth: 10,
            //             maxHeight: 300,
            //           ),
            //           decoration: BoxDecoration(
            //             color: Colors.white,
            //             borderRadius: BorderRadius.only(
            //               topLeft: Radius.circular(10),
            //             ),
            //             border: Border.all(
            //               color: Colors.green,
            //               width: 2,
            //             ),
            //           ),
            //           child: Stack(
            //             children: [
            //               // if(newImage != null)Positioned(
            //               //   top: 0,
            //               //   left: 0,
            //               //   right: 0,
            //               //   bottom: 0,
            //               //   child: Container(
            //               //     decoration: BoxDecoration(
            //               //       image: DecorationImage(
            //               //         image: FileImage(
            //               //           newImage!,
            //               //         ),
            //               //         fit: BoxFit.contain,
            //               //       ),
            //               //     ),
            //               //   ),
            //               // ),
            //               if(newImage != null)Padding(
            //                 padding : EdgeInsets.all(10),
            //                 child: Image.file(
            //                   newImage!,
            //                   fit: BoxFit.contain,
            //                 ),
            //               ),
            //               if(newVideo != null)Padding(
            //                 padding : EdgeInsets.all(10),
            //                 child: Text(
            //                   newVideo!.path,
            //                 ),
            //               ),
            //               if(newFile != null)Padding(
            //                 padding : EdgeInsets.all(10),
            //                 child: Text(
            //                   newFile!.name,
            //                 ),
            //               ),
            //               Positioned(
            //                 top: 0,
            //                 left: 0,
            //                 child: FloatingActionButton.small(
            //                   onPressed: () {
            //                     setState(() {
            //                       clearFiles();
            //                     });
            //                   },
            //                   backgroundColor: UIConstant.pink,
            //                   foregroundColor: UIConstant.orange,
            //                   child: Icon(
            //                     Icons.cancel,
            //                     size: 26,
            //                   ),
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //       // if(newFile != null)Positioned(
            //       //   top: 0,
            //       //   right: 0,
            //       //   left: 0,
            //       //   bottom: 60,
            //       //   child: Container(
            //       //     decoration: BoxDecoration(
            //       //       color: Colors.white,
            //       //       borderRadius: BorderRadius.only(
            //       //         topLeft: Radius.circular(20),
            //       //       ),
            //       //       border: Border.all(
            //       //         color: Colors.red,
            //       //         width: 2,
            //       //       ),
            //       //     ),
            //       //     child: Center(
            //       //       child: Text(
            //       //         newFile!.path,
            //       //       ),
            //       //     ),
            //       //   ),
            //       // ),
            //       // Positioned(
            //       //   top: 0,
            //       //   right: 200,
            //       //   left: 0,
            //       //   bottom: 190,
            //       //   child: IconButton(
            //       //     onPressed: () {
            //       //       setState(() {
            //       //         newImage = null;
            //       //         newFile = null;
            //       //       });
            //       //     },
            //       //     icon: Icon(
            //       //       Icons.cancel,
            //       //       color: Colors.black,
            //       //       size: 30,
            //       //     ),
            //       //   ),
            //       // ),
            //     ],
            //   ),
            // ),
            if(newImage != null)Positioned(
              bottom: 70,
              left: 0,
              right: 0,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: 300,
                        minHeight: 10,
                        minWidth: 10,
                        maxHeight: 300,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                        ),
                        border: Border.all(
                          color: Colors.green,
                          width: 2,
                        ),
                      ),
                      child: Stack(
                        children: [
                          // if(newImage != null)Positioned(
                          //   top: 0,
                          //   left: 0,
                          //   right: 0,
                          //   bottom: 0,
                          //   child: Container(
                          //     decoration: BoxDecoration(
                          //       image: DecorationImage(
                          //         image: FileImage(
                          //           newImage!,
                          //         ),
                          //         fit: BoxFit.contain,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          if(newImage != null)Padding(
                            padding : EdgeInsets.all(10),
                            child: Image.file(
                              newImage!,
                              fit: BoxFit.contain,
                            ),
                          ),
                          // if(newVideo != null)Padding(
                          //   padding : EdgeInsets.all(10),
                          //   child: Text(
                          //     newVideo!.path,
                          //   ),
                          // ),
                          // if(newFile != null)Padding(
                          //   padding : EdgeInsets.all(10),
                          //   child: Text(
                          //     newFile!.name,
                          //   ),
                          // ),
                          Positioned(
                            top: 0,
                            left: 0,
                            child: FloatingActionButton.small(
                              onPressed: () {
                                if(mounted){
                                  setState(() {
                                    clearFiles();
                                  });
                                }
                              },
                              backgroundColor: UIConstant.pink,
                              foregroundColor: UIConstant.orange,
                              child: Icon(
                                Icons.cancel,
                                size: 26,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // if(newFile != null)Positioned(
                  //   top: 0,
                  //   right: 0,
                  //   left: 0,
                  //   bottom: 60,
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //       color: Colors.white,
                  //       borderRadius: BorderRadius.only(
                  //         topLeft: Radius.circular(20),
                  //       ),
                  //       border: Border.all(
                  //         color: Colors.red,
                  //         width: 2,
                  //       ),
                  //     ),
                  //     child: Center(
                  //       child: Text(
                  //         newFile!.path,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // Positioned(
                  //   top: 0,
                  //   right: 200,
                  //   left: 0,
                  //   bottom: 190,
                  //   child: IconButton(
                  //     onPressed: () {
                  //       setState(() {
                  //         newImage = null;
                  //         newFile = null;
                  //       });
                  //     },
                  //     icon: Icon(
                  //       Icons.cancel,
                  //       color: Colors.black,
                  //       size: 30,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
        bottomSheet: Container(
          height: 70,
          decoration: BoxDecoration(
            color:  Theme.of(context).brightness == Brightness.dark ? UIConstant.bgDark : UIConstant.bgWhite,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade900 : Colors.grey.shade300,
                blurRadius: 4.0,
                spreadRadius: 1.0,
                offset: Offset(0, -3),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 5,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // cusIconBtn(
                //   Icons.upload_file_sharp,
                //   () {
                //     getFile();
                //   },
                // ),
                // cusIconBtn(
                //   Icons.video_collection,
                //   () {
                //     getVideo();
                //   },
                // ),
                cusIconBtn(
                  Icons.image,
                  () {
                    getImage();
                  },
                ),
                // if(newFile == null && newImage == null && newVideo == null)Expanded(
                //   child:  TextField(
                //     style: TextStyle(
                //       fontSize: 14,
                //     ),
                //     controller: textEditingController,
                //     keyboardType: TextInputType.text,
                //     decoration: InputDecoration(
                //       isDense: true,
                //       focusedBorder: OutlineInputBorder(
                //         borderSide: BorderSide(color: UIConstant.orange, width:2),
                //         borderRadius: BorderRadius.circular(30),
                //       ),
                //       enabledBorder: OutlineInputBorder(
                //         borderSide: BorderSide(color: Colors.grey, width: 2),
                //         borderRadius: BorderRadius.circular(30),
                //       ),
                //       contentPadding: EdgeInsets.symmetric(
                //         vertical: 8,
                //         horizontal: 10,
                //       ),
                //       border: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(30),
                //       ),
                //       hintText: "Type ....",
                //       hintStyle: TextStyle(color: Colors.grey),
                //     ),
                //     // cursorColor: appStore.isDarkModeOn ? white : blackColor,
                //   ),
                // ),
                if(newImage == null)Expanded(
                  child:  TextField(
                    style: TextStyle(
                      fontSize: 14,
                    ),
                    controller: textEditingController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      isDense: true,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: UIConstant.orange, width:2),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 2),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      hintText: "Type ....",
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    // cursorColor: appStore.isDarkModeOn ? white : blackColor,
                  ),
                ),
                cusIconBtn(
                  Icons.send,
                  ()async{
                    if(isloading == false && textEditingController.text.isNotEmpty){
                      print(conversationId);
                      await chatSignalControlller.sendMessage(conversationId: conversationId!, txt: textEditingController.text, file: null).then((value){
                        print("value after sending message");
                        print(value);
                        // await
                      });
                    }else{
                      print("Can not send message");
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
