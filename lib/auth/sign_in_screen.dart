import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jimamu/auth/otp_screen.dart';
import 'package:jimamu/global_consts/global_colors.dart';
import 'package:jimamu/global_consts/global_typography.dart';
import 'package:jimamu/global_widgets/custom_button.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

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
          const SizedBox(
            height: 16,
          ),
          Text('JiMAMU',
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  color: GlobalColors.flushMahogany,
                  fontSize: 36)),
          const SizedBox(
            height: 40,
          ),
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
                const SizedBox(
                  height: 16,
                ),
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
                const SizedBox(
                  height: 40,
                ),
                Center(
                  child: Text(
                    'By tapping login, you agree to Terms and Conditions and \nPrivacy of Jimamu.',
                    style: GlobalTypography.pRegular
                        .copyWith(color: GlobalColors.black800),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: 'Login',
                    function: () {
                      Navigator.pushNamed(context, OtpScreen.id);
                    },
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                      child: Image.asset('assets/auth/google.png'),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
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
