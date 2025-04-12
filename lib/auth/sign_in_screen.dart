import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:jimamu/auth/otp_screen.dart';
import 'package:jimamu/global_consts/global_colors.dart';
import 'package:jimamu/global_consts/global_typography.dart';
import 'package:jimamu/global_widgets/custom_button.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  Future<void> _handleSocialLogin(BuildContext context) async {
    try {
      const baseUrl = 'https://jimamu.sneakpeekbd.com/api/v1';

      // Dummy user data – replace with Google sign-in logic later
      const name = 'AK Azad';
      const email = 'akazad914@gmail.com';
      const gender = 'male';
      const dod = '1996-10-25';

      // // Pick a dummy image from gallery
      // final ImagePicker picker = ImagePicker();
      // final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      // if (image == null) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text("No image selected")),
      //   );
      //   return;
      // }
      // Load asset image as bytes
      final byteData = await rootBundle.load('assets/auth/profile.png');

// Write to a temp file
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/profile.png');
      await file.writeAsBytes(byteData.buffer.asUint8List());

      final uri = Uri.parse('$baseUrl/social/login');
      final request = http.MultipartRequest('POST', uri)
        ..fields['name'] = name
        ..fields['email'] = email
        ..fields['gender'] = gender
        ..fields['dod'] = dod;

      // Add to multipart request
      request.files
          .add(await http.MultipartFile.fromPath('profile_image', file.path));
      print(file.path);

      final response = await request.send();

      final responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody);
      print("LOGIN RESPONSE: $data");

      if (data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? "Login success")),
        );

        // Trigger email OTP
        final otpUri = Uri.parse('$baseUrl/send/email/otp/$email');
        final otpResponse = await http.get(otpUri);

        if (otpResponse.statusCode == 200) {
          Navigator.pushNamed(context, OtpScreen.id, arguments: email);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to send OTP")),
          );
        }
      } else {
        print("FULL ERROR: $data");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Something went wrong')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          Image.asset(
            'assets/auth/signin.png',
            fit: BoxFit.fitWidth,
          ),
          const SizedBox(height: 16),
          Text('JiMAMU',
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  color: GlobalColors.flushMahogany,
                  fontSize: 36)),
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter your mobile number',
                  style: GlobalTypography.sub1Medium
                      .copyWith(color: GlobalColors.black800),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            BorderSide(color: GlobalColors.black100, width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            BorderSide(color: GlobalColors.black100, width: 1),
                      ),
                      hintText: '017XXXXXXXX'),
                ),
                const SizedBox(height: 40),
                Center(
                  child: Text(
                    'By tapping login, you agree to Terms and Conditions and \nPrivacy of Jimamu.',
                    style: GlobalTypography.pRegular
                        .copyWith(color: GlobalColors.black800),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: 'Login',
                    function: () {
                      Navigator.pushNamed(context, OtpScreen.id);
                    },
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => _handleSocialLogin(context),
                      child: Container(
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  offset: const Offset(0, 2),
                                  color: Colors.black.withOpacity(0.1))
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        padding: const EdgeInsets.all(20),
                        child: Image.asset('assets/auth/google.png'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    if (Platform.isIOS)
                      Container(
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  offset: const Offset(0, 2),
                                  color: Colors.black.withOpacity(0.1))
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        padding: const EdgeInsets.all(20),
                        child: Image.asset('assets/auth/apple.png'),
                      )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    ));
  }
}
