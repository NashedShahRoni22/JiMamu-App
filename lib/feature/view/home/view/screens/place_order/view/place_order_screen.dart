import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:jimamu/constant/api_path.dart';
import 'package:jimamu/constant/color_path.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jimamu/constant/local_string.dart';
import 'package:jimamu/feature/view/home/view/screens/place_order/view/screens/location_picker_screen.dart';

import '../../../../../../../constant/global_typography.dart';
import '../../../../../../model/token.dart';
import '../../../../model/package_types.dart';
import '../../../../service/order_service.dart';
import '../../../../../../../utils/ui/custom_loading.dart';
import '../../../../model/place_order_request.dart';
import '../../../home_screen.dart';
import 'package:http/http.dart' as http;

class PlaceOrderScreen extends StatefulWidget {
  static const String id = 'PlaceOrderScreen';
  final String type;
  const PlaceOrderScreen({super.key, required this.type});

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  final _formKey = GlobalKey<FormState>();

  String? pickupAddress;
  String? dropoffAddress;

  LatLng? selectedPickupLocation;
  LatLng? selectedDropoffLocation;

  GoogleMapController? mapController;
  int formNumber = 0;
  String? selectedType;
  String selectedPayment = 'Mastercard';
  List<PackageType> packageTypes = [];
  PackageType? selectedPackage;
  double? weight;
  double? value;

  final Map<String, TextEditingController> controllers = {
    'senderName': TextEditingController(),
    'senderPhone': TextEditingController(),
    'senderRemarks': TextEditingController(),
    'receiverName': TextEditingController(),
    'receiverPhone': TextEditingController(),
    'receiverRemarks': TextEditingController(),
  };

  Future<void> fetchPackageTypes({
    required double lat,
    required double lng,
  }) async {
    final uri = Uri.parse(
      '${ApiPath.baseUrl}orders/packages?latitude=$lat&longitude=$lng',
    );
    final Box<Token> tokenBox = Hive.box<Token>(LocalString.TOKEN_BOX);
    Token? token = tokenBox.get('token');

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer ${token?.data?.token}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> list = data['data'];
      setState(() {
        packageTypes = list.map((e) => PackageType.fromJson(e)).toList();
      });
    } else {
      Get.snackbar("Error", "Failed to load package types");
      print("API Error: ${response.body}");
    }
  }

  Future<void> _selectLocation(String point) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const LocationPickerScreen(),
      ),
    );

    if (result != null && result is LatLng) {
      setState(() {
        point == 'pickup'
            ? selectedPickupLocation = result
            : selectedDropoffLocation = result;
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
                        backgroundColor: ColorPath.flushMahogany,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        if (pickupAddress == null ||
                            dropoffAddress == null ||
                            selectedPickupLocation == null) {
                          Get.snackbar(
                            "Error",
                            "Please select Pickup Point and Destination before proceeding",
                            backgroundColor:
                                ColorPath.flushMahogany.withOpacity(0.25),
                          );
                          return;
                        }

                        try {
                          if (formNumber == 0) {
                            CustomLoading.loadingDialog(); // show loading
                            await fetchPackageTypes(
                              lat: selectedPickupLocation!.latitude,
                              lng: selectedPickupLocation!.longitude,
                            );
                            Get.back(); // close loading
                          }
                          setState(() {
                            formNumber += 1;
                          });
                        } catch (e) {
                          Get.back();
                          Get.snackbar(
                              "Error", "Failed to fetch package types");
                        }
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
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _sectionTitle("Sender details"),
                              const SizedBox(height: 12),
                              _inputCard(children: [
                                _inputField("Enter sender name",
                                    controllers['senderName']),
                                _inputField("Enter sender phone",
                                    controllers['senderPhone']),
                                _inputField("Sender remarks",
                                    controllers['senderRemarks'],
                                    maxLines: 4),
                              ]),
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _sectionTitle("Receiver details"),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 12),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: ColorPath.flushMahogany),
                                    child: Text("Save for later",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: ColorPath.white)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              _inputCard(children: [
                                _inputField("Enter receiver name",
                                    controllers['receiverName']),
                                _inputField("Enter receiver phone",
                                    controllers['receiverPhone']),
                                _inputField("Receiver remarks",
                                    controllers['receiverRemarks'],
                                    maxLines: 4),
                              ]),
                              const SizedBox(height: 24),
                              _sectionTitle("Choose type"),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: packageTypes.map((type) {
                                  final isSelected =
                                      selectedPackage?.id == type.id;
                                  return ChoiceChip(
                                    label: Text(type.name),
                                    selected: isSelected,
                                    onSelected: (_) {
                                      setState(() {
                                        selectedPackage = type;
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
                              const SizedBox(height: 30),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Additional Information',
                                    style: GlobalTypography.sub1SemiBold,
                                  ),
                                  GestureDetector(
                                    onTap: () =>
                                        _showAdditionalInfoSheet(context),
                                    child: Container(
                                      padding: EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        color: ColorPath.flushMahogany,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        size: 16,
                                        color: ColorPath.white,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 45),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        formNumber += 1;
                                      });
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ColorPath.flushMahogany,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
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
                              // _sectionTitle("Payment method"),
                              // const SizedBox(height: 12),
                              // _buildPaymentOption("Mastercard"),
                              // const SizedBox(height: 8),
                              // _buildPaymentOption("Visa"),
                              // const SizedBox(height: 24),
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
                                          color: ColorPath.flushMahogany,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        List<Placemark> placemarks =
                                            await placemarkFromCoordinates(
                                          selectedDropoffLocation!.latitude,
                                          selectedDropoffLocation!.longitude,
                                        );
                                        final place = placemarks.first;

                                        final placeOrderRequest =
                                            PlaceOrderRequest(
                                          parcelEstimatePrice: value!,
                                          orderType: widget.type,
                                          orderDestination: OrderDestination(
                                              country: place.country!,
                                              state: place.administrativeArea!,
                                              city: place.locality!,
                                              area: place.subLocality ??
                                                  place.subAdministrativeArea!,
                                              address:
                                                  "${place.name}, ${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}"),
                                          packageId: "1",
                                          pickupLatitude: selectedPickupLocation
                                                  ?.latitude ??
                                              0.0,
                                          pickupLongitude:
                                              selectedPickupLocation
                                                      ?.longitude ??
                                                  0.0,
                                          dropLatitude: selectedDropoffLocation
                                                  ?.latitude ??
                                              0.0,
                                          dropLongitude: selectedDropoffLocation
                                                  ?.longitude ??
                                              0.0,
                                          weight: weight!,
                                          totalFare: 47,
                                          pickupRadius: 1.0,
                                          senderInformation: PersonInfo(
                                            name:
                                                controllers['senderName']!.text,
                                            phoneNumber:
                                                controllers['senderPhone']!
                                                    .text,
                                            remarks:
                                                controllers['senderRemarks']!
                                                    .text,
                                          ),
                                          receiverInformation: PersonInfo(
                                            name: controllers['receiverName']!
                                                .text,
                                            phoneNumber:
                                                controllers['receiverPhone']!
                                                    .text,
                                            remarks:
                                                controllers['receiverRemarks']!
                                                    .text,
                                          ),
                                        );

                                        try {
                                          CustomLoading.loadingDialog();
                                          final response =
                                              await OrderService.placeOrder(
                                                  placeOrderRequest);
                                          Navigator.pop(context);
                                          if (response.statusCode == 200 ||
                                              response.statusCode == 201) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text(
                                                      "Order submitted successfully")),
                                            );
                                            Get.to(() => HomeScreen());
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      "Failed: ${response.body}")),
                                            );
                                          }
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text("Error: $e")),
                                          );
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            ColorPath.flushMahogany,
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

  void _showAdditionalInfoSheet(BuildContext context) {
    final TextEditingController weightController = TextEditingController();
    final TextEditingController valueController = TextEditingController();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (context) {
        weightController.text =
            weight.toString() == 'null' ? '' : weight.toString();
        valueController.text =
            value.toString() == 'null' ? '' : value.toString();
        return Padding(
          padding: MediaQuery.of(context).viewInsets, // handle keyboard overlap
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Text(
                  "Additional information",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: weightController,
                  decoration: InputDecoration(
                    hintText: "Enter weight",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: valueController,
                  decoration: InputDecoration(
                    hintText: "Enter value",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // You can access the values like this:
                      setState(() {
                        weight = double.parse(weightController.text);
                        value = double.parse(valueController.text);
                      });

                      print("Weight: $weight, Value: $value");

                      Navigator.pop(context); // close the bottom sheet
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorPath.flushMahogany,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Confirm",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSteps() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: formNumber > 0
              ? () {
                  setState(() {
                    formNumber = 0;
                  });
                }
              : null,
          child: _buildStepItem(
              'locations', "Locations", formNumber == 0 ? false : true),
        ),
        Expanded(
          child: Transform.translate(
            offset: const Offset(0, -12),
            child: Divider(
              thickness: 2,
              color: formNumber == 0
                  ? Colors.grey.shade400
                  : ColorPath.flushMahogany,
            ),
          ),
        ),
        InkWell(
          onTap: formNumber > 1
              ? () {
                  setState(() {
                    formNumber = 1;
                  });
                }
              : null,
          child: _buildStepItem(
              'information', "Information", formNumber < 2 ? false : true),
        ),
        Expanded(
          child: Transform.translate(
            offset: const Offset(0, -12),
            child: Divider(
                thickness: 2,
                color: formNumber < 2
                    ? Colors.grey.shade400
                    : ColorPath.flushMahogany),
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
              active ? ColorPath.flushMahogany : ColorPath.secondary,
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
              color: active ? ColorPath.black : ColorPath.black400,
            )),
      ],
    );
  }

  Widget _buildAddressCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: ColorPath.secondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildAddressRow(
            label: 'Pickup Point',
            address: pickupAddress,
            onEdit: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LocationPickerScreen()),
              );
              if (result != null && result is Map) {
                setState(() {
                  selectedPickupLocation = result['latLng'];
                  pickupAddress = result['address'];
                });
              }
            },
          ),
          const Divider(height: 28),
          _buildAddressRow(
            label: 'Destination',
            address: dropoffAddress,
            onEdit: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LocationPickerScreen()),
              );
              if (result != null && result is Map) {
                setState(() {
                  selectedDropoffLocation = result['latLng'];
                  dropoffAddress = result['address'];
                });
              }
            },
          ),
        ],
      ),
    );
  }

  _buildAddressRow({
    required String label,
    required String? address,
    required VoidCallback onEdit,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.location_pin, color: ColorPath.flushMahogany),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: GlobalTypography.bodyMedium),
              const SizedBox(height: 4),
              Text(address ?? "Select $label",
                  style: GlobalTypography.pRegular.copyWith(
                    color: address == null ? Colors.grey : Colors.black,
                  )),
            ],
          ),
        ),
        IconButton(
          icon: Icon(Icons.edit, color: ColorPath.black400, size: 18),
          onPressed: onEdit,
        )
      ],
    );
  }

  Widget _buildMapPreview() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorPath.black100),
      ),
      clipBehavior: Clip.hardEdge,
      child: (selectedPickupLocation == null || selectedDropoffLocation == null)
          ? const Center(child: Text('Pickup or Destination not selected'))
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: selectedPickupLocation!,
                zoom: 14,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId("pickup"),
                  position: selectedPickupLocation!,
                  infoWindow: const InfoWindow(title: "Pickup Point"),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueGreen),
                ),
                Marker(
                  markerId: const MarkerId("dropoff"),
                  position: selectedDropoffLocation!,
                  infoWindow: const InfoWindow(title: "Destination"),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed),
                ),
              },
              polylines: {
                Polyline(
                  polylineId: const PolylineId("route"),
                  color: Colors.blue,
                  width: 5,
                  points: [
                    selectedPickupLocation!,
                    selectedDropoffLocation!,
                  ],
                )
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
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 2), color: ColorPath.black.withOpacity(0.1))
          ]),
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

  Widget _inputField(String hint, TextEditingController? controller,
      {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please ${hint[1].toLowerCase() != 'e' ? '' : 'enter '}${hint.toLowerCase()}';
        }
        return null;
      },
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
            address: pickupAddress!,
            editable: true,
          ),
          const SizedBox(height: 16),
          _addressRow(
            label: "Delivery to",
            subLabel: "Receiver address",
            address: dropoffAddress!,
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
        Icon(Icons.location_pin, color: ColorPath.flushMahogany, size: 20),
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
            Icon(Icons.credit_card, color: ColorPath.flushMahogany),
            const SizedBox(width: 12),
            Expanded(
              child: Text(name, style: const TextStyle(fontSize: 14)),
            ),
            Icon(
              selectedPayment == name
                  ? Icons.check_circle
                  : Icons.radio_button_off,
              color: selectedPayment == name
                  ? ColorPath.flushMahogany
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
