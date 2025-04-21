import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:jimamu/feature/view/auth/sign_in_screen.dart';
import 'package:jimamu/feature/view/auth/update_profile_screen.dart';
import 'package:jimamu/feature/view/home/view/home_screen.dart';
import '../../controller/auth_controller.dart';


class SwitchLoginPage extends GetView<AuthController> {
  const SwitchLoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    return GetX<AuthController>(
      init: AuthController(),
      builder: (_) {
        if (_.isLogging.isTrue) {

          print([_.isUpdateProfile.value,"IsUpdate"]);

         if(_.isUpdateProfile.isTrue){
           return const HomeScreen();
         }else{
           return const UpdateProfileScreen();
         }
        } else {
          return const SignInScreen();
        }
      },
    );
  }



}