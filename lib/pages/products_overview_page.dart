import 'package:flutter/material.dart';

import '../widgets/product_grid.dart';

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
  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context, listen: false);
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
          )
        ],
      ),
      body: ProductsGrid(_showFavoritesOnly),
    );
  }
}
