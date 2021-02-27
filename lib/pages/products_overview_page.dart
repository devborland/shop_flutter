import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart';

import '../providers/cart.dart';
import '../providers/products.dart';
import '../widgets/app_drawer_widget.dart';
import '../widgets/badge.dart';
import '../widgets/product_grid.dart';
import 'cart_page.dart';

enum FiltersOptions {
  Favorites,
  All,
}

class ProductsOverviesPage extends StatefulWidget {
  @override
  _ProductsOverviesPageState createState() => _ProductsOverviesPageState();
}

class _ProductsOverviesPageState extends State<ProductsOverviesPage> {
  bool _showFavoritesOnly = false;
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void initState() {
    // Provider.of<Products>(context).fetchProducts();//Wont work
    // Future.delayed(Duration.zero).then((value) =>
    //     Provider.of<Products>(context, listen: false).fetchProducts());
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Products>(context, listen: false).fetchProducts();
      await Provider.of<Orders>(context, listen: false).fetchOrders();
    }
    setState(() {
      _isLoading = false;
    });

    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: [
          PopupMenuButton(
            onSelected: (FiltersOptions selectedValue) {
              setState(() {
                if (selectedValue == FiltersOptions.Favorites) {
                  _showFavoritesOnly = true;
                } else {
                  _showFavoritesOnly = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FiltersOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FiltersOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, child) => Badge(
              child: child,
              value: cart.itemsCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartPage.routeName);
              },
            ),
          ),
          SizedBox(
            width: 16.0,
          )
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ProductsGrid(_showFavoritesOnly),
      drawer: AppDrawerWidget(),
    );
  }
}
