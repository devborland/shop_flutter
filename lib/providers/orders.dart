import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'cart.dart';

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;

  Orders(this._orders, this.userId, this.authToken);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final timestamp = DateTime.now();
    final ordersUrl = Uri.parse(
        'https://my-shop-a5f0b-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    final orderResponce = await http.post(ordersUrl,
        body: json.encode(
          {
            'amount': total,
            'dateTime': DateFormat('dd-MM-yyyy hh:mm').format(timestamp),
            // 'dateTime': timestamp.toIso8601String(),
            'products': cartProducts
                .map((cartProd) => {
                      'title': cartProd.title,
                      'quantity': cartProd.quantity,
                      'price': cartProd.price,
                    })
                .toList(),
          },
        ));

    final orderId = json.decode(orderResponce.body)['name'];

    _orders.add(
      OrderItem(
        id: orderId,
        amount: total,
        dateTime: timestamp,
        products: cartProducts,
      ),
    );
    notifyListeners();
  }

  Future<void> fetchOrders() async {
    List<OrderItem> loadedOrders = [];
    DateFormat format = DateFormat("dd-MM-yyyy hh:mm");

    final ordersUrl = Uri.parse(
        'https://my-shop-a5f0b-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');

    try {
      final responce = await http.get(ordersUrl);

      final extractedData = json.decode(responce.body) as Map<String, dynamic>;

      if (extractedData == null) return;

      extractedData.forEach((orderId, orderData) {
        var orderAmount = extractedData[orderId]['amount'];
        var orderDateTime = format.parse(extractedData[orderId]['dateTime']);
        List<CartItem> orderProducts = [];

        orderData.forEach((key, value) {
          if (key == 'products') {
            value.forEach((product) {
              orderProducts.add(CartItem(
                  id: product['id'],
                  price: product['price'],
                  quantity: product['quantity'],
                  title: product['title']));
            });
          }
        });

        loadedOrders.add(OrderItem(
          id: orderId,
          amount: orderAmount,
          dateTime: orderDateTime,
          products: orderProducts,
        ));
      });

      _orders = loadedOrders.reversed.toList();
    } catch (error) {
      print(error);
    }
    notifyListeners();
  }
}

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.dateTime,
    @required this.products,
  });
}
