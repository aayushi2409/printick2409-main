import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:printick/services/order_supa_service.dart';
import 'package:printick/services/profile_service.dart';


class AppAuthProvider extends ChangeNotifier{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? user;
  bool isLoading = true;
String? name;
String? email;
bool isProfileLoaded = false;
String? phone;
int totalOrders = 0;
double totalSpent = 0;
String? lastOrderDate;
bool isStatsLoaded = false;

  AppAuthProvider() {
_auth.authStateChanges().listen((u) async {
  user = u;

  if (u != null) {
    await fetchUserProfile(u.uid); // 🔥 ADD THIS
  } else {
    isProfileLoaded = true;
  }

  isLoading = false;
  notifyListeners();
});
  }
Future<void> fetchUserStats() async {
  if (user == null) return;

  try {
    isStatsLoaded = false;
    notifyListeners();

    final uid = user!.uid;

    totalOrders = await OrderService.getTotalOrders(uid);
    totalSpent = await OrderService.getTotalSpent(uid);
    lastOrderDate = await OrderService.getLastOrderDate(uid);

  } catch (e) {
    print("STATS ERROR: $e");
  }

  isStatsLoaded = true;
  notifyListeners();
}
Future<void> validateUser() async {
  try {
    await _auth.currentUser?.reload();
    user = _auth.currentUser;

    if (user != null) {
      await fetchUserProfile(user!.uid);
    } else {
      isProfileLoaded = true;
    }

  } catch (e) {
    // 🔥 OFFLINE SAFE
    user = _auth.currentUser;

    if (user != null) {
      // Try fetching profile anyway (may fail but handled)
      await fetchUserProfile(user!.uid);
    } else {
      isProfileLoaded = true;
    }
  }

  notifyListeners();
}
  
  Future<void> fetchUserProfile(String userId) async {
  try {
    final data = await ProfileService.getProfile(userId);

    name = data?['user_name'];
    email = data?['email'];
    phone = data?['phone'];

    await fetchUserStats();    // 🔥 ADD THIS LINE
    isProfileLoaded = true;
    notifyListeners();
  } catch (e) {
    isProfileLoaded = true;
    notifyListeners();
  }
}
String? validateAndFormatPhone(String input) {
  String phone = input.trim();

  // 🔹 Remove spaces & symbols
  phone = phone.replaceAll(RegExp(r'[^0-9]'), '');

  // 🔹 Remove leading 91 if user typed it
  if (phone.startsWith('91') && phone.length == 12) {
    phone = phone.substring(2);
  }

  // 🔹 Validation
  if (phone.length != 10) {
    return null; // invalid
  }

  // 🔹 Format to +91
  return "+91$phone";
}


Future<bool> updateUserProfile({
  String? name,
  String? phone,
}) async {
  if (user == null) return false;

  final updateData = <String, dynamic>{};

  /// 🔹 Handle name
  if (name != null) {
    updateData['user_name'] = name;
  }

  /// 🔹 Handle phone (VALIDATION + FORMAT)
  if (phone != null) {
    final formattedPhone = validateAndFormatPhone(phone);

    if (formattedPhone == null) {
      return false; // ❌ invalid number
    }

    updateData['phone'] = formattedPhone;
    this.phone = formattedPhone; // update locally
  }

  /// 🔥 Update DB
  await ProfileService.updateProfile(
    userId: user!.uid,
    data: updateData,
  );

  /// 🔹 Update local name
  if (name != null) this.name = name;

  notifyListeners();
  return true;
}

}