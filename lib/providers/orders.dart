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

      List<OrderItem> loadedOrders = [];
      orderIds.forEach((orderId) {
        List<CartItem> cartItems = [];

        final orderItemsId = orderData[orderId]['orderItems'].keys;

        orderItemsId.forEach((orderItemId) {
          cartItems.add(CartItem(
            id: orderItemId,
            title: orderData[orderId]['orderItems'][orderItemId]['prodTitle'],
            price: orderData[orderId]['orderItems'][orderItemId]['prodPrice'],
            quantity: orderData[orderId]['orderItems'][orderItemId]
                ['prodQuantity'],
          ));
        });

        DateFormat format = DateFormat("dd-MM-yyyy  hh:mm");
        loadedOrders.add(
          OrderItem(
            amount: orderData[orderId]['amount'],
            dateTime: format.parse(orderData[orderId]['dateTime']),
            id: orderId,
            products: cartItems,
          ),
        );
      });
      _orders = loadedOrders;
    } catch (e) {
      //..
      print('No orders');
    }
    _orders.forEach((element) {
      print(element.id);
    });
    notifyListeners();
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
