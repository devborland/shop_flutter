import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetailPage extends StatelessWidget {
  // final String title;
  // final double price;

  // ProductDetailPage(this.title, this.price);

  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;

    final loadedProduct = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);

    ///...
    return Scaffold(
      appBar: AppBar(title: Text(loadedProduct.title)),
      body: Center(
        child: Text(loadedProduct.description),
      ),
    );
  }
}
