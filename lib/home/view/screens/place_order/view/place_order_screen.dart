import 'package:flutter/material.dart';
import 'package:jimamu/global_consts/global_colors.dart';
import 'package:jimamu/global_consts/global_typography.dart';

class PlaceOrderScreen extends StatelessWidget {
  static const String id = 'PlaceOrderScreen';
  const PlaceOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          _buildSteps(),
          const SizedBox(height: 20),
          _buildAddressCard(),
          const SizedBox(height: 20),
          _buildMapPreview(),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: GlobalColors.flushMahogany,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // Handle continue
                },
                child: Text('Continue',
                    style: GlobalTypography.sub1Medium
                        .copyWith(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSteps() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStepItem(Icons.location_on, "Locations", true),
          _buildStepItem(Icons.info_outline, "Information", false),
          _buildStepItem(Icons.receipt_long, "Confirmation", false),
        ],
      ),
    );
  }

  Widget _buildStepItem(IconData icon, String label, bool active) {
    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor:
              active ? GlobalColors.flushMahogany : GlobalColors.secondary,
          child:
              Icon(icon, color: active ? Colors.white : GlobalColors.black500),
        ),
        const SizedBox(height: 8),
        Text(label,
            style: GlobalTypography.bodyMedium.copyWith(
              color: active ? GlobalColors.black : GlobalColors.black400,
            )),
      ],
    );
  }

  Widget _buildAddressCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: GlobalColors.secondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildAddressRow(
            label: 'Collect from',
            description:
                'Kilometer 6, 278H, Street 201R, Kroalkor Village, Unnamed Road, Phnom Penh',
          ),
          const Divider(height: 28),
          _buildAddressRow(
            label: 'Delivery to',
            description:
                '2nd Floor 01, 25 Mao Tse Toung Blvd (245), Phnom Penh 12302, Cambodia',
          ),
        ],
      ),
    );
  }

  Widget _buildAddressRow(
      {required String label, required String description}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.location_pin, color: GlobalColors.flushMahogany),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: GlobalTypography.bodyMedium),
              const SizedBox(height: 4),
              Text(description, style: GlobalTypography.pRegular),
            ],
          ),
        ),
        Icon(Icons.edit, color: GlobalColors.black400, size: 18),
      ],
    );
  }

  Widget _buildMapPreview() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          'assets/images/map_preview.png', // Add your map snapshot here
          fit: BoxFit.cover,
          height: 180,
          width: double.infinity,
        ),
      ),
    );
  }
}
