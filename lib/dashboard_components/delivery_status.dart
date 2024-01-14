import 'package:flutter/material.dart';
import 'package:untitled3/dashboard_components/delivered_orders.dart';
import 'package:untitled3/dashboard_components/preparing_orders.dart';
import 'package:untitled3/dashboard_components/shipping_orders.dart';

class DeliveryStatus extends StatelessWidget {
  const DeliveryStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: const Text(
            'Delivery Status',
          ),
          bottom: const TabBar(
            indicatorColor: Colors.yellow,
            indicatorWeight: 8,
            tabs: [
            RepeatedTab(label: 'Preparing'),
            RepeatedTab(label: 'Shipping'),
            RepeatedTab(label: 'Delivered'),
          ],),
        ),
        body: const TabBarView(
          children: [
            Preparing(),
            Shipping(),
            Delivered(),
          ],
        ),
      ),
    );
  }
}

class RepeatedTab extends StatelessWidget {
  final String label;
  const RepeatedTab({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Center(
        child: Text(
          label, style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
