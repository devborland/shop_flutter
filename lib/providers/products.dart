import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'product.dart';

class Products with ChangeNotifier {
  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> addProduct(Product product) {
    print('Start Posting to DB');
    final url = Uri.parse(
        'https://my-shop-a5f0b-default-rtdb.firebaseio.com/products.jso');
    return http
        .post(url,
            body: json.encode(
              {
                'title': product.title,
                'description': product.description,
                'price': product.price,
                'isFavorite': product.isFavorite,
              },
            ))
        .then((responce) {
      final newProduct = Product(
        id: json.decode(responce.body)['name'],
        title: product.title,
        price: product.price,
        description: product.description,
        imageUrl: product.imageUrl,
      );

      _items.add(newProduct);
      notifyListeners();
    }).catchError((error) {
      print(error);
      throw error;
    });
  }

  void updateProduct(String id, Product newProduct) {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else
      print('...no product with $id found');
  }

  void deleteProduct(String id) {
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }

  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl: 'https://rohan.imgix.net/product/05325N68.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=934&q=80',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
    Product(
      id: 'p5',
      title: 'A Picture',
      description: 'Whatever you want',
      price: 49.99,
      imageUrl: 'https://picsum.photos/400',
    ),
    Product(
      id: 'p6',
      title: 'A Picture',
      description: 'Whatever you want',
      price: 49.99,
      imageUrl: 'https://picsum.photos/420',
    ),
    Product(
      id: 'p7',
      title: 'A Picture',
      description: 'Whatever you want',
      price: 49.99,
      imageUrl: 'https://picsum.photos/421',
    ),
    Product(
      id: 'p8',
      title: 'A Picture',
      description: 'Whatever you want',
      price: 49.99,
      imageUrl: 'https://picsum.photos/800',
    ),
  ];
}
