import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:jimamu/constant/color_path.dart';
import '../../../../../../../../../constant/global_typography.dart';
import '../../../../../model/order_details.dart';
import '../../../../../model/rider_offer_model.dart';
import '../../../../../service/order_service.dart';

class DeliveryDetailsScreen extends StatefulWidget {
  final OrderDetails orderDetails;
  const DeliveryDetailsScreen({required this.orderDetails, super.key});

  @override
  State<DeliveryDetailsScreen> createState() => _DeliveryDetailsScreenState();
}

class _DeliveryDetailsScreenState extends State<DeliveryDetailsScreen> {
  int type = 0;

  List<RiderOffer> riderOffers = [
    RiderOffer(
        name: "Azad",
        imagePath: "assets/icons/profile.png",
        rating: 4.5,
        offerAmount: 180),
    RiderOffer(
        name: "Shihab",
        imagePath: "assets/icons/profile2.png",
        rating: 4.5,
        offerAmount: 170),
    RiderOffer(
        name: "Orbi",
        imagePath: "assets/icons/profile3.png",
        rating: 4.5,
        offerAmount: 180),
  ];

  RiderOffer? acceptedRider;

  @override
  void initState() {
    if (widget.orderDetails.status != 'pending') {
      acceptedRider = RiderOffer(
        name: widget.orderDetails.orderAttempts[0].riderBids[0].name,
        imagePath:
            widget.orderDetails.orderAttempts[0].riderBids[0].profileImage ??
                '', // fallback
        offerAmount: widget.orderDetails.orderAttempts[0].riderBids[0].bidAmount
            .toDouble(),
        rating: 4.5,
      );
      widget.orderDetails.orderAttempts[0].riderBids.clear();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders Details'),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                      'Road No. 1,Flat A2, High Dream Palace',
                      style: GlobalTypography.bodyRegular,
                    ),
                  ],
                ),
              ),
              const Divider(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                      'Ecb Chattar, Dhaka1206.',
                      style: GlobalTypography.bodyRegular,
                    ),
                  ],
                ),
              ),
              const Divider(
                thickness: 2,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                height: 16,
              ),
              buildAcceptedRiderStatus()
            ],
          ),
        ),
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

    final Map<String, int> statusIndex = {
      'pending': -1,
      'confirmed': 0,
      'picked': 2,
      'delivered': 3,
    };

    final int activeStep =
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
                    Text('40 trials completed',
                        style: GlobalTypography.bodyRegular),
                  ],
                ),
              ),
              Icon(Icons.call, color: ColorPath.flushMahogany),
            ],
          ),
        ),
        const SizedBox(height: 36),
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
                      InkWell(
                        onTap: () async {
                          if (canTapIcon(index)) {
                            final status =
                                widget.orderDetails.status.toLowerCase();

                            if (index == 1 && status == 'confirmed') {
                              // Picked icon
                              await OrderService.sendOtp(
                                  widget.orderDetails.orderId,
                                  'picked',
                                  context);
                              showOtpDialog(
                                context: context,
                                orderId: widget.orderDetails.orderId,
                                otpType: 'picked',
                                onVerified: (otp) {
                                  // Do something after verification
                                },
                              );
                            }

                            if (index == 3 && status == 'shipping') {
                              // Delivered icon
                              await OrderService.sendOtp(
                                  widget.orderDetails.orderId,
                                  'confirmed',
                                  context);
                              showOtpDialog(
                                context: context,
                                orderId: widget.orderDetails.orderId,
                                otpType: 'confirmed',
                                onVerified: (otp) {
                                  // Do something after verification
                                },
                              );
                            }
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white60,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: ColorPath.black.withOpacity(0.25),
                                  blurRadius: 1,
                                  offset: const Offset(0, 1),
                                )
                              ],
                            ),
                            child: Image.asset(iconPath, height: 20),
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
                                color: index < activeStep
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

  bool canTapIcon(int index) {
    switch (widget.orderDetails.status.toLowerCase()) {
      case 'confirmed':
        return index == 1;
      case 'picked':
        return index == 2;
      case 'shipping':
        return index == 3;
      default:
        return false;
    }
  }

  void showOtpDialog({
    required BuildContext context,
    required String orderId,
    required String otpType,
    required Function(String otp) onVerified,
  }) {
    bool isVerifying = false;
    String enteredOtp = '';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: const Text("Enter OTP Code", textAlign: TextAlign.center),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                OtpTextField(
                  numberOfFields: 4,
                  borderColor: ColorPath.black,
                  focusedBorderColor: ColorPath.flushMahogany,
                  showFieldAsBox: true,
                  onCodeChanged: (String code) {},
                  onSubmit: (String code) {
                    enteredOtp = code;
                  },
                ),
                const SizedBox(height: 24),
                isVerifying
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () async {
                            if (enteredOtp.length != 4) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text("Please enter a valid 4-digit OTP"),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                              return;
                            }

                            setState(() => isVerifying = true);

                            final isValid = await OrderService.verifyOtp(
                              orderId,
                              otpType,
                              enteredOtp,
                              context,
                            );

                            setState(() => isVerifying = false);

                            if (isValid) {
                              Navigator.pop(context);
                              onVerified(enteredOtp);
                            }
                          },
                          child: const Text("Verify OTP",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
              ],
            ),
          );
        });
      },
    );
  }
}
