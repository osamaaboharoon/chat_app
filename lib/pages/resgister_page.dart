import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/pages/WhatsAppHomePage.dart';
import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/widgts/custom_button.dart';
import 'package:chat_app/widgts/custom_form_text_field.dart';
import 'package:chat_app/helper/show_snak_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ResgisterPage extends StatefulWidget {
  static String id = 'ResgisterPage';

  @override
  State<ResgisterPage> createState() => _ResgisterPageState();
}

class _ResgisterPageState extends State<ResgisterPage> {
  String? email;
  String? password;
  String? confirmPassword;
  bool isLoading = false;
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: formKey,
              child: ListView(
                children: [
                  const SizedBox(height: 30),
                  Center(child: Image.asset(kLogo, height: 120)),
                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 26,
                        color: Color(0xff075E54),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  CustomFormTextField(
                    hintText: 'Email',
                    onChanged: (data) => email = data,
                  ),
                  const SizedBox(height: 15),
                  CustomFormTextField(
                    hintText: 'Password',
                    isPassword: true,
                    onChanged: (data) => password = data,
                  ),
                  const SizedBox(height: 15),
                  CustomFormTextField(
                    hintText: 'Confirm Password',
                    isPassword: true,
                    onChanged: (data) => confirmPassword = data,
                  ),
                  const SizedBox(height: 25),
                  CustomButton(
                    text: 'REGISTER',
                    backgroundColor: const Color(0xff25D366),
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        if (password != confirmPassword) {
                          showSnakBar(
                            context,
                            'Passwords do not match!',
                            Colors.red,
                          );
                          return;
                        }

                        setState(() => isLoading = true);
                        try {
                          final userCredential = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                email: email!,
                                password: password!,
                              );
                          await saveUserToFirestore(email!);
                          showSnakBar(
                            context,
                            'Account created successfully!',
                            Colors.green,
                          );
                          Navigator.pushReplacementNamed(
                            context,
                            WhatsAppHomePage.id,
                            arguments: email,
                          );
                        } on FirebaseAuthException catch (e) {
                          String errorMessage;
                          if (e.code == 'weak-password') {
                            errorMessage = 'Password is too weak.';
                          } else if (e.code == 'email-already-in-use') {
                            errorMessage = 'Account already exists.';
                          } else {
                            errorMessage = 'Registration failed: ${e.message}';
                          }
                          showSnakBar(context, errorMessage, Colors.red);
                        }

                        setState(() => isLoading = false);
                      }
                    },
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account?'),
                      TextButton(
                        onPressed: () => Navigator.pushReplacementNamed(
                          context,
                          LoginPage.id,
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(color: Color(0xff075E54)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> saveUserToFirestore(String userEmail) async {
    final doc = FirebaseFirestore.instance.collection('users').doc(userEmail);
    final snapshot = await doc.get();
    if (!snapshot.exists) {
      await doc.set({'email': userEmail, 'createdAt': Timestamp.now()});
    }
  }
}
