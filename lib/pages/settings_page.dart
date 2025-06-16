import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'login_page.dart';
import 'privacy_policy_page.dart';

class SettingsPage extends StatelessWidget {
  static String id = 'SettingsPage';
  final String currentUserEmail;

  const SettingsPage({super.key, required this.currentUserEmail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.email, color: Colors.black),
              title: Text('Email: $currentUserEmail'),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.orange),
              title: Text('Logout'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacementNamed(LoginPage.id);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.delete_forever, color: Colors.red),
              title: Text('Delete My Account'),
              onTap: () async {
                final confirm = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Delete Account"),
                    content: Text(
                      "Are you sure you want to delete your account? This cannot be undone.",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text(
                          "Delete",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
                if (confirm == true) await _deleteAccount(context);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.privacy_tip, color: Colors.blue),
              title: Text('Privacy Policy'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PrivacyPolicyPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteAccount(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // تأكد إنك بتستخدم email أو uid حسب قاعدة بياناتك
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.email)
            .delete();
        await user.delete();

        Navigator.of(context).pushReplacementNamed(LoginPage.id);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Account deleted.")));
      }
    } catch (e) {
      print("Error deleting account: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to delete account.")));
    }
  }
}
