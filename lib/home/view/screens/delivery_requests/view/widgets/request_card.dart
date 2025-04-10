import 'package:flutter/material.dart';
import 'package:jimamu/global_consts/global_colors.dart';
import 'package:jimamu/global_consts/global_typography.dart';
import 'package:jimamu/home/view/screens/my_orders/view/widgets/dotted_line.dart';
import 'package:jimamu/home/view/screens/my_orders/view/widgets/measure_size.dart';

class RequestCard extends StatefulWidget {
  final String orderId;
  final String date;
  final String from;
  final String to;
  final int bid;
  final VoidCallback onPressed;

  const RequestCard({
    super.key,
    required this.orderId,
    required this.date,
    required this.from,
    required this.to,
    required this.bid,
    required this.onPressed,
  });

  @override
  State<RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
  double _addressHeight = 0;
  int _currentBid = 0;

  @override
  void initState() {
    super.initState();
    _currentBid = widget.bid;
  }

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
                    _buildFareRow(),
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

  Widget _buildFareRow() {
    return Row(
      children: [
        Text('Fare:',
            style: GlobalTypography.pRegular
                .copyWith(color: GlobalColors.black400)),
        const SizedBox(width: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 6),
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
          child: Text('\$${_currentBid}',
              style:
                  GlobalTypography.pBold.copyWith(color: GlobalColors.black)),
        ),
        const SizedBox(width: 16),
        InkWell(
          onTap: _showBidPopup,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 6),
            decoration: BoxDecoration(
              color: GlobalColors.flushMahogany,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: GlobalColors.black.withOpacity(0.08),
                  blurRadius: 2,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Text('BID',
                style:
                    GlobalTypography.pBold.copyWith(color: GlobalColors.white)),
          ),
        ),
      ],
    );
  }

  void _showBidPopup() {
    final TextEditingController _controller = TextEditingController();
    int leadingBid = _currentBid;
    int minimalBid = leadingBid - 40;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: GlobalColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.all(20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Your Bids",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Leading Bid"),
                Text("\$$leadingBid.00"),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Minimal Bid"),
                Text("\$$minimalBid.00"),
              ],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Place your offer:",
                  style: TextStyle(color: GlobalColors.flushMahogany)),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter amount",
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final entered = int.tryParse(_controller.text.trim());
                  if (entered != null &&
                      entered <= leadingBid &&
                      entered >= minimalBid) {
                    setState(() {
                      _currentBid = entered;
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Bid placed successfully!"),
                        duration: Duration(seconds: 2),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Enter a valid bid amount"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: GlobalColors.flushMahogany,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("PLACE BID",
                    style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
