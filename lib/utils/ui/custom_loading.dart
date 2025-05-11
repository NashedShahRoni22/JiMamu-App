import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../constant/color_path.dart';
import '../../constant/other_constant.dart';
import '../../shared_components/custom_style.dart';

class CustomLoading {
  /// Standard centered loading spinner
  static Widget loadingScreen(
          {double? height, double? width, EdgeInsets? margin}) =>
      Center(
        child: CircularProgressIndicator(
          color: ColorPath.flushMahogany,
        ),
      );

  /// Blocking dialog loading
  static Future<void> loadingDialog() => Get.dialog(
        Center(
          child: CircularProgressIndicator(
            color: ColorPath.flushMahogany,
            strokeWidth: 4,
          ),
        ),
        barrierDismissible: false,
        useSafeArea: true,
      );

  /// PDF download loading with progress
  static Padding pdfLoading({double? progress}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 64.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Downloading...',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              color: ColorPath.flushMahogany,
              minHeight: 8,
              backgroundColor: ColorPath.kGreyLight,
            ),
          ),
        ],
      ),
    );
  }

  /// Shimmer loading placeholder for list items
  static Padding shimmerLoadingScreen(BuildContext context,
      {int itemCount = 2}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Shimmer.fromColors(
        baseColor: ColorPath.kGreyLight,
        highlightColor: Colors.white,
        child: ListView.builder(
          itemCount: itemCount,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor.withOpacity(0.8),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      height: 20,
                      width: MediaQuery.of(context).size.width / 2,
                      decoration: CustomStyle.kCustomBoxDecoration(
                        color: ColorPath.kGreyWhite,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    Container(
                      height: 20,
                      width: 300,
                      decoration: CustomStyle.kCustomBoxDecoration(
                        color: ColorPath.kGreyWhite,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 20),
                      height: 20,
                      width: 300,
                      decoration: CustomStyle.kCustomBoxDecoration(
                        color: ColorPath.kGreyWhite,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
