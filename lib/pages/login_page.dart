import 'package:chat_app/pages/resgister_page.dart';
import 'package:chat_app/widgts/custom_button.dart';
import 'package:chat_app/widgts/custom_text_field.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff2B475E),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
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
            CustomTextField(hintText: 'Email'),
            const SizedBox(height: 10),

            CustomTextField(hintText: 'Password'),

            SizedBox(height: 20),

            const CustomButton(text: 'LOGIN'),
            const SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'don\'t have an account',
                  style: TextStyle(color: Colors.white),
                ),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, 'ResgisterPage'),
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
    );
  }
}
