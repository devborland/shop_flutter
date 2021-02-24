import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/edit_product_page.dart';
import '../providers/products.dart';

class UserProductItemWidget extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserProductItemWidget({
    this.id,
    this.title,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
      trailing: Container(
        width: 100.0,
        child: Row(
          children: [
            IconButton(
                icon: Icon(Icons.edit),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(EditProductPage.routeName, arguments: id);
                }),
            IconButton(
                icon: Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text('Are you sure?'),
                      content:
                          Text('Do you want to remove item from the Products?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: Text('No'),
                        ),
                        TextButton(
                          onPressed: () {
                            Provider.of<Products>(
                              context,
                              listen: false,
                            ).deleteProduct(id);
                            Navigator.of(ctx).pop(true);
                          },
                          child: Text('Yes'),
                        ),
                      ],
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
