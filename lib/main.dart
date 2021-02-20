import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/product_detail_page.dart';
import 'pages/products_overview_page.dart';
import 'providers/products.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => Products(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MyShop',
        theme: ThemeData(
            primarySwatch: Colors.red,
            primaryColor: Color.fromRGBO(80, 80, 150, 1),
            accentColor: Color.fromRGBO(124, 245, 248, 1),
            fontFamily: 'Lato'),
        home: ProductsOverviesPage(),
        routes: {
          ProductDetailPage.routeName: (ctx) => ProductDetailPage(),
        },
      ),
    );
  }
}
