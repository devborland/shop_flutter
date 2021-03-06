import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'edit_product_page.dart';
import '../widgets/app_drawer_widget.dart';
import '../widgets/user_product_item_widget.dart';
import '../providers/products.dart';

class UserProductsPage extends StatelessWidget {
  static const routeName = '/user-products-page';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context);
    print('rebuilding...');
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
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<Products>(
                      builder: (ctx, productsData, _) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemCount: productsData.items.length,
                          itemBuilder: (_, i) => Column(
                            children: [
                              UserProductItemWidget(
                                id: productsData.items[i].id,
                                title: productsData.items[i].title,
                                imageUrl: productsData.items[i].imageUrl,
                              ),
                              Divider(color: Colors.grey.shade400),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
