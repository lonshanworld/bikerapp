import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import "dart:io";

class CameraImageControlller extends GetxController{

  final picker = ImagePicker();

  Future<File?>getCamera() async{
    final XFile? photo = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 720,
      maxHeight: 720,
      imageQuality: 50,
      preferredCameraDevice: CameraDevice.rear,
    );

    File? image = File(photo!.path);

    return image;
  }


}