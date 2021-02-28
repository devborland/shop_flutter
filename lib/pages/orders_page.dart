import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart';
import '../widgets/app_drawer_widget.dart';
import '../widgets/order_item_widget.dart';

class OrdersPage extends StatelessWidget {
  static const routeName = '/orders-page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchOrders(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (dataSnapshot.error != null) {
            return Center(child: Text('${dataSnapshot.error}'));
          } else {
            return Consumer<Orders>(
                builder: (ctx, ordersData, child) => ListView.builder(
                      itemCount: ordersData.orders.length,
                      itemBuilder: (ctx, i) {
                        return OrderItemWidget(ordersData.orders[i]);
                      },
                    ));
          }
        },
      ),
      drawer: AppDrawerWidget(),
    );
  }
}
