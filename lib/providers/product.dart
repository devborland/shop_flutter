import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

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

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    bool oldFavoriteStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = Uri.parse(
        'https://my-shop-a5f0b-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token');

    try {
      final responce = await http.put(
        url,
        body: json.encode(isFavorite),
      );
      if (responce.statusCode >= 400) {
        isFavorite = oldFavoriteStatus;
        notifyListeners();
        throw HttpException('Could not toggle Favorite status');
      }
    } catch (error) {
      print(error);
      isFavorite = oldFavoriteStatus;
      notifyListeners();
      throw HttpException('Could not toggle Favorite status');
    }
  }
}
