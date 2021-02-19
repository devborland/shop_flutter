import 'package:flutter/material.dart';

import '../widgets/product_grid.dart';

class ProductsOverviesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('MyShop')),
      body: ProductsGrid(),
    );
  }

///////////////////////////////////////////////////

}
