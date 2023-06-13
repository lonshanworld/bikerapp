import "package:delivery/controllers/cameraImage_controller.dart";
import "package:delivery/controllers/file_controller.dart";
import "package:delivery/widgets/message_widget.dart";
import "package:file_picker/file_picker.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "../constants/uiconstants.dart";
import "dart:io";

class ChatScreen extends StatefulWidget {

  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final CameraImageControlller cameraImageControlller = Get.put(CameraImageControlller());
  final FileController fileController = Get.put(FileController());

  final TextEditingController textEditingController = TextEditingController();

  File? newImage;
  File? newVideo;
  PlatformFile? newFile;

  clearFiles(){
    newFile = null;
    newImage = null;
    newVideo = null;
  }


  getImage(){
    cameraImageControlller.getGalleryImage().then((value){
      if(value != null){
        if(mounted){
          clearFiles();
          setState(() {
            newImage = value;
          });
        }
      }
    });
  }

  getVideo(){
    cameraImageControlller.getGalleryVideo().then((value){
      if(value != null){

        if(mounted){
          clearFiles();

          setState(() {
            newVideo = value;
            print("This is video path =---------------------------------------------");

          });
        }
      }
    });
  }

  getFile(){
    fileController.getFile().then((value){
      if(value != null){
        if(mounted){
          clearFiles();
          setState(() {
            newFile = value;
          });
        }
      }
    });

  }

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
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Stack(
        children: [
          Positioned(
            top: 0,
            bottom: 70,
            left: 0,
            right: 0,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  verticalDirection: VerticalDirection.up,
                  children: [
                    MessageWidget(
                      isBiker: false,
                      txt: "from customer",
                      fileUrl: null,
                      imageUrl: null,
                      videoUrl: null,
                    ),
                    MessageWidget(
                      isBiker: true,
                      txt: "This is message from biker",
                      fileUrl: null,
                      imageUrl: null,
                      videoUrl: null,
                    ),
                    MessageWidget(
                      imageUrl: "https://plus.unsplash.com/premium_photo-1680740103993-21639956f3f0?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=388&q=80",
                      isBiker: true,
                      txt: null,
                      fileUrl: null,
                      videoUrl: null,
                    ),
                    MessageWidget(
                      fileUrl: "https://plus.unsplash.com/premium_photo-1680740103993-21639956f3f0?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=388&q=80",
                      isBiker: true,
                      txt: null,
                      imageUrl: null,
                      videoUrl: null,
                    ),
                    MessageWidget(
                      isBiker: false,
                      txt: "This is very longgggggggggggggggggggggggg message and testing from customer",
                      fileUrl: null,
                      imageUrl: null,
                      videoUrl: null,
                    ),
                    MessageWidget(
                      imageUrl: "https://www.shutterstock.com/image-vector/crowd-behaviors-measuring-social-sampling-600w-689023369.jpg",
                      isBiker: false,
                      txt: null,
                      fileUrl: null,
                      videoUrl: null,
                    ),
                    MessageWidget(
                      fileUrl: "https://www.shutterstock.com/image-vector/crowd-behaviors-measuring-social-sampling-600w-689023369.jpg",
                      isBiker: false,
                      txt: null,
                      imageUrl: null,
                      videoUrl: null,
                    ),
                    MessageWidget(
                      isBiker: true,
                      txt: "This is longgggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg message from biker",
                      fileUrl: null,
                      imageUrl: null,
                      videoUrl: null,
                    ),
                    MessageWidget(
                      fileUrl: null,
                      isBiker: false,
                      txt: null,
                      imageUrl: null,
                      videoUrl: "https://www.shutterstock.com/image-vector/crowd-behaviors-measuring-social-sampling-600w-689023369.jpg",
                    ),
                    MessageWidget(
                      fileUrl: null,
                      isBiker: true,
                      txt: null,
                      imageUrl: null,
                      videoUrl: "https://cdn.videvo.net/videvo_files/video/premium/2020-07/large_watermarked/200727_02_Videvo_Stock_Market_2_Growth_Color_2_preview.mp4",
                    ),
                  ],
                ),
              ),
            ),
          ),
          if(newFile != null || newImage != null || newVideo != null)Positioned(
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
                        if(newVideo != null)Padding(
                          padding : EdgeInsets.all(10),
                          child: Text(
                            newVideo!.path,
                          ),
                        ),
                        if(newFile != null)Padding(
                          padding : EdgeInsets.all(10),
                          child: Text(
                            newFile!.name,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          child: FloatingActionButton.small(
                            onPressed: () {
                              setState(() {
                                clearFiles();
                              });
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
              cusIconBtn(
                Icons.upload_file_sharp,
                () {
                  getFile();
                },
              ),
              cusIconBtn(
                Icons.video_collection,
                () {
                  getVideo();
                },
              ),
              cusIconBtn(
                Icons.image,
                () {
                  getImage();
                },
              ),
              if(newFile == null && newImage == null && newVideo == null)Expanded(
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
                () {
                  getImage();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
