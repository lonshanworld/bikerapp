import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import "dart:io";

class CameraImageControlller extends GetxController{

  final picker = ImagePicker();

  Future<File?>getCamera() async{
    try{
      final XFile? photo = await picker.pickImage(
        source: ImageSource.camera,
        // maxWidth: 720,
        // maxHeight: 720,
        imageQuality: 50,
        preferredCameraDevice: CameraDevice.rear,
      );

      if(photo == null){
        return null;
      }else{
        File? image = File(photo.path);
        return image;
      }

    }catch(err){
      rethrow;
    }
  }

  Future<File?> getGallery()async{
    try{
      final XFile? photo = await picker.pickImage(
        imageQuality: 50,
        source: ImageSource.gallery,
      );
      if(photo == null){
        return null;
      }else{
        File? image = File(photo.path);
        return image;
      }

    }catch(err){
      rethrow;
    }

  }
}