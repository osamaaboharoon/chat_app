import 'package:chat_app/helper/fcm.dart';
import 'package:chat_app/helper/show_snak_bar.dart';
import 'package:chat_app/pages/WhatsAppHomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleRegisterButton extends StatefulWidget {
  const GoogleRegisterButton({super.key});

  @override
  State<GoogleRegisterButton> createState() => _GoogleRegisterButtonState();
}

class _GoogleRegisterButtonState extends State<GoogleRegisterButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 3,
            ),
            onPressed: () async {
              setState(() => isLoading = true);

              try {
                // مسح توكن المستخدم السابق
                await FirebaseMessaging.instance.deleteToken();

                UserCredential userCredential = await signInWithGoogle();

                final googleEmail = userCredential.user?.email ?? '';
                if (googleEmail.isEmpty) {
                  showSnakBar(context, 'Something went wrong.', Colors.red);
                  return;
                }

                // حفظ توكن المستخدم الجديد
                await saveFCMToken(googleEmail);

                showSnakBar(context, 'Logged in with Google!', Colors.green);

                Navigator.pushReplacementNamed(
                  context,
                  WhatsAppHomePage.id,
                  arguments: googleEmail,
                );
              } catch (e) {
                showSnakBar(context, 'Google login failed.', Colors.red);
              }

              setState(() => isLoading = false);
            },
            icon: const Icon(Icons.g_mobiledata, color: Colors.blueAccent),
            label: const Text(
              'Sign in with Google',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          );
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      throw Exception("User canceled Google Sign-In");
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithCredential(credential);

    await saveUserToFirestore(userCredential.user!.email!);
    return userCredential;
  }

  Future<void> saveUserToFirestore(String userEmail) async {
    final doc = FirebaseFirestore.instance.collection('users').doc(userEmail);
    final snapshot = await doc.get();
    if (!snapshot.exists) {
      await doc.set({'email': userEmail, 'createdAt': Timestamp.now()});
    }
  }
}
