import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'orders_page.dart';

import '../providers/cart.dart';
import '../providers/orders.dart';
import '../widgets/cart_item_widget.dart';

class CartPage extends StatelessWidget {
  static const routeName = '/cart-page';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(12.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Total', style: TextStyle(fontSize: 20)),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .headline6
                              .color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  SizedBox(width: 8.0),
                  OrderButton(cart: cart),
                ],
              ),
            ),
          ),
          SizedBox(height: 12.0),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, i) {
                return CartItemWidget(
                  id: cart.items.values.toList()[i].id,
                  productId: cart.items.keys.toList()[i],
                  price: cart.items.values.toList()[i].price,
                  title: cart.items.values.toList()[i].title,
                  quantity: cart.items.values.toList()[i].quantity,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() => _isLoading = true);
              await Provider.of<Orders>(context, listen: false).addOrder(
                widget.cart.items.values.toList(),
                widget.cart.totalAmount,
              );
              setState(() => _isLoading = false);

              widget.cart.clearCart();

              Navigator.of(context).pushReplacementNamed(OrdersPage.routeName);
            },
      child: _isLoading
          ? CircularProgressIndicator()
          : Text(
              'ORDER NOW',
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
    );
  }
}
