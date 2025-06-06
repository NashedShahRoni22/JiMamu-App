import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:jimamu/constant/color_path.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../../../../../constant/global_typography.dart';
import '../../../../../../model/order_details.dart';
import '../../../../../../model/rider_offer_model.dart';
import '../../../../../../service/order_service.dart';

class OrderDetailsScreen extends StatefulWidget {
  final OrderDetails orderDetails;
  const OrderDetailsScreen({required this.orderDetails, super.key});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  int type = 0;

  RiderOffer? acceptedRider;
  String? pickupLocation;
  String? dropoffLocation;

  bool isLoading = true;

  @override
  void initState() {
    if (widget.orderDetails.status != 'pending') {
      acceptedRider = RiderOffer(
          name: widget.orderDetails.orderAttempts[0].riderBids[0].name,
          imagePath:
              widget.orderDetails.orderAttempts[0].riderBids[0].profileImage ??
                  '', // fallback
          offerAmount: widget
              .orderDetails.orderAttempts[0].riderBids[0].bidAmount
              .toDouble(),
          rating: 4.5,
          phone: widget.orderDetails.orderAttempts[0].riderBids[0].phone ?? '');
      widget.orderDetails.orderAttempts[0].riderBids.clear();
    }
    loadLocations();
    super.initState();
  }

  void loadLocations() async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      widget.orderDetails.pickupLat,
      widget.orderDetails.pickupLng,
    );
    final place = placemarks.first;
    pickupLocation =
        "${place.name}, ${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}";
    placemarks = await placemarkFromCoordinates(
      widget.orderDetails.dropLat,
      widget.orderDetails.dropLng,
    );
    final place2 = placemarks.first;
    dropoffLocation =
        "${place2.name}, ${place2.street}, ${place2.locality}, ${place2.administrativeArea}, ${place2.postalCode}, ${place2.country}";
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders Details'),
        backgroundColor: Colors.white,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: ColorPath.flushMahogany,
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Order Id:',
                            style: GlobalTypography.bodyRegular,
                          ),
                          Text(
                            '#${widget.orderDetails.orderId}',
                            style: GlobalTypography.sub1Medium,
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recipient:',
                            style: GlobalTypography.bodyRegular,
                          ),
                          Text(
                            widget.orderDetails.receiver.name,
                            style: GlobalTypography.bodyRegular,
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Mobile:',
                            style: GlobalTypography.bodyRegular,
                          ),
                          Text(
                            widget.orderDetails.receiver.phone,
                            style: GlobalTypography.bodyRegular,
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'From',
                            style: GlobalTypography.bodyRegular
                                .copyWith(color: ColorPath.white600),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            pickupLocation!,
                            style: GlobalTypography.bodyRegular,
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'To',
                            style: GlobalTypography.bodyRegular
                                .copyWith(color: ColorPath.white600),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            dropoffLocation!,
                            style: GlobalTypography.bodyRegular,
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      thickness: 2,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Fare',
                            style: GlobalTypography.bodyRegular,
                          ),
                          Text(
                            '\$${widget.orderDetails.orderAttempts[0].fare}',
                            style: GlobalTypography.sub1Bold,
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 24,
                    ),
                    if (acceptedRider != null)
                      buildAcceptedRiderStatus()
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    'Offers (${widget.orderDetails.orderAttempts[0].riderBids.length}/5)',
                                    style: GlobalTypography.sub2Medium
                                        .copyWith(color: ColorPath.black700)),
                                Text('See all',
                                    style: GlobalTypography.bodyMedium),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          ...widget.orderDetails.orderAttempts[0].riderBids
                              .asMap()
                              .entries
                              .map(
                                (entry) =>
                                    buildRiderOffer(entry.value, entry.key),
                              )
                        ],
                      ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildRiderOffer(RiderBid riderBid, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: riderBid.profileImage != null
                ? NetworkImage(riderBid.profileImage!)
                : const AssetImage('assets/auth/profile.png') as ImageProvider,
          ),
          const SizedBox(width: 12),
          Container(
            width: MediaQuery.of(context).size.width - 104,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              color: ColorPath.secondary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset('assets/icons/Star.png', height: 14),
                        Text(' 4.5', style: GlobalTypography.p2Medium),
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3.5,
                      child: Text('${riderBid.name} offered you',
                          style: GlobalTypography.pMedium),
                    ),
                    Text('\$${riderBid.bidAmount}',
                        style: GlobalTypography.bodyBold),
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.orderDetails.orderAttempts[0].riderBids
                              .removeAt(index);
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: ColorPath.flushMahogany,
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: Text('Reject',
                            style: GlobalTypography.bodyRegular
                                .copyWith(color: ColorPath.white)),
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () async {
                        final attempt = widget.orderDetails.orderAttempts[0];
                        final orderId = widget.orderDetails.orderId;
                        final subOrderId = attempt.trackingNumber;
                        final riderId = riderBid.riderId;

                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) =>
                              const Center(child: CircularProgressIndicator()),
                        );

                        final success = await OrderService.confirmRider(
                            orderId, subOrderId, riderId);

                        Navigator.pop(context); // Close the loading dialog

                        if (success) {
                          setState(() {
                            acceptedRider = RiderOffer(
                                name: riderBid.name,
                                imagePath:
                                    'assets/icons/profile.png', // fallback
                                offerAmount: riderBid.bidAmount.toDouble(),
                                rating: 4.5,
                                phone: riderBid.phone);
                            widget.orderDetails.orderAttempts[0].riderBids
                                .clear();
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Rider accepted successfully."),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Failed to confirm rider."),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: ColorPath.green300,
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child:
                            Text('Accept', style: GlobalTypography.bodyRegular),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildAcceptedRiderStatus() {
    final List<Map<String, dynamic>> steps = [
      {
        'label': 'Confirmed',
        'iconActive': 'assets/icons/confirmed.png',
        'iconInactive': 'assets/icons/confirmed_not.png',
      },
      {
        'label': 'Picked',
        'iconActive': 'assets/icons/picked.png',
        'iconInactive': 'assets/icons/picked_not.png',
      },
      {
        'label': 'Shipping',
        'iconActive': 'assets/icons/shipping.png',
        'iconInactive': 'assets/icons/shipping_not.png',
      },
      {
        'label': 'Delivered',
        'iconActive': 'assets/icons/delivered.png',
        'iconInactive': 'assets/icons/delivered_not.png',
      },
    ];

    // Map status to index for coloring
    Map<String, int> statusIndex = {
      'pending': -1,
      'confirmed': 0,
      'picked': 2,
      'delivered': 3,
    };

    int activeStep =
        statusIndex[widget.orderDetails.status.toLowerCase()] ?? -1;

    return Column(
      children: [
        // Accepted Rider Info
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: ColorPath.secondary,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: ColorPath.black.withOpacity(0.25),
                blurRadius: 1,
                offset: const Offset(0, 1),
              )
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage(acceptedRider!.imagePath),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Mr ${acceptedRider!.name}',
                        style: GlobalTypography.bodyBold),
                    Text('48 trials completed',
                        style: GlobalTypography.bodyRegular),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () async {
                  String phoneNumber =
                      acceptedRider!.phone; // Replace with the actual number
                  if (await canLaunchUrl(Uri.parse('tel:$phoneNumber'))) {
                    await launchUrl(Uri.parse('tel:$phoneNumber'));
                  } else {
                    Get.snackbar("Error", "Could not launch phone app");
                  }
                },
                child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: ColorPath.green300),
                    child: const Text('Call Now')),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // Timeline Steps
        Padding(
          padding: const EdgeInsets.only(left: 32.0),
          child: Column(
            children: List.generate(steps.length, (index) {
              final bool isActive = index <= activeStep;
              final Color labelColor =
                  isActive ? ColorPath.black : ColorPath.black400;
              final String iconPath = isActive
                  ? steps[index]['iconActive']
                  : steps[index]['iconInactive'];
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: !isActive
                                ? Colors.white60
                                : ColorPath.flushMahogany,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: ColorPath.black.withOpacity(0.25),
                                blurRadius: 1,
                                offset: const Offset(0, 1),
                              )
                            ],
                          ),
                          child: !isActive
                              ? Image.asset(iconPath, height: 20)
                              : Icon(
                                  Icons.done,
                                  size: 20,
                                  weight: 10,
                                  color: ColorPath.white,
                                ),
                        ),
                      ),
                      if (index != steps.length - 1)
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          width: 2,
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: isActive
                                    ? ColorPath.flushMahogany.withOpacity(0.5)
                                    : ColorPath.white600,
                                width: 2,
                                style: BorderStyle.solid,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      steps[index]['label'],
                      style: GlobalTypography.bodyBold.copyWith(
                        color: labelColor,
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}
