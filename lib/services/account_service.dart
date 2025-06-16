import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../ui/reauthenticate_page.dart';

class AccountService {
  static final _auth = FirebaseAuth.instance;
  static final _firestore = FirebaseFirestore.instance;

  // استدعِ هذه الدالة من أي مكان
  static Future<void> deleteAccount(BuildContext context) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      // 1) امسح بيانات Firestore الخاصة بالمستخدم
      await _firestore.collection('users').doc(user.uid).delete();

      // 2) امسح حساب Auth
      await user.delete();

      // 3) توجّه لصفحة البداية / تسجيل الدخول
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        // افتح صفحة إعادة المصادقة، وبمجرد نجاحها
        // ارجع ونفّذ الحذف مرة أخرى
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                ReauthenticatePage(onSuccess: () => deleteAccount(context)),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Unexpected error')),
        );
      }
    }
  }
}
