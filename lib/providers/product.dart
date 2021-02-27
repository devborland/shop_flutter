import 'dart:io';

import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.price,
    @required this.description,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavoriteStatus() async {
    isFavorite = !isFavorite;
    notifyListeners();

    final url = Uri.parse(
        'https://my-shop-a5f0b-default-rtdb.firebaseio.com/products/$id.json');

    final responce = await http.patch(
      url,
      body: json.encode({'isFavorite': isFavorite}),
    );

    if (responce.statusCode >= 400) {
      isFavorite = !isFavorite;
      notifyListeners();
      throw HttpException('Could not toggle Favorite status');
    }
  }
}
