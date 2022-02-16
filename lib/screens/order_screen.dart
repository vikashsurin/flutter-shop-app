import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;

import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/orders';
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Orders"),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.error != null) {
              return const Center(
                child: Text('An error occured'),
              );
            }
          }
          return Consumer<Orders>(
            builder: (context, orderData, child) => ListView.builder(
              itemBuilder: (context, i) =>
                  OrderItem(order: orderData.orders[i]),
              itemCount: orderData.orders.length,
            ),
          );
        },
      ),
    );
  }
}
