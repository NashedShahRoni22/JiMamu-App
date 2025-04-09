import 'package:flutter/material.dart';
import 'package:jimamu/global_consts/global_colors.dart';
import 'package:jimamu/global_consts/global_typography.dart';

import '../models/rider_offer_model.dart';

class OrderDetailsScreen extends StatefulWidget {
  static const String id = 'OrderDetailsScreen';
  const OrderDetailsScreen({super.key});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
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
                      '#8T9G88P',
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
                      'Jonathan Anderson',
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
                      '01700000000',
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
                          .copyWith(color: GlobalColors.white600),
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
                          .copyWith(color: GlobalColors.white600),
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
                      '\$180',
                      style: GlobalTypography.sub1Bold,
                    ),
                  ],
                ),
              ),
              const Divider(),
              const SizedBox(
                height: 16,
              ),
              if (acceptedRider != null)
                buildAcceptedRiderStatus()
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Offers (${riderOffers.length}/5)',
                            style: GlobalTypography.sub2Medium
                                .copyWith(color: GlobalColors.black700)),
                        Text('See all', style: GlobalTypography.bodyMedium),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...riderOffers.asMap().entries.map((entry) {
                      return buildRiderOffer(entry.value, entry.key);
                    })
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRiderOffer(RiderOffer rider, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          CircleAvatar(
              radius: 30, backgroundImage: AssetImage(rider.imagePath)),
          const SizedBox(width: 12),
          Container(
            width: MediaQuery.of(context).size.width - 104,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              color: GlobalColors.secondary,
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
                        Text(' ${rider.rating}',
                            style: GlobalTypography.p2Medium),
                      ],
                    ),
                    Text('${rider.name} offered you',
                        style: GlobalTypography.pMedium),
                    Text('\$${rider.offerAmount}',
                        style: GlobalTypography.bodyBold),
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          riderOffers.removeAt(index);
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: GlobalColors.flushMahogany,
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: Text('Reject',
                            style: GlobalTypography.bodyRegular
                                .copyWith(color: GlobalColors.white)),
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          acceptedRider = rider;
                          riderOffers.clear();
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: GlobalColors.green300,
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
    List<Map<String, dynamic>> steps = [
      {'label': 'Confirmed', 'icon': 'assets/icons/confirmed.png'},
      {'label': 'Picked', 'icon': 'assets/icons/picked.png'},
      {'label': 'Shipping', 'icon': 'assets/icons/shipping.png'},
      {'label': 'Delivered', 'icon': 'assets/icons/delivered.png'},
    ];

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
              color: GlobalColors.secondary,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: GlobalColors.black.withOpacity(0.25),
                    blurRadius: 1,
                    offset: Offset(0, 1))
              ]),
          child: Row(
            children: [
              CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage(acceptedRider!.imagePath)),
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
              Icon(Icons.call, color: GlobalColors.flushMahogany)
            ],
          ),
        ),
        const SizedBox(height: 36),
        Padding(
          padding: const EdgeInsets.only(left: 32.0),
          child: Column(
            children: List.generate(steps.length, (index) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: GlobalColors.secondary,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                    color: GlobalColors.black.withOpacity(0.25),
                                    blurRadius: 1,
                                    offset: Offset(0, 1))
                              ]),
                          child: Image.asset(steps[index]['icon'], height: 20),
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
                                color:
                                    GlobalColors.flushMahogany.withOpacity(0.5),
                                width: 2,
                                style: BorderStyle.solid,
                              ),
                            ),
                          ),
                        )
                    ],
                  ),
                  const SizedBox(width: 12),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      steps[index]['label'],
                      style: GlobalTypography.bodyBold,
                    ),
                  ),
                ],
              );
            }),
          ),
        )
      ],
    );
  }
}
