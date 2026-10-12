import 'dart:io';
import 'package:flutter/material.dart';
import 'package:printick/services/supabase_storage_service.dart';
import 'package:printick/models/price_breakdown_model.dart';
import 'package:printick/services/pricing_service.dart';

class UploadProvider extends ChangeNotifier {
  /// FILE
  File? file;
  String? fileName;
  String? uploadedFilePath;
  String? fileUrl;

  /// PRINT SETTINGS
  int copies = 1;
  bool isColor = false;

  int? pages; // 👈 IMPORTANT (nullable)

  /// PRICE
  double price = 0;

  PriceBreakdownModel? priceBreakdown;

  bool isUploading = false;
  bool isUploaded = false;
  double uploadProgress = 0; // 0 → 100
  String? uploadError;
  String paperSize = "A4";
  bool isDoubleSide = false;

Future<void> setPaperSize(String size) async {
  paperSize = size;
  await refreshPrice();
}

Future<void> toggleDoubleSide(bool value) async {
  isDoubleSide = value;
  await refreshPrice();
}

void setError(String error) {
  uploadError = error;
  notifyListeners();
}

void clearError() {
  uploadError = null;
}

  /// SET FILE
  void setFile(File pickedFile) {
    uploadProgress = 0;
    file = pickedFile;
    fileName = pickedFile.path.split('/').last;
    pages = null; // 👈 show Detecting
    price = 0;
    isUploaded = false;
    priceBreakdown = null;
    notifyListeners();
  }

Future<void> setPages(int value) async {
  pages = value;
  await refreshPrice();
}

void setProgress(double value) {
  uploadProgress = value;
  notifyListeners();
}
  /// REMOVE FILE
 Future<void> removeFile() async {
    if (uploadedFilePath != null) {
    await SupabaseStorageService.deletePdf(uploadedFilePath!);
  }

      file = null;
      fileName = null;
      pages = null;     // 👈 reset pages
      price = 0;        // 👈 reset price
      priceBreakdown = null;
      copies = 1;       // 👈 reset copies
      isColor = false; 
      paperSize = "A4";
      isDoubleSide = false; // 👈 reset to B/W
      fileUrl = null;
      uploadedFilePath = null;
      isUploaded = false;
      notifyListeners();

  }

  void resetStateOnly() {
  file = null;
  fileName = null;
  pages = null;
  price = 0;
  priceBreakdown = null;
  copies = 1;
  isColor = false;
  paperSize = "A4";
  isDoubleSide = false;
  fileUrl = null;
  uploadedFilePath = null;
  isUploaded = false;
  uploadProgress = 0;
  uploadError = null;

  notifyListeners();
}

  /// COPIES
Future<void> increaseCopies() async {
    copies++;
   await refreshPrice();
  }

Future<void> decreaseCopies() async {
    if (copies > 1) {
      copies--;
     await refreshPrice();
    }
  }

  /// COLOR
Future<  void> toggleColor(bool value) async {
    isColor = value;
  await refreshPrice();
  }

  /// PRICE LOGIC
// void calculatePrice() {
//   if (pages == null) return;

//   // ✅ ONLY price per page
//   price = isColor ? 5.0 : 1.0;

//   notifyListeners();
// }

  void setUploading(bool value) {
    isUploading = value;
    
    notifyListeners();
  }

void setUploadResult(String url, String path) {
  fileUrl = url;
  uploadedFilePath = path;
  isUploaded = true;
  uploadProgress = 100;
  notifyListeners();
}

Future<void> refreshPrice() async {

if (pages == null || pages == 0) {
  price = 0;
  priceBreakdown = null;

  notifyListeners();
  return;
}
  priceBreakdown =
      await PricingService.calculatePrice(
    pages: pages!,
    copies: copies,
    isColor: isColor,
    isDoubleSide: isDoubleSide,
    paperSize: paperSize,
  );

  price = priceBreakdown!.total;

  notifyListeners();
}
}
