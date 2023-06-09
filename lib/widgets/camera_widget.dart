import "dart:io";

import "package:delivery/constants/uiconstants.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

class CameraWidget extends StatelessWidget {

  final VoidCallback gettoCamerafun;
  final double height;
  final bool isshowImage;
  final File? iamgePath;
  final VoidCallback removephotofun;

  const CameraWidget({
    Key? key,
    required this.gettoCamerafun,
    required this.height,
    required this.isshowImage,
    required this.iamgePath,
    required this.removephotofun,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;
    // final double oneUnitWidth = deviceWidth / 360;
    // final double oneUnitHeight = deviceHeight/772;

    return InkWell(
      onTap: (){
        gettoCamerafun();
      },
      child: Container(
        width: deviceWidth,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border.all(
            width: 1,
            color: UIConstant.orange,
          ),
        ),
        child: (!isshowImage)
            ?
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt, color: UIConstant.orange),
            SizedBox(height: 10),
            Text(
              "capturepaymentdocument".tr,
              style: UIConstant.normal,
            )
          ],
        )
            :
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  image: DecorationImage(
                      image: FileImage(
                        iamgePath!,
                      ),
                      fit: BoxFit.cover
                  )
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: Icon(
                  Icons.cancel,
                  size: 32,
                  color: UIConstant.orange,
                ),
                onPressed: removephotofun,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
