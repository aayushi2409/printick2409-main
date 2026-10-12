import 'dart:io';

import 'package:file_picker/file_picker.dart';

class FileService {

  static Future<File?> pickPdf() async {

    try {

      final result =
          await FilePicker.platform.pickFiles(

        type: FileType.custom,

        allowedExtensions: ['pdf'],

        withData: true,
      );

      if (result == null) {
        return null;
      }

      final file =
          result.files.single;

      /// 🔥 SAFE PATH CHECK
      if (file.path != null) {

        return File(file.path!);
      }

      return null;

    } catch (e) {

      print(
        "FILE PICK ERROR => $e",
      );

      return null;
    }
  }
}