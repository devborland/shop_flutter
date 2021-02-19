import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter/providers/product.dart';
import '../pages/product_detail_page.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;
  // final String description;
  // final double price;
  // bool isFavorite;

  // ProductItem({
  //   @required this.id,
  //   @required this.title,
  //   @required this.imageUrl,
  // });

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: true);
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailPage.routeName,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: IconButton(
            color: Theme.of(context).accentColor,
            icon: Icon(
              product.isFavorite ? Icons.favorite : Icons.favorite_border,
            ),
            onPressed: () {
              product.toggleFavoriteStatus();
              print(product.isFavorite);
            },
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            color: Theme.of(context).accentColor,
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
