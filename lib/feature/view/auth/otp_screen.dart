import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jimamu/constant/color_path.dart';
import 'package:jimamu/feature/controller/auth_controller.dart';
import 'package:jimamu/feature/view/auth/update_profile_screen.dart';
import 'package:jimamu/shared_components/custom_button.dart';
import '../../../constant/global_typography.dart';
import '../../../utils/ui/custom_widgets.dart';

class OtpScreen extends StatefulWidget {
  static const String id = 'otpscreen';
   OtpScreen({super.key});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {


  final AuthController _auth=Get.put(AuthController());

  late Timer _timer;
  int _secondsRemaining = 180; // 3 minutes countdown
  bool _canResend = false;
  final List<TextEditingController> _controllers = List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    setState(() {
      _secondsRemaining = 180;
      _canResend = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        _timer.cancel();
      }
    });
  }

  void _resendCode() {
    if (!_canResend) return;
    _startTimer(); // Restart the timer
    // Add logic to resend OTP here
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int sec = seconds % 60;
    return '$minutes:${sec.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onOtpEntered(int index, String value) {
    if (value.isNotEmpty && index < _controllers.length - 1) {
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    }
    if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? ColorPath.black
            : Colors.white,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Image.asset('assets/auth/otp.png'),
              ),
              const SizedBox(height: 20),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  children: [
                    Text('Verification Code', style: GlobalTypography.h1Medium),
                    const SizedBox(height: 32),
                    Text(
                      'We have sent the code verification to your email ${_auth.emailController.text}',
                      style: GlobalTypography.h2Regular,
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(4, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Container(
                            width: 50,
                            height: 60,
                            decoration: BoxDecoration(
                              color: ColorPath.black50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: TextFormField(
                                controller: _controllers[index],
                                focusNode: _focusNodes[index],
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                maxLength: 1,
                                style: GlobalTypography.h1SemiBold.copyWith(
                                  color:ColorPath.black
                                ),
                                decoration: const InputDecoration(
                                  counterText: '',
                                  border: InputBorder.none,
                                ),
                                onChanged: (value) =>
                                    _onOtpEntered(index, value),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      _formatTime(_secondsRemaining),
                      style: GlobalTypography.sub1SemiBold.copyWith(
                        color: ColorPath.black700,
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        text: 'Submit',
                        function: () {

                          List<String> texts = _controllers.map((controller) => controller.text).toList();
                          _auth.otp.value = texts.join();
                          _auth.verifyOtp();

                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Didn’t receive the code?',
                            style: GlobalTypography.sub1Regular),
                        TextButton(
                          onPressed: _canResend ? _resendCode : null,
                          child: Text(
                            'Resend',
                            style: GlobalTypography.sub1Medium.copyWith(
                              color: _canResend
                                  ? ColorPath.black800
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
