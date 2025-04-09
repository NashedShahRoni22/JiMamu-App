import 'package:flutter/material.dart';
import 'package:jimamu/global_consts/global_colors.dart';
import 'package:jimamu/global_consts/global_typography.dart';
import 'package:jimamu/home/view/screens/my_orders/view/widgets/dotted_line.dart';
import 'package:jimamu/home/view/screens/my_orders/view/widgets/measure_size.dart';

class OrderCard extends StatefulWidget {
  final String orderId;
  final String date;
  final String from;
  final String to;
  final String status;
  final VoidCallback onPressed;

  const OrderCard({
    super.key,
    required this.orderId,
    required this.date,
    required this.from,
    required this.to,
    required this.status,
    required this.onPressed,
  });

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  double _addressHeight = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(width: 1, color: GlobalColors.white100),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: GlobalColors.secondary,
                ),
                child: Image.asset('assets/icons/package.png'),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderRow(),
                    const SizedBox(height: 16),
                    _buildAddressSection(),
                    const SizedBox(height: 20),
                    _buildStatusRow(),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: 8,
          top: 4,
          child: IconButton(
            onPressed: widget.onPressed,
            icon: Icon(Icons.arrow_forward_ios, color: GlobalColors.black500),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderRow() {
    return Row(
      children: [
        Text(widget.orderId, style: GlobalTypography.sub1SemiBold),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child:
              CircleAvatar(radius: 2, backgroundColor: GlobalColors.black400),
        ),
        Text(widget.date, style: GlobalTypography.pRegular),
      ],
    );
  }

  Widget _buildAddressSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Column(
            children: [
              CircleAvatar(radius: 2.5, backgroundColor: GlobalColors.black400),
              const SizedBox(height: 4),
              _addressHeight > 0
                  ? DottedLine(height: _addressHeight - 24)
                  : const SizedBox(width: 2),
              const SizedBox(height: 4),
              CircleAvatar(radius: 2.5, backgroundColor: GlobalColors.black400),
            ],
          ),
        ),
        const SizedBox(width: 12),
        MeasureSize(
          onChange: (size) => setState(() => _addressHeight = size.height),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('From', style: GlobalTypography.bodyMedium),
              const SizedBox(height: 4),
              Text(widget.from, style: GlobalTypography.pRegular),
              const SizedBox(height: 16),
              Text('To', style: GlobalTypography.bodyMedium),
              const SizedBox(height: 4),
              Text(widget.to, style: GlobalTypography.pRegular),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusRow() {
    return Row(
      children: [
        Text('Delivery Status:',
            style: GlobalTypography.pRegular
                .copyWith(color: GlobalColors.black400)),
        const SizedBox(width: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: GlobalColors.secondary,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: GlobalColors.black.withOpacity(0.08),
                blurRadius: 2,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: Text(widget.status,
              style: GlobalTypography.pRegular
                  .copyWith(color: GlobalColors.black)),
        ),
      ],
    );
  }
}
