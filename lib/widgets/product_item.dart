import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/product.dart';
import '../pages/product_detail_page.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    // final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);

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
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder: AssetImage('assets/images/product_placeholder.png'),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
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
              onPressed: () async {
                try {
                  await product.toggleFavoriteStatus(
                    authData.token,
                    authData.userId,
                  );
                } catch (_) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Could not toggle Favorite',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
              },
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
                  snackLabel = 're-Add';
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
