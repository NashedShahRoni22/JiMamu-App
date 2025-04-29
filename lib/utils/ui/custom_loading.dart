import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import '../../constant/color_path.dart';
import '../../constant/other_constant.dart';
import '../../shared_components/custom_style.dart';


class CustomLoading {


  static loadingScreen({height, width, margin}) => Center(
      child: Container(
        color: Colors.transparent,

        // margin: margin ?? const EdgeInsets.symmetric(vertical: 100),
          height: height ?? OtherConstant.kDefaultImageHeight,
          width: width ?? OtherConstant.kDefaultImageHeight,
          // decoration:  const BoxDecoration(image:DecorationImage(image:  AssetImage(AssetPath.logo),scale: 1.5),
          //     shape: BoxShape.circle, color: ColorPath.kGreyWhite),
          child: Lottie.asset('assets/icons/jimamu_loader.json')
          // child: Lottie.asset('assets/icons/loading_animation.json')
      ));



  static loadingDialog() => Get.dialog(
    useSafeArea:true,

      Center(
          child:
          Container(
            height: OtherConstant.kMediumIconSize*4,
              width: OtherConstant.kMediumIconSize*4,
              decoration: const BoxDecoration(
                  // image:DecorationImage(
                  //     image:  AssetImage(AssetPath.logo),
                  // ),
                  // shape: BoxShape.circle, color: ColorPath.kGreyWhite
              ),
              child:  Lottie.asset('assets/icons/jimamu_loader.json',
                width: 150,
                height: 150,
                fit: BoxFit.fill,
              )
          )
      ),
      barrierDismissible: false);



  static Padding pdfLoading({progress}) {
    return Padding(
      padding:
      EdgeInsets.symmetric(horizontal: OtherConstant.kLargePadding * 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Downloading...',
            style: CustomStyle.kCustomTextStyle(),
          ),
          SizedBox(
            height: OtherConstant.kRegularPadding,
          ),
          ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: progress,
                color: ColorPath.kPrimaryColor,
                minHeight: OtherConstant.kLargePadding,
                backgroundColor: ColorPath.kGreyLight,
              )),
        ],
      ),
    );
  }

  static Padding shimmerLoadingScreen(BuildContext context, {itemCount = 2}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: OtherConstant.kLargePadding,vertical: OtherConstant.kLargePadding
      ),
      child: Shimmer.fromColors(
          baseColor: ColorPath.kGreyLight,
          highlightColor: Colors.white,
          child: ListView.builder(
              itemCount: itemCount,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Row(
                  children: [

                    Container(
                      width:50,
                      height:50,
                      decoration:  BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor.withOpacity(0.8),),
                    ),
                    SizedBox(width: OtherConstant.kRegularPadding,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              top: OtherConstant.kLargePadding,
                              bottom: OtherConstant.kRegularPadding),
                          height: OtherConstant.kLargePadding,
                          width: OtherConstant.kCustomWidth(context)/2,
                          decoration: CustomStyle.kCustomBoxDecoration(
                            color: ColorPath.kGreyWhite,
                            borderRadius:BorderRadius.circular(OtherConstant.kSmallRadius)
                        ),
                         
                        ),
                        Container(
                          height: OtherConstant.kLargePadding,
                          width:300,
                          decoration: CustomStyle.kCustomBoxDecoration(
                              color: ColorPath.kGreyWhite,
                              borderRadius:BorderRadius.circular(OtherConstant.kSmallRadius)
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              bottom: OtherConstant.kLargePadding,
                              top: OtherConstant.kRegularPadding),
                          height: OtherConstant.kLargePadding,
                          width:300,
                          decoration: CustomStyle.kCustomBoxDecoration(
                              color: ColorPath.kGreyWhite,
                              borderRadius:BorderRadius.circular(OtherConstant.kSmallRadius)
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              })),
    );
  }
}
