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
  File? newFile;

  getImage(){
    newFile = null;
    newImage = null;
    cameraImageControlller.getGallery().then((value){
      if(value == null){
        return;
      }else{
        if(mounted){
          setState(() {
            newImage = value;
          });
        }
      }
    });
  }

  getFile(){
    newFile = null;
    newImage = null;
    fileController.getFile().then((value){
      if(value == null){
        return ;
      }else{
        if(mounted){
          setState(() {
            print("This is checking file--------------------------------------------");
            print(value);
            newFile = value;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Theme.of(context).brightness == Brightness.dark ? UIConstant.bgDark : UIConstant.bgWhite,
      appBar: AppBar(
        shape: Border(
            bottom: BorderSide(
              color: UIConstant.orange,
              width: 2,
            )
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        toolbarHeight: 50,
        elevation: 0,
        backgroundColor:  Theme.of(context).brightness == Brightness.dark ? UIConstant.bgDark : UIConstant.bgWhite,
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
            bottom: 0,
            left: 0,
            right: 0,
            child: ListView(
              reverse: true,
              padding: EdgeInsets.only(
                left: 10,
                right: 10,
                bottom: 80,
              ),
              children: [
                MessageWidget(isBiker: false, txt: "This is message from customer"),
                MessageWidget(isBiker: true, txt: "This is message from biker"),
                MessageWidget(isBiker: false, txt: "This is very longgggggggggggggggggggggggg message and testing from customer"),
                MessageWidget(isBiker: true, txt: "This is message from biker"),
              ],
            ),
          ),
          if(newFile != null || newImage != null)Positioned(
            top: 400,
            bottom: 0,
            left: 100,
            right: 0,
            child: Stack(
              children: [
                if(newImage != null)Positioned(
                  top: 0,
                  right: 0,
                  left: 0,
                  bottom: 60,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                      ),
                      border: Border.all(
                        color: Colors.red,
                        width: 2,
                      ),
                      image: DecorationImage(
                        image: FileImage(
                          newImage!,
                        ),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                if(newFile != null)Positioned(
                  top: 0,
                  right: 0,
                  left: 0,
                  bottom: 60,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                      ),
                      border: Border.all(
                        color: Colors.red,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        newFile!.path,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 200,
                  left: 0,
                  bottom: 190,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        newImage = null;
                        newFile = null;
                      });
                    },
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                ),
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
              color: Colors.grey.shade300,
              blurRadius: 4.0,
              spreadRadius: 1.0,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: (){
                  fileController.getFile();
                },
                icon: Icon(
                  Icons.upload_file_sharp,
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade300 : Colors.grey.shade600,
                ),
              ),
              IconButton(
                onPressed: (){
                  getImage();
                },
                icon: Icon(
                  Icons.image,
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade300 : Colors.grey.shade600,
                ),
              ),
              if(newFile == null && newImage == null)Expanded(
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
              IconButton(
                onPressed: (){},
                icon: Icon(
                  Icons.send,
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade300 : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
