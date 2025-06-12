// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class PhoneLoginPage extends StatefulWidget {
//   const PhoneLoginPage({super.key});
//   static String id = 'PhoneLoginPage';

//   @override
//   State<PhoneLoginPage> createState() => _PhoneLoginPageState();
// }

// class _PhoneLoginPageState extends State<PhoneLoginPage> {
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController otpController = TextEditingController();

//   String? verificationId;
//   bool codeSent = false;
//   bool isLoading = false;

//   Future<void> sendOTP() async {
//     setState(() {
//       isLoading = true;
//     });

//     await FirebaseAuth.instance.verifyPhoneNumber(
//       phoneNumber: phoneController.text.trim(),
//       timeout: const Duration(seconds: 60),
//       verificationCompleted: (PhoneAuthCredential credential) async {
//         // Auto-verification (mostly on real devices)
//         await FirebaseAuth.instance.signInWithCredential(credential);
//       },
//       verificationFailed: (FirebaseAuthException e) {
//         setState(() {
//           isLoading = false;
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(e.message ?? "Verification failed")),
//         );
//       },
//       codeSent: (String verId, int? resendToken) {
//         setState(() {
//           verificationId = verId;
//           codeSent = true;
//           isLoading = false;
//         });
//       },
//       codeAutoRetrievalTimeout: (String verId) {
//         verificationId = verId;
//       },
//     );
//   }

//   Future<void> verifyOTP() async {
//     final smsCode = otpController.text.trim();
//     if (verificationId != null) {
//       try {
//         final credential = PhoneAuthProvider.credential(
//           verificationId: verificationId!,
//           smsCode: smsCode,
//         );
//         await FirebaseAuth.instance.signInWithCredential(credential);
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(const SnackBar(content: Text("Login successful")));
//         // Navigate to home/chat page here
//       } catch (e) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text("Invalid code: $e")));
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Login with Phone")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   if (!codeSent) ...[
//                     const Text("Enter your phone number:"),
//                     TextField(
//                       controller: phoneController,
//                       keyboardType: TextInputType.phone,
//                       decoration: const InputDecoration(
//                         hintText: "+20xxxxxxxxxx",
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     ElevatedButton(
//                       onPressed: sendOTP,
//                       child: const Text("Send OTP"),
//                     ),
//                   ] else ...[
//                     const Text("Enter the OTP sent to your phone:"),
//                     TextField(
//                       controller: otpController,
//                       keyboardType: TextInputType.number,
//                       decoration: const InputDecoration(
//                         hintText: "6-digit code",
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     ElevatedButton(
//                       onPressed: verifyOTP,
//                       child: const Text("Verify OTP"),
//                     ),
//                   ],
//                 ],
//               ),
//       ),
//     );
//   }
// }
