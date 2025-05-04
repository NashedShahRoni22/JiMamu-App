
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:jimamu/config/routes.dart';
import 'package:jimamu/feature/model/user_profile-model.dart' as user;
import 'package:jimamu/feature/model/update_rider_data_model.dart' as rider;
import 'package:jimamu/feature/view/auth/switch_login_view.dart';
import 'config/routing/pages.dart';
import 'constant/local_string.dart';
import 'feature/controller/theme_controller.dart';
import 'package:jimamu/feature/model/token.dart' as token;
import 'firebase_options.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug,
  );



  await Hive.initFlutter();
  await GetStorage.init();


  ///////////// Hive Box Initialize //////////////



  // Token
  Hive.registerAdapter(token.TokenAdapter());
  Hive.registerAdapter(token.DataAdapter());


  // User


  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});
  final ThemeController themeController = Get.put(ThemeController());
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context,child) {
        return Obx(() => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme:ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.light,
            ),
            useMaterial3: true,
          ),
          getPages: Pages.route,

          themeMode: themeController.themeMode.value,
       darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
          useMaterial3: true,
        ),
          onGenerateRoute: (settings) => generateRoute(settings),
          home: child,
        ));
      },
      // child: const SwitchLoginPage(),
      child: const SwitchLoginPage(),
    );
  }
}
