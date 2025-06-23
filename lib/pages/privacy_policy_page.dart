import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  static const String id = 'PrivacyPolicyPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: Colors.blue.shade700,
        centerTitle: true,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text('''
Privacy Policy for ChatApp

Last updated: 23 June 2025

ChatApp is a chat application developed by Osama Farrag (o.haroon111@gmail.com). We respect your privacy and are committed to protecting your personal data.

1. Data Collection:
We collect and store the following data:
- Email address used for login (via Firebase Authentication)
- Firebase Cloud Messaging (FCM) token for delivering notifications

This data is stored securely in Firebase Firestore.

2. Data Usage:
The collected data is used only for:
- Enabling user login and authentication
- Identifying chat participants
- Sending push notifications via Firebase and external server (Railway)

We do **not** sell, rent, or share your data with third parties.

3. Notifications:
To provide real-time chat notifications, we collect your FCM token and send it to Firebase and our secure external server (https://railway.app). This is only used for delivering messages between users.

4. Data Deletion:
You may request to delete your account and data by contacting us at o.haroon111@gmail.com. We will delete your data from Firebase Authentication and Firestore within 7 days of request.

5. Account Logout:
Logging out ends your session locally, but data remains stored until the account is deleted.

6. Third-party Services:
This app uses the following third-party services:
- Firebase Authentication
- Firebase Firestore
- Firebase Cloud Messaging (FCM)
- Railway (external backend server for notifications)

Please review their privacy policies:
- Firebase: https://firebase.google.com/support/privacy
- Railway: https://railway.app/legal/privacy

7. Contact Us:
If you have any questions or concerns, please contact:
Email: o.haroon111@gmail.com
Phone: +20 1154060470

View the online version at:
https://osamaaboharoon.github.io/chatapp-privacy-policy/

By using ChatApp, you agree to this privacy policy.
''', style: TextStyle(fontSize: 16, height: 1.5)),
        ),
      ),
    );
  }
}
