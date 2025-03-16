import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jimamu/auth/sign_in_screen.dart';
import 'package:jimamu/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.white,
          textTheme: GoogleFonts.interTextTheme()),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: const SignInScreen(),
    );
  }
}
