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

Last updated: 12 June 2025

ChatApp is a chat application developed by Osama Farrag (o.haroon111@gmail.com / 01154060470). We respect your privacy and are committed to protecting your personal data.

1. Data Collection:
We collect and store the email addresses and display names used for login via Firebase Authentication. No other personal data is collected or stored locally on the device.

2. Data Usage:
Collected data is used solely for enabling user login, identifying chat participants, and managing messages using Firebase. We do not sell, share, or expose your data to third parties.

3. Data Deletion:
Users can request account deletion by contacting us at o.haroon111@gmail.com or 01154060470. We will delete the account and its associated data from Firebase upon request.

4. Account Logout:
Users can log out of the application, which ends their session locally.

5. Third-party Services:
This app uses Firebase services (Authentication, Firestore). Their privacy policies can be reviewed at https://firebase.google.com/support/privacy.

6. Contact Us:
If you have questions about this policy, contact us at:
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
