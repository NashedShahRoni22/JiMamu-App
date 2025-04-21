import 'package:flutter/material.dart';
import 'package:jimamu/constant/color_path.dart';

import '../constant/global_typography.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback function;

  const CustomButton({super.key, required this.text, required this.function});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: ColorPath.flushMahogany,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
      onPressed: function,
      child: Text(text,
          style: GlobalTypography.sub1SemiBold.copyWith(color: Colors.white)),
    );
  }
}
