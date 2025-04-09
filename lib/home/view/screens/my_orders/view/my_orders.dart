import 'package:flutter/material.dart';
import 'package:jimamu/global_consts/global_colors.dart';
import 'package:jimamu/global_consts/global_typography.dart';
import 'package:jimamu/home/view/screens/my_orders/view/widgets/order_card.dart';

class MyOrders extends StatefulWidget {
  static const String id = 'MyOrders';
  const MyOrders({super.key});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  int type = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTabBar(),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: 2, // replace with your actual list
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      OrderCard(
                        orderId: '#8T9G88P',
                        date: '14 May 2023',
                        from: '1234 Elm Street Springfield, IL 62701',
                        to: '5678 Maple Avenue Seattle, WA 98101',
                        status: 'Processing',
                        onPressed: () {},
                      ),
                      const SizedBox(height: 12),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Row(
      children: [
        _buildTab('Ongoing Orders', 0),
        const SizedBox(width: 8),
        _buildTab('History', 1),
      ],
    );
  }

  Widget _buildTab(String label, int index) {
    final isSelected = type == index;
    return InkWell(
      onTap: () => setState(() => type = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected ? GlobalColors.flushMahogany : GlobalColors.secondary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: GlobalTypography.pMedium.copyWith(
            color: isSelected ? GlobalColors.white : GlobalColors.black,
          ),
        ),
      ),
    );
  }
}
