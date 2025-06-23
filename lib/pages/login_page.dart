import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/helper/fcm.dart';
import 'package:chat_app/pages/WhatsAppHomePage.dart';
import 'package:chat_app/pages/resgister_page.dart';
import 'package:chat_app/services/google_auth_service.dart';
import 'package:chat_app/widgts/custom_button.dart';
import 'package:chat_app/widgts/custom_form_text_field.dart';
import 'package:chat_app/helper/show_snak_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static String id = 'LoginPage';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? email;
  String? password;
  bool isLoading = false;
  final GlobalKey<FormState> formKey = GlobalKey();

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
                  const SizedBox(height: 40),
                  Center(child: Image.asset(kLogo, height: 120)),
                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      'Chat App',
                      style: TextStyle(
                        fontSize: 28,
                        color: Color(0xff075E54),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 22,
                      color: Color(0xff075E54),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
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
                  const SizedBox(height: 20),
                  CustomButton(
                    text: 'LOGIN',
                    backgroundColor: const Color(0xff25D366),
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        // إغلاق الكيبورد
                        FocusScope.of(context).unfocus();
                        setState(() => isLoading = true);

                        try {
                          // حذف التوكن السابق للمستخدم السابق
                          await FirebaseMessaging.instance.deleteToken();

                          // تسجيل الدخول
                          UserCredential userCredential = await logingUser();

                          // حفظ توكن المستخدم الحالي
                          await saveFCMToken(email!);

                          showSnakBar(
                            context,
                            'Login successful!',
                            Colors.green,
                          );

                          // الانتقال للصفحة الرئيسية
                          Navigator.pushReplacementNamed(
                            context,
                            WhatsAppHomePage.id,
                            arguments: email,
                          );
                        } on FirebaseAuthException catch (e) {
                          String errorMessage;
                          switch (e.code) {
                            case 'user-not-found':
                              errorMessage =
                                  'No account found with this email.';
                              break;
                            case 'wrong-password':
                              errorMessage = 'Incorrect password.';
                              break;
                            default:
                              errorMessage = 'Login failed: ${e.message}';
                          }
                          showSnakBar(context, errorMessage, Colors.red);
                        }

                        setState(() => isLoading = false);
                      }
                    },
                  ),
                  const SizedBox(height: 15),
                  const GoogleRegisterButton(),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Don\'t have an account?'),
                      TextButton(
                        onPressed: () => Navigator.pushReplacementNamed(
                          context,
                          ResgisterPage.id,
                        ),
                        child: const Text(
                          'Sign Up',
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

  Future<UserCredential> logingUser() async {
    return await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email!,
      password: password!,
    );
  }
}
