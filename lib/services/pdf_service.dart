import 'dart:io';
import 'package:pdfx/pdfx.dart';

class PdfService {
  static Future<int> getPageCount(File file) async {
    try {
      final document = await PdfDocument.openFile(file.path);
      return document.pagesCount;
    } catch (e) {
      print("PDF Error: $e");
      return 0;
    }
  }
}