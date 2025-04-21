import 'package:flutter/material.dart';

import '../constant/color_path.dart';
import '../constant/other_constant.dart';

class CustomStyle {
  static TextStyle kCustomTextStyle(
          {double? fontSize,
            FontWeight? fontWeight = FontWeight.normal,
          Color color = ColorPath.kGreyBlack,
          Color decorationColor = ColorPath.kBlueMain,
            double? height,
            TextDecoration? decoration}) =>
      TextStyle(
        fontSize: fontSize ??OtherConstant.kRegularTextSize,
        fontWeight: fontWeight,
        color: color,
        decoration: decoration,
        decorationColor:decorationColor,
        height: height
      );

  static kCustomTextFieldDecoration(
      {String? hintText,
        TextStyle? hintTextStyle,
        InputBorder? border,
        BoxConstraints? boxConstraints,
        double? prefixIconSize,
        Widget? label,
        Widget? suffixIcon,
        bool floatingLabelBehavior = false,
        EdgeInsetsGeometry? contentPadding,
        Color? fillColor}) {
    return InputDecoration(

        floatingLabelBehavior:
        floatingLabelBehavior ? FloatingLabelBehavior.always : null,
        hintText: hintText,
        hintStyle: hintTextStyle ??
        CustomStyle.kCustomTextStyle(color: ColorPath.kGreyMain, fontSize: OtherConstant.kMediumTextSize,),
        label:label,
        contentPadding:contentPadding??EdgeInsets.symmetric(horizontal:16, vertical: 14),
        enabledBorder: border ??OutlineInputBorder(borderRadius:BorderRadius.circular(10)),
        focusedBorder:border ??OutlineInputBorder( borderRadius:BorderRadius.circular(10)),
        border:border ??OutlineInputBorder(borderRadius:BorderRadius.circular(10)),
        filled: true,

        fillColor: fillColor ?? ColorPath.kGreyLightest,
        suffixIcon: suffixIcon,
        suffixIconConstraints: const BoxConstraints.tightFor(
          width: 30,
          height: 30,
        ),
        prefixIconConstraints: BoxConstraints.tightFor(
          width: prefixIconSize ?? 40,
          height: prefixIconSize ?? 40,
        )

    );
  }

  static kCustomBoxDecoration(
      {Color color = ColorPath.kGreyWhite,
      borderRadius,
      List<BoxShadow>? shadow, ImageProvider<Object>? image,
      BoxBorder? border}) {
    return BoxDecoration(
        color: color,
        image:image != null? DecorationImage(image: image):null,
        borderRadius: borderRadius,
        boxShadow: shadow,
        border: border);
  }
}
