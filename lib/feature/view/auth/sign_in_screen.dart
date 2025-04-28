import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:jimamu/constant/color_path.dart';
import 'package:jimamu/feature/controller/auth_controller.dart';
import 'package:jimamu/shared_components/custom_button.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import '../../../constant/global_typography.dart';
import 'otp_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  final AuthController _auth=Get.put(AuthController());
  final _formKey = GlobalKey<FormState>();


@override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
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
                    color: ColorPath.flushMahogany,
                    fontSize: 36)),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enter your email',
                    style: GlobalTypography.sub1Medium
                        .copyWith(color: ColorPath.black800),
                  ),
                  const SizedBox(height: 16),

                  Form(
                    key: _formKey,
                      child: Column(children: [
                    TextFormField(
                      controller: _auth.emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        }

                        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                        if (!emailRegex.hasMatch(value)) {
                          return 'Enter a valid email address';
                        }

                        return null; // valid
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                            BorderSide(color: ColorPath.black100, width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                            BorderSide(color: ColorPath.black100, width: 1),
                          ),
                          hintText: 'Type email'),
                    ),

                        const SizedBox(height: 40),
                        Center(
                          child: Text(
                            'By tapping login, you agree to Terms and Conditions and \nPrivacy of Jimamu.',
                            style: GlobalTypography.pRegular
                                .copyWith(color: ColorPath.black800),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 40),
                        SizedBox(
                          width: double.infinity,
                          child: CustomButton(
                            text: 'Login',
                            function: () {

                              if(_formKey.currentState!.validate()){
                               _auth.sendOtp();
                              }

                            },
                          ),
                        ),
                  ],)),

                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                      onTap: () async {
                     _auth.handleGoogleSignIn().then((res){
                       if(res==true){
                         _auth.handleSocialLogin(context);
                       }else{
                         Fluttertoast.showToast(msg: "Login failed");
                       }
                     }) ;

                              },
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 2),
                      color: Colors.black.withOpacity(0.1),
                    )
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
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
      ),
    ));
  }
}
