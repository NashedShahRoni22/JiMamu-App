import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:jimamu/feature/view/home/view/screens/place_order/view/choose_order_type_screen.dart';

import '../../feature/view/account/view/screens/update_rider_profile_screen.dart';
import '../../feature/view/auth/otp_screen.dart';
import '../../feature/view/auth/sign_in_screen.dart';
import '../../feature/view/account/view/screens/update_user_profile_screen.dart';
import '../../feature/view/home/view/home_screen.dart';
import 'all_route.dart';

class Pages {
  static final route = [
    GetPage(
      name: AllRouters.OTP_PAGE,
      page: () => OtpScreen(),
    ),
    GetPage(
      name: AllRouters.LOGIN_PAGE,
      page: () => const SignInScreen(),
    ),
    GetPage(
      name: AllRouters.UPDTEPROFILE_PAGE,
      page: () => const UpdateUserProfileScreen(),
    ),
    GetPage(
      name: AllRouters.HOME_PAGE,
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: AllRouters.UPDATEACCOUNT_PAGE,
      page: () => const UpdateRiderProfileAccount(),
    ),
    GetPage(
      name: AllRouters.PLACE_ORDER_PAGE,
      page: () => const ChooseOrderTypeScreen(),
    ),
  ];
}
