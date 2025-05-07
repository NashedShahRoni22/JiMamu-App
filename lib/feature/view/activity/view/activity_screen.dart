import 'package:flutter/material.dart';
import 'package:jimamu/feature/view/home/view/widgets/service_grid.dart';

class ActivityScreen extends StatelessWidget {
  ActivityScreen({super.key});

  final List<Map<String, String>> _services = [
    {
      'icon': 'assets/home/service_icon3.png',
      'title': 'My Deliveries',
    },
    {
      'icon': 'assets/home/service_icon4.png',
      'title': 'My Orders',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Activity'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ServicesGrid(
          services: _services,
        ),
      ),
    );
  }
}
