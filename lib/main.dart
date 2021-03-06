import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter/helpers/custom_route.dart';

import 'providers/auth.dart';
import 'providers/cart.dart';
import 'providers/orders.dart';
import 'providers/products.dart';

import 'pages/auth_page.dart';
import 'pages/cart_page.dart';
import 'pages/edit_product_page.dart';
import 'pages/orders_page.dart';
import 'pages/product_detail_page.dart';
import 'pages/products_overview_page.dart';
import 'pages/splash_page.dart';
import 'pages/user_products_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (ctx) => Products([], '', ''),
          update: (ctx, auth, previousProducts) => Products(
            previousProducts == null ? [] : previousProducts.items,
            auth.userId,
            auth.token,
          ),
        ),
        ChangeNotifierProvider(create: (ctx) => Cart()),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (ctx) => Orders([], '', ''),
          update: (ctx, auth, previousOrders) => Orders(
            previousOrders == null ? [] : previousOrders.orders,
            auth.userId,
            auth.token,
          ),
        )
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.red,
            primaryColor: Color.fromRGBO(120, 70, 150, 1),
            accentColor: Color.fromRGBO(230, 140, 90, 1),
            fontFamily: 'Lato',
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                TargetPlatform.android: CustomPageTransitionBuilder(),
                TargetPlatform.iOS: CustomPageTransitionBuilder(),
                TargetPlatform.windows: CustomPageTransitionBuilder(),
              },
            ),
          ),
          home: auth.isAuth
              ? ProductsOverviewsPage()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashPage()
                          : AuthPage(),
                ),
          routes: {
            ProductDetailPage.routeName: (ctx) => ProductDetailPage(),
            CartPage.routeName: (ctx) => CartPage(),
            OrdersPage.routeName: (ctx) => OrdersPage(),
            UserProductsPage.routeName: (ctx) => UserProductsPage(),
            EditProductPage.routeName: (ctx) => EditProductPage(),
            AuthPage.routeName: (ctx) => AuthPage(),
            ProductsOverviewsPage.routeName: (ctx) => ProductDetailPage(),
          },
        ),
      ),
    );
  }
}
