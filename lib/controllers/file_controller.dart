import "dart:io";

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

class FileController extends GetxController{

  Future<File?> getFile()async{
    try{
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
      );

      if (result != null) {
        print("Checking file in file controller ---------------------------------------");
        return File(result.files.single.path!);
      } else {
        // User canceled the picker
        return null;
      }
    }catch(err){
      rethrow;
    }
  }

}