import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/product.dart';
import '../pages/product_detail_page.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    // final cart = Provider.of<Cart>(context, listen: false);

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
          leading: Consumer<Product>(
            builder: (_, product, __) => IconButton(
              color: Theme.of(context).accentColor,
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
              onPressed: () => product.toggleFavoriteStatus(),
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: Consumer<Cart>(
            builder: (_, cart, __) => IconButton(
              icon: Icon(
                cart.itemInCart(product.id)
                    ? Icons.shopping_cart
                    : Icons.shopping_cart_outlined,
              ),
              color: Theme.of(context).accentColor,
              onPressed: () {
                String snackText;
                String snackLabel;

                if (cart.itemInCart(product.id)) {
                  snackText = '${product.title} has removed';
                  snackLabel = ' ;( ';
                  cart.removeItem(product.id);
                } else {
                  snackText = '${product.title} has added to cart';
                  snackLabel = 'UNDO';
                  cart.addItem(
                    productId: product.id,
                    title: product.title,
                    price: product.price,
                  );
                }
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      snackText,
                      textAlign: TextAlign.center,
                    ),
                    duration: Duration(seconds: 3),
                    action: SnackBarAction(
                      label: snackLabel,
                      onPressed: () {
                        cart.removeSingleItem(product.id);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
