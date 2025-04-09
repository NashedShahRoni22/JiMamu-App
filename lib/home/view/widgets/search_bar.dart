import 'package:flutter/material.dart';

import '../../../global_consts/global_colors.dart';
import '../../../global_consts/global_typography.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Search Parcel',
            style: GlobalTypography.sub1Medium
                .copyWith(color: GlobalColors.black700)),
        const SizedBox(height: 12),
        TextFormField(
          decoration: InputDecoration(
            hintText: 'Your parcel code..',
            hintStyle: GlobalTypography.pRegular,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            fillColor: GlobalColors.black50,
          ),
        ),
      ],
    );
  }
}
