import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReauthenticatePage extends StatefulWidget {
  final VoidCallback onSuccess;
  const ReauthenticatePage({super.key, required this.onSuccess});

  @override
  State<ReauthenticatePage> createState() => _ReauthenticatePageState();
}

class _ReauthenticatePageState extends State<ReauthenticatePage> {
  final _passwordController = TextEditingController();
  bool _loading = false;

  Future<void> _reauthenticate() async {
    setState(() => _loading = true);

    try {
      final user = FirebaseAuth.instance.currentUser!;
      final email = user.email!;
      final credential = EmailAuthProvider.credential(
        email: email,
        password: _passwordController.text,
      );

      await user.reauthenticateWithCredential(credential);
      widget.onSuccess(); // ← نحذف الحساب فور النجاح
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message ?? 'Auth error')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final email = FirebaseAuth.instance.currentUser?.email ?? '';
    return Scaffold(
      appBar: AppBar(title: const Text('Re‑authenticate')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Confirm your password to delete the account for\n$email'),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            _loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _reauthenticate,
                    child: const Text('Confirm'),
                  ),
          ],
        ),
      ),
    );
  }
}
