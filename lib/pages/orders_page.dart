import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart';
import '../widgets/app_drawer_widget.dart';
import '../widgets/order_item_widget.dart';

class OrdersPage extends StatelessWidget {
  static const routeName = '/orders-page';

  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: ordersData.orders.length == 0
          ? Center(child: Text('No Orders Yet'))
          : ListView.builder(
              itemCount: ordersData.orders.length,
              itemBuilder: (ctx, i) {
                return OrderItemWidget(ordersData.orders[i]);
              },
            ),
      drawer: AppDrawerWidget(),
    );
  }
}
