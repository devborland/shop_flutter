import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'edit_product_page.dart';
import '../widgets/app_drawer_widget.dart';
import '../widgets/user_product_item_widget.dart';
import '../providers/products.dart';

class UserProductsPage extends StatelessWidget {
  static const routeName = '/user-products-page';

  Future<void> _refreshProducts(BuildContext context) async {
    Provider.of<Products>(context, listen: false).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 16.0),
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductPage.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawerWidget(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: products.items.length,
            itemBuilder: (_, i) => Column(
              children: [
                UserProductItemWidget(
                  id: products.items[i].id,
                  title: products.items[i].title,
                  imageUrl: products.items[i].imageUrl,
                ),
                Divider(color: Colors.grey.shade400),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
