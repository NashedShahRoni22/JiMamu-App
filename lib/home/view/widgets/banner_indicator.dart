import 'package:flutter/material.dart';

import '../../../global_consts/global_colors.dart';

class BannerIndicator extends StatelessWidget {
  final int itemCount;
  final int currentIndex;

  const BannerIndicator({
    super.key,
    required this.itemCount,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        return Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: currentIndex == index
                ? GlobalColors.black700
                : GlobalColors.black100,
          ),
        );
      }),
    );
  }
}
