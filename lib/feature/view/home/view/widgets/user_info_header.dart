import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../constant/global_typography.dart';
import '../../../../controller/user_controller.dart';

class UserInfoHeader extends StatefulWidget {
  const UserInfoHeader({super.key});

  @override
  State<UserInfoHeader> createState() => _UserInfoHeaderState();
}

class _UserInfoHeaderState extends State<UserInfoHeader> {
  UserController userController=Get.put(UserController());
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Obx((){
          print(userController.isLoadedUserData.value);

          return Row(
            children: [
              const CircleAvatar(radius: 24),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(userController.userProfile.data?.name??"", style: GlobalTypography.sub1Medium),
                  Text('Mohammadpur, Dhaka', style: GlobalTypography.pMedium),
                ],
              ),
            ],
          );
        }),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_outlined),
        )
      ],
    );
  }
}
