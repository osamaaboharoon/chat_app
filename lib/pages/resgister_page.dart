import 'package:chat_app/widgts/custom_button.dart';
import 'package:chat_app/widgts/custom_form_text_field.dart';
import 'package:chat_app/helper/show_snak_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ResgisterPage extends StatefulWidget {
  ResgisterPage({super.key});

  @override
  State<ResgisterPage> createState() => _ResgisterPageState();
}

class _ResgisterPageState extends State<ResgisterPage> {
  String? email;

  String? password;

  bool isLoading = false;

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: Color(0xff2B475E),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                Image.asset('assets/images/scholar.png', height: 200),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Chat App',
                      style: TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                        fontFamily: 'Pacifico',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),

                Row(
                  children: [
                    Text(
                      'REGISTER',
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                CustomFormTextField(
                  hintText: 'Email',
                  onChanged: (data) {
                    email = data;
                  },
                ),
                const SizedBox(height: 10),

                CustomFormTextField(
                  hintText: 'Password',
                  isPassword: true,
                  onChanged: (data) {
                    password = data;
                  },
                ),
                SizedBox(height: 20),

                CustomButton(
                  text: 'REGISTER',
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      isLoading = true;
                      setState(() {});
                      try {
                        UserCredential userCredential = await resgisterUser();

                        // ✅ رسالة نجاح
                        showSnakBar(
                          context,
                          'Account created successfully!',
                          Colors.green,
                        );
                        print("User registered: ${userCredential.user?.uid}");
                      } on FirebaseAuthException catch (e) {
                        String errorMessage = '';

                        if (e.code == 'weak-password') {
                          errorMessage = 'The password provided is too weak.';
                        } else if (e.code == 'email-already-in-use') {
                          errorMessage =
                              'The account already exists for that email.';
                        } else {
                          errorMessage = 'Error: ${e.code}';
                        }

                        // ❌ رسالة خطأ
                        showSnakBar(context, errorMessage, Colors.red);

                        print(errorMessage);
                      } catch (e) {
                        showSnakBar(
                          context,
                          'Unexpected error occurred.',
                          Colors.red,
                        );

                        print('Unexpected error: $e');
                      }
                      isLoading = false;
                      setState(() {});
                    } else {}
                  },
                ),
                const SizedBox(height: 15),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'already have an account ?',
                      style: TextStyle(color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        ' login',
                        style: TextStyle(color: Color(0xffc7ede6)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<UserCredential> resgisterUser() async {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email!, password: password!);
    return userCredential;
  }
}
