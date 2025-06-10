import 'package:chat_app/pages/resgister_page.dart';
import 'package:chat_app/widgts/custom_button.dart';
import 'package:chat_app/widgts/custom_form_text_field.dart';
import 'package:chat_app/helper/show_snak_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                      'Sign In',
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
                  text: 'LOGIN',
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      setState(() => isLoading = true);

                      try {
                        UserCredential userCredential = await logingUser();

                        showSnakBar(context, 'Login successful!', Colors.green);
                        print("User logged in: ${userCredential.user?.email}");
                      } on FirebaseAuthException catch (e) {
                        String errorMessage = '';

                        switch (e.code) {
                          case 'user-not-found':
                            errorMessage = 'No account found with this email.';
                            break;
                          case 'wrong-password':
                            errorMessage =
                                'Incorrect password. Please try again.';
                            break;
                          case 'invalid-credential':
                            errorMessage = 'Invalid email or password.';
                            break;
                          case 'invalid-email':
                            errorMessage =
                                'The email address is badly formatted.';
                            break;
                          case 'too-many-requests':
                            errorMessage =
                                'Too many attempts. Please try again later.';
                            break;
                          default:
                            errorMessage =
                                'An unexpected error occurred. Please try again.';
                        }

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

                      setState(() => isLoading = false);
                    }
                  },
                ),
                const SizedBox(height: 15),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'don\'t have an account',
                      style: TextStyle(color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, 'ResgisterPage'),
                      child: Text(
                        ' Sign Up',
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

  Future<UserCredential> logingUser() async {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: password!);
    return userCredential;
  }
}
