import 'package:flutter/material.dart';
import 'package:jimamu/global_consts/global_colors.dart';
import 'package:jimamu/global_consts/global_typography.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jimamu/home/view/home_screen.dart';
import 'package:jimamu/home/view/screens/place_order/view/screens/location_picker_screen.dart';

class PlaceOrderScreen extends StatefulWidget {
  static const String id = 'PlaceOrderScreen';
  const PlaceOrderScreen({super.key});

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  LatLng? selectedLocation;
  GoogleMapController? mapController;
  int formNumber = 0;
  final List<String> types = [
    'Book',
    'Goods',
    'Cosmetices',
    'Electronic',
    'Medicine',
    'Computer',
  ];
  String? selectedType;
  String selectedPayment = 'Mastercard';

  Future<void> _selectLocation() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const LocationPickerScreen(),
      ),
    );

    if (result != null && result is LatLng) {
      setState(() {
        selectedLocation = result;
      });
    }
  }

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
      body: formNumber == 0
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  _buildSteps(),
                  const SizedBox(height: 20),
                  _buildAddressCard(),
                  const SizedBox(height: 20),
                  _buildMapPreview(),
                  const Spacer(),
                  SizedBox(
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
                        setState(() {
                          formNumber += 1;
                        });
                      },
                      child: Text('Continue',
                          style: GlobalTypography.sub1Medium
                              .copyWith(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            )
          : formNumber == 1
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 24),
                      child: _buildSteps(),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _sectionTitle("Sender details"),
                            const SizedBox(height: 12),
                            _inputCard(children: [
                              _inputField("Enter sender name"),
                              _inputField("Enter sender phone"),
                              _inputField("Sender remarks", maxLines: 4),
                            ]),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _sectionTitle("Receiver details"),
                                Text("Save for later",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey[700])),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _inputCard(children: [
                              _inputField("Enter receiver name"),
                              _inputField("Enter receiver phone"),
                              _inputField("Sender remarks", maxLines: 4),
                            ]),
                            const SizedBox(height: 24),
                            _sectionTitle("Choose type"),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: types.map((type) {
                                final isSelected = selectedType == type;
                                return ChoiceChip(
                                  label: Text(type),
                                  selected: isSelected,
                                  onSelected: (_) {
                                    setState(() {
                                      selectedType = type;
                                    });
                                  },
                                  selectedColor: Colors.red.shade100,
                                  backgroundColor: Colors.grey.shade200,
                                  labelStyle: TextStyle(
                                    color: isSelected
                                        ? Colors.red.shade700
                                        : Colors.black,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 36),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    formNumber += 1;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: GlobalColors.flushMahogany,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text("Continue",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white)),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      _buildSteps(),
                      const SizedBox(height: 20),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _sectionTitle("Address details"),
                              const SizedBox(height: 12),
                              _buildAddressCardStep3(),
                              const SizedBox(height: 24),
                              _sectionTitle("Payment method"),
                              const SizedBox(height: 12),
                              _buildPaymentOption("Mastercard"),
                              const SizedBox(height: 8),
                              _buildPaymentOption("Visa"),
                              const SizedBox(height: 24),
                              _sectionTitle("Order summary"),
                              const SizedBox(height: 12),
                              _buildOrderSummary(),
                              const SizedBox(height: 30),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Total (incl. VAT)",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                      Text(
                                        "\$47.00",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: GlobalColors.flushMahogany,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // Show snackbar first
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text('Order submitted'),
                                            duration: Duration(seconds: 2),
                                            backgroundColor: Colors.green,
                                          ),
                                        );

                                        // Navigate after a short delay (optional, for smooth UX)
                                        Future.delayed(
                                            const Duration(milliseconds: 600),
                                            () {
                                          Navigator.pushNamed(
                                              context, HomeScreen.id);
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            GlobalColors.flushMahogany,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 14, horizontal: 40),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                        ),
                                      ),
                                      child: const Text("Submit",
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildSteps() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildStepItem(
            'locations', "Locations", formNumber == 0 ? false : true),
        Expanded(
          child: Transform.translate(
            offset: const Offset(0, -12),
            child: Divider(
              thickness: 2,
              color: formNumber == 0
                  ? Colors.grey.shade400
                  : GlobalColors.flushMahogany,
            ),
          ),
        ),
        _buildStepItem(
            'information', "Information", formNumber < 2 ? false : true),
        Expanded(
          child: Transform.translate(
            offset: const Offset(0, -12),
            child: Divider(
                thickness: 2,
                color: formNumber < 2
                    ? Colors.grey.shade400
                    : GlobalColors.flushMahogany),
          ),
        ),
        _buildStepItem(
            'confirmation', "Confirmation", formNumber < 3 ? false : true),
      ],
    );
  }

  Widget _buildStepItem(String icon, String label, bool active) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor:
              active ? GlobalColors.flushMahogany : GlobalColors.secondary,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: active
                ? const Icon(
                    Icons.done,
                    color: Colors.white,
                  )
                : Image.asset('assets/icons/$icon.png'),
          ),
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
        IconButton(
          icon: Icon(Icons.edit, color: GlobalColors.black400, size: 18),
          onPressed: _selectLocation,
        )
      ],
    );
  }

  Widget _buildMapPreview() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: GlobalColors.black100),
      ),
      clipBehavior: Clip.hardEdge,
      child: selectedLocation == null
          ? const Center(child: Text('No location selected'))
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: selectedLocation!,
                zoom: 14,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId("selected"),
                  position: selectedLocation!,
                ),
              },
              onMapCreated: (controller) {
                mapController = controller;
              },
              zoomControlsEnabled: false,
            ),
    );
  }

  Widget _inputCard({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: children
            .map((widget) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: widget,
                ))
            .toList(),
      ),
    );
  }

  Widget _inputField(String hint, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }

  Widget _buildAddressCardStep3() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _addressRow(
            label: "Collect from",
            subLabel: "Sender address",
            address:
                "Kilometer 6, 278H, Street 201R, Kroalkor Village, Unnamed Road, Phnom Penh",
            editable: true,
          ),
          const SizedBox(height: 16),
          _addressRow(
            label: "Delivery to",
            subLabel: "Receiver address",
            address:
                "2nd Floor 01, 25 Mao Tse Toung Blvd (245), Phnom Penh 12302, Cambodia",
            editable: true,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Colors.white,
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.access_time, size: 18, color: Colors.black54),
                SizedBox(width: 6),
                Text("Take around 20 min", style: TextStyle(fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _addressRow({
    required String label,
    required String subLabel,
    required String address,
    bool editable = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.location_pin, color: GlobalColors.flushMahogany, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text(subLabel,
                  style: const TextStyle(fontSize: 13, color: Colors.black54)),
              const SizedBox(height: 4),
              Text(address, style: const TextStyle(fontSize: 13)),
            ],
          ),
        ),
        if (editable) const Icon(Icons.edit, size: 18, color: Colors.black45),
      ],
    );
  }

  Widget _buildPaymentOption(String name) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPayment = name;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.credit_card, color: GlobalColors.flushMahogany),
            const SizedBox(width: 12),
            Expanded(
              child: Text(name, style: const TextStyle(fontSize: 14)),
            ),
            Icon(
              selectedPayment == name
                  ? Icons.check_circle
                  : Icons.radio_button_off,
              color: selectedPayment == name
                  ? GlobalColors.flushMahogany
                  : Colors.black26,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _summaryRow("Type", "Cosmetic"),
          const SizedBox(height: 8),
          _summaryRow("Base Fare", "\$10.00"),
          const SizedBox(height: 8),
          _summaryRow("Distance", "\$32.00"),
          const SizedBox(height: 8),
          _summaryRow("Platform Charge", "\$5.00"),
          const Divider(height: 24, thickness: 1),
          _summaryRow("Subtotal", "\$47.00", bold: true),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            )),
        Text(value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            )),
      ],
    );
  }
}
