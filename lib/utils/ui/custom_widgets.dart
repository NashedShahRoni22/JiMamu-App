import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constant/color_path.dart';

class CustomWidgets{
  static Color getCustomColor({required BuildContext context,required Color lightColor,required Color darkColor,}) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkColor  // your custom dark mode color
        : lightColor;    // light mode color
  }

}