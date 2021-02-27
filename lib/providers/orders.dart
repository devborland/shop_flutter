import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'cart.dart';

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final ordersUrl = Uri.parse(
        'https://my-shop-a5f0b-default-rtdb.firebaseio.com/orders.json');
    final orderResponce = await http.post(ordersUrl,
        body: json.encode(
          {
            'amount': total,
            'dateTime': DateFormat('dd-MM-yyyy  hh:mm').format(DateTime.now()),
          },
        ));

    final orderId = json.decode(orderResponce.body)['name'];
    final orderItemsUrl = Uri.parse(
        'https://my-shop-a5f0b-default-rtdb.firebaseio.com/orders/$orderId/orderItems.json');

    cartProducts.forEach((prod) async {
      await http.post(orderItemsUrl,
          body: json.encode({
            'prodTitle': prod.title,
            'prodPrice': prod.price,
            'prodQuantity': prod.quantity,
          }));
    });

    _orders.insert(
      0,
      OrderItem(
        amount: total,
        dateTime: DateTime.now(),
        id: orderId,
        products: cartProducts,
      ),
    );
    notifyListeners();
  }

  Future<void> fetchOrders() async {
    final ordersUrl = Uri.parse(
        'https://my-shop-a5f0b-default-rtdb.firebaseio.com/orders.json');

    try {
      //..
      final ordersResponce = await http.get(ordersUrl);

      final orderData =
          json.decode(ordersResponce.body) as Map<String, dynamic>;
      final orderIds = orderData.keys;

      orderIds.forEach((orderId) {
        List<CartItem> cartItems = [];
        // print(orderId);
        // print(orderData[orderId]['dateTime']);
        // print(orderData[orderId]['amount']);

        final orderItemsId = orderData[orderId]['orderItems'].keys;

        orderItemsId.forEach((orderItemId) {
          // print(orderItemId);
          // print(orderData[orderId]['orderItems'][orderItemId]['prodTitle']);
          // print(orderData[orderId]['orderItems'][orderItemId]['prodPrice']);
          // print(orderData[orderId]['orderItems'][orderItemId]['prodQuantity']);

          // print('-------------');
          cartItems.add(CartItem(
            id: orderItemId,
            title: orderData[orderId]['orderItems'][orderItemId]['prodTitle'],
            price: orderData[orderId]['orderItems'][orderItemId]['prodPrice'],
            quantity: orderData[orderId]['orderItems'][orderItemId]
                ['prodQuantity'],
          ));
        });
        //TODO DateFormating

        // DateFormat format = DateFormat("dd-MM-yyyy hh:mm");
        // print(format.parse(orderData[orderId]['dateTime']));
        _orders.add(
          OrderItem(
            amount: orderData[orderId]['amount'],
            // dateTime: format.parse(orderData[orderId]['dateTime']),
            dateTime: DateTime.now(),
            id: orderId,
            products: cartItems,
          ),
        );
      });
    } catch (e) {
      //..
      print('No orders');
    }
  }
}

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.amount,
    @required this.dateTime,
    @required this.id,
    @required this.products,
  });
}
