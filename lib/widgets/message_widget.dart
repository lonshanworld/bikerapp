
import "package:delivery/constants/uiconstants.dart";
import "package:flutter/material.dart";
import "package:flutter_downloader/flutter_downloader.dart";
import "package:path_provider/path_provider.dart";

class MessageWidget extends StatefulWidget {

  final bool isBiker;
  final String? txt;
  final String? fileUrl;
  final String? imageUrl;
  const MessageWidget({
    super.key,
    required this.isBiker,
    required this.txt,
    required this.fileUrl,
    required this.imageUrl,
  });

  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {

  @override
  Widget build(BuildContext context) {



    downloadfileFunc({required bool isImage})async{
      final directory = await getApplicationDocumentsDirectory();
      await FlutterDownloader.enqueue(
        url: isImage ? widget.imageUrl! : widget.fileUrl!,
        headers: {}, // optional: header send with url (auth token etc)
        savedDir: directory.path,
        showNotification: true, // show download progress in status bar (for Android)
        openFileFromNotification: true,// click on notification to open downloaded file (for Android)
        saveInPublicStorage: true,
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: Row(
        mainAxisAlignment: widget.isBiker ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if(!widget.isBiker)Container(
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
          if(widget.txt != null)Container(
            constraints: BoxConstraints(
              maxWidth: 280,
              minWidth: 10,
            ),
            decoration: BoxDecoration(
                color: widget.isBiker ?  Theme.of(context).brightness == Brightness.dark ? UIConstant.orange.withOpacity(0.5) : UIConstant.pink.withOpacity(0.5) : Colors.grey.withOpacity(0.5),
                borderRadius: BorderRadius.only(
                  topRight:  Radius.circular(widget.isBiker ? 3 : 20),
                  topLeft: Radius.circular(widget.isBiker ? 20 : 3),
                  bottomLeft:  Radius.circular(widget.isBiker ? 20 : 3),
                  bottomRight:  Radius.circular(widget.isBiker ? 3 : 20),
                )
            ),
            padding: EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 15,
            ),
            child: Text(
              widget.txt!,
            ),
          ),
          if(widget.imageUrl != null)Row(
            children: [
              if(widget.isBiker)Column(
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
                            widget.imageUrl!,
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
                  IconButton(
                    tooltip: "Download",
                    onPressed: (){
                      downloadfileFunc(isImage: true);
                    },
                    icon: Icon(
                      Icons.download_for_offline_outlined,
                      size: 24,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
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
                    widget.imageUrl!,
                  ),
                ),
              ),
              if(!widget.isBiker)Column(
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
                            widget.imageUrl!,
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
                  IconButton(
                    tooltip: "Download",
                    onPressed: (){
                      downloadfileFunc(isImage: true);
                    },
                    icon: Icon(
                      Icons.download_for_offline_outlined,
                      size: 24,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if(widget.fileUrl != null)Row(
            children: [
              if(widget.isBiker)IconButton(
                tooltip: "Download",
                onPressed: (){
                  downloadfileFunc(isImage: false);
                },
                icon: Icon(
                  Icons.download_for_offline_outlined,
                  size: 24,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Container(
                constraints: BoxConstraints(
                  maxWidth: 230,
                  minWidth: 10,
                ),
                decoration: BoxDecoration(
                    color: widget.isBiker ? Colors.greenAccent.withOpacity(0.5) : Colors.blueAccent.withOpacity(0.5),
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    )
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 15,
                ),
                child: Text(
                  widget.fileUrl!,
                  style: TextStyle(
                    fontSize: 13,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if(!widget.isBiker)IconButton(
                tooltip: "Download",
                onPressed: (){
                  downloadfileFunc(isImage: false);
                },
                icon: Icon(
                  Icons.download_for_offline_outlined,
                  size: 24,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
